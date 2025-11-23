import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:camera/camera.dart' as cam;
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

part 'ml_ai_providers.g.dart';

// --- 카메라 및 ML Kit Provider (변경 없음) ---

@Riverpod(keepAlive: true)
ImageLabeler imageLabeler(Ref ref) {
  final options = ImageLabelerOptions(confidenceThreshold: 0.7);
  final labeler = ImageLabeler(options: options);
  ref.onDispose(labeler.close);
  return labeler;
}

@Riverpod(keepAlive: true)
class CameraControllerService extends _$CameraControllerService {
  @override
  Future<cam.CameraController> build() async {
    try {
      final cameras = await ref.watch(availableCamerasProvider.future);
      if (cameras.isEmpty) {
        throw Exception('사용 가능한 카메라가 없습니다.');
      }
      final controller = cam.CameraController(
        cameras.first,
        cam.ResolutionPreset.veryHigh,
        enableAudio: false,
      );
      await controller.initialize();
      ref.onDispose(controller.dispose);
      return controller;
    } on cam.CameraException catch (e) {
      debugPrint('카메라 초기화 실패: $e');
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
Future<List<cam.CameraDescription>> availableCameras(Ref ref) async {
  return await cam.availableCameras();
}

// --- UI 상태 Provider (변경 없음) ---

@riverpod
class LatestAnalysisResult extends _$LatestAnalysisResult {
  @override
  String build() => '카메라를 피사체에 비춰주세요...';
  void update(String result) => state = result;
}

@riverpod
class GeneratedPoem extends _$GeneratedPoem {
  @override
  String build() => 'AI가 시적 영감을 기다리고 있습니다.';
  void update(String poem) => state = poem;
}

// ⬇️ [핵심 수정] 올바른 상속 이름을 사용합니다.
@riverpod
class IsVisionPaused extends _$IsVisionPaused {
  @override
  bool build() {
    return false; // 초기값은 false (일시정지 아님)
  }

  // 상태를 반전시키는(toggle) 메서드
  void toggle() {
    state = !state;
  }

  // 상태를 직접 설정하는 메서드
  void set(bool value) {
    state = value;
  }
}

