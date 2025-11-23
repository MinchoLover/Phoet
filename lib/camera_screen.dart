import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart' as cam;
import 'package:google_fonts/google_fonts.dart';

import 'ml_ai_providers.dart';
import 'vision_processor.dart';
import 'poem_gallery_screen.dart';
import 'location_providers.dart'; // Import the new location providers

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  cam.CameraController? _controller;

  @override
  void initState() {
    super.initState();
    // 위젯이 빌드된 후, 카메라를 초기화하고 스트림을 시작합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndStartStream();
    });
  }

  Future<void> _initializeAndStartStream() async {
    try {
      // 프로바이더를 통해 카메라 컨트롤러를 가져옵니다.
      _controller = await ref.read(cameraControllerServiceProvider.future);
      final processor = ref.read(visionProcessorProvider);

      // 위젯이 아직 마운트 상태인지 확인 후 스트림을 시작합니다.
      if (mounted) {
        // VisionProcessor 내부에서 일시정지 상태를 확인하므로, 여기서는 스트림을 시작하기만 하면 됩니다.
        processor.startStreaming(_controller!);
      }
    } catch (e) {
      // 에러는 cameraControllerServiceProvider의 error 상태에서 처리되므로 별도 처리가 불필요합니다.
      debugPrint('카메라 스트림 시작 실패: $e');
    }
  }

  @override
  void dispose() {
    // 컨트롤러가 존재하고 스트리밍 중일 때 스트림을 중지합니다.
    _controller?.stopImageStream().catchError((e) {
      debugPrint('카메라 스트림 중지 실패: $e');
    });
    // 컨트롤러 자체의 dispose는 cameraControllerServiceProvider의 onDispose에서 처리됩니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraControllerAsync = ref.watch(cameraControllerServiceProvider);
    final analysisResult = ref.watch(latestAnalysisResultProvider);
    final generatedPoem = ref.watch(generatedPoemProvider);
    final processor = ref.read(visionProcessorProvider);

    // isVisionPausedProvider의 현재 '상태(state)'를 watch 합니다.
    final isPaused = ref.watch(isVisionPausedProvider);
    final isGeneratingPoem = generatedPoem.contains('Gemini가 시를 생성하는 중');

    final canGeneratePoem = analysisResult.isNotEmpty &&
        !analysisResult.contains('인식된 객체가 없습니다') &&
        !analysisResult.contains('피사체에 비춰주세요') &&
        !isGeneratingPoem;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('AI 시인', style: GoogleFonts.stylish(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(blurRadius: 4.0, color: Colors.black.withAlpha((255 * 0.5).round()))])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu_outlined), // 갤러리 아이콘
            tooltip: '시 갤러리 보기',
            onPressed: () {
              // 갤러리 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PoemGalleryScreen()),
              );
            },
          ),
          const SizedBox(width: 8), // 오른쪽 여백
        ],
      ),
      body: cameraControllerAsync.when(
        loading: () => Container(color: Colors.black, child: const Center(child: CircularProgressIndicator())),
        error: (err, stack) => Container(
          color: Colors.black,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('카메라를 시작할 수 없습니다.\n$err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
            ),
          ),
        ),
        data: (controller) {
          // 🛑 [수정됨] 스트림 시작 로직이 initState로 이동하여 여기서 제거되었습니다.
          
          final size = MediaQuery.of(context).size;
          var scale = size.aspectRatio * controller.value.aspectRatio;
          if (scale < 1) scale = 1 / scale;

          return Stack(
            children: [
              Positioned.fill(
                child: ClipRect(
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.center,
                    child: cam.CameraPreview(controller),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withAlpha((255 * 0.8).round()),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.deepPurple.withAlpha((255 * 0.2).round())
                      ],
                      stops: const [0.0, 0.25, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Location Info Card
                      Consumer(
                        builder: (context, ref, child) {
                          final addressAsync = ref.watch(currentAddressProvider);
                          return addressAsync.when(
                            data: (address) => _InfoCard(
                              icon: Icons.location_on_rounded,
                              title: '현재 위치',
                              content: address,
                            ),
                            loading: () => const _InfoCard(
                              icon: Icons.location_on_rounded,
                              title: '현재 위치',
                              content: '위치 정보를 가져오는 중...',
                            ),
                            error: (err, stack) => _InfoCard(
                              icon: Icons.location_off_rounded,
                              title: '위치 정보',
                              content: '위치 정보를 가져올 수 없습니다: $err',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16), // Separator
                      _InfoCard(
                        icon: Icons.search_rounded,
                        title: '인식된 사물',
                        content: analysisResult,
                      ),
                      const SizedBox(height: 16),
                      _InfoCard(
                        icon: Icons.auto_awesome,
                        title: 'AI의 영감',
                        content: generatedPoem,
                        isHighlighted: true,
                      ),
                      const SizedBox(height: 24),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: 'pause_button',
                            onPressed: () {
                              // ⬇️ [핵심 수정] Notifier의 'toggle' 메서드를 호출합니다.
                              ref.read(isVisionPausedProvider.notifier).toggle();
                            },
                            backgroundColor: Colors.white.withAlpha((255 * 0.8).round()),
                            child: Icon(
                              isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                              color: Colors.black87,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: canGeneratePoem
                                ? () {
                                    // ⬇️ [핵심 수정] Notifier의 'set' 메서드를 호출합니다.
                                    ref.read(isVisionPausedProvider.notifier).set(true);
                                    processor.generatePoemFromLabels(analysisResult);
                                  }
                                : null,
                            icon: isGeneratingPoem
                                ? const SizedBox(
                                    width: 20, height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.edit_note_rounded),
                            label: Text(
                              isGeneratingPoem ? '생성 중...' : '시 만들기',
                              style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canGeneratePoem ? Colors.deepPurple : Colors.grey.shade800,
                              foregroundColor: canGeneratePoem ? Colors.white : Colors.grey.shade500,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 8,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// 정보 카드를 위한 재사용 위젯 (변경 없음)
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final bool isHighlighted;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isHighlighted
            ? Colors.deepPurple.withAlpha((255 * 0.2).round())
            : Colors.black.withAlpha((255 * 0.25).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted
              ? Colors.deepPurple.shade300
              : Colors.white.withAlpha((255 * 0.2).round()),
        ),
        boxShadow: isHighlighted ? [
          BoxShadow(
            color: Colors.deepPurple.withAlpha((255 * 0.5).round()),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  color: isHighlighted ? Colors.deepPurple.shade200 : Colors.white70,
                  size: 18),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.notoSansKr(
                color: isHighlighted ? Colors.deepPurple.shade200 : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content,
              style: GoogleFonts.notoSansKr(
                color: Colors.white.withAlpha((255 * 0.9).round()),
                fontSize: 14,
                height: 1.5,
              )),
        ],
      ),
    );
  }
}