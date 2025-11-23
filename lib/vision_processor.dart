import 'package:flutter/services.dart';
import 'package:camera/camera.dart' as cam;
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:poet/poem_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ml_ai_providers.dart';

part 'vision_processor.g.dart';

final _orientations = <DeviceOrientation, int>{
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

InputImageRotation? _getRotation(
  cam.CameraDescription camera,
  DeviceOrientation deviceOrientation,
) {
  var rotationCompensation = _orientations[deviceOrientation] ?? 0;
  final sensorOrientation = camera.sensorOrientation;

  if (camera.lensDirection == cam.CameraLensDirection.front) {
    rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
  } else {
    rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
  }
  return InputImageRotationValue.fromRawValue(rotationCompensation);
}

// --- 핵심 로직 클래스 ---

class VisionProcessor {
  final Ref _ref;
  bool _isProcessing = false;
  cam.CameraDescription? _camera;
  
  // ⬇️ 마지막 분석 시간 기록 (속도 조절용)
  DateTime? _lastAnalysisTime;

  VisionProcessor(this._ref);

  void startStreaming(cam.CameraController controller) {
    if (!controller.value.isInitialized || controller.value.isStreamingImages) return;
    controller.startImageStream(_processCameraImage);
  }

  void _processCameraImage(cam.CameraImage image) async {
    // ⬇️ 일시정지 상태면 처리 중단
    if (_ref.read(isVisionPausedProvider)) {
      return;
    }

    // ⬇️ 500ms(0.5초) 간격으로만 처리 (속도 조절)
    final currentTime = DateTime.now();
    if (_lastAnalysisTime != null &&
        currentTime.difference(_lastAnalysisTime!) < const Duration(milliseconds: 500)) {
      return;
    }
    _lastAnalysisTime = currentTime;
    
    if (_isProcessing) return;
    _isProcessing = true;

    final inputImage = await _inputImageFromCameraImage(image);
    if (inputImage == null || !_ref.mounted) {
      _isProcessing = false;
      return;
    }

    try {
      final imageLabeler = _ref.read(imageLabelerProvider);
      final labels = await imageLabeler.processImage(inputImage);
      final labelStrings = labels.map((l) => l.label).toList();

      if (!_ref.mounted) return;
      if (labelStrings.isNotEmpty) {
        _ref.read(latestAnalysisResultProvider.notifier).update(labelStrings.join(', '));
      } else {
        _ref.read(latestAnalysisResultProvider.notifier).update('인식된 객체가 없습니다.');
      }
    } catch (e) {
      if (_ref.mounted) {
        _ref.read(latestAnalysisResultProvider.notifier).update('ML Kit 처리 중 오류 발생');
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<InputImage?> _inputImageFromCameraImage(cam.CameraImage image) async {
    // 이 함수는 변경사항 없음
    if (_camera == null) {
      final cameraList = await _ref.read(availableCamerasProvider.future);
      if (!_ref.mounted || cameraList.isEmpty) return null;
      _camera = cameraList.first;
    }
    const currentDeviceOrientation = DeviceOrientation.portraitUp;
    final rotation = _getRotation(_camera!, currentDeviceOrientation);
    if (rotation == null) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    if (image.planes.length == 1) {
      return InputImage.fromBytes(
        bytes: image.planes[0].bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    } else {
      final allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);

      }
      final bytes = allBytes.done().buffer.asUint8List();
      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    }
  }
  
  // 시 생성 함수 (UI에서 버튼 클릭 시 호출됨)
  void generatePoemFromLabels(String keywords) async {
  if (!_ref.mounted) return;

  try {
    _ref.read(generatedPoemProvider.notifier).update('🌸 Gemini가 시를 생성하는 중...');

    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY가 설정되지 않았습니다.');
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    '당신은 세계적인 시인입니다. 다음 단어들을 소재로 하여 4~6줄의 짧고 감성적인 자유시를 한국어로 써줘: $keywords'
              }
            ]
          }
        ]
      }),
    );

    if (!_ref.mounted) return;

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final generatedText = data['candidates']?[0]?['content']?['parts']?[0]?['text'];

      if (generatedText != null) {
        _ref.read(generatedPoemProvider.notifier).update(generatedText);

        // 📌 여기서 addPoem 실행!!! (정상 코드)
        _ref.read(poemHistoryProvider.notifier).addPoem(generatedText);
      } else {
        _ref.read(generatedPoemProvider.notifier).update('시 생성 실패 (AI 응답 없음)');
      }
    } else {
      _ref.read(generatedPoemProvider.notifier).update('Gemini 오류 (코드: ${response.statusCode})');
    }
  } catch (e) {
    if (_ref.mounted) {
      _ref.read(generatedPoemProvider.notifier).update('네트워크 또는 API 예외 발생');
    }
  }
}
}

// Provider가 자동으로 파괴되지 않도록 keepAlive: true 설정
@Riverpod(keepAlive: true)
VisionProcessor visionProcessor(Ref ref) {
  return VisionProcessor(ref);
}