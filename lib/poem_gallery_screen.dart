import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart'; // ✅ SharePlus import 확인

import 'poem_storage_provider.dart';

class PoemGalleryScreen extends ConsumerWidget {
  const PoemGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poemHistoryAsync = ref.watch(poemHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('나의 시 갤러리', style: GoogleFonts.stylish(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        actions: [
          // ✅ valueOrNull 대신 value 사용 및 null 체크 추가
          if (poemHistoryAsync.value?.isNotEmpty ?? false)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: '모든 기록 삭제',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('기록 전체 삭제'),
                    content: const Text('정말로 모든 시 기록을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('삭제', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
                if (confirm ?? false) {
                  ref.read(poemHistoryProvider.notifier).clearHistory();
                }
              },
            ),
        ],
      ),
      backgroundColor: Colors.black,
      body: poemHistoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('시를 불러오는 중 오류 발생: $err')),
        data: (poems) {
          if (poems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 80, color: Colors.grey.shade700),
                  const SizedBox(height: 16),
                  Text(
                    '아직 저장된 시가 없습니다.\n카메라 화면에서 멋진 순간을 포착해보세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: poems.length,
            itemBuilder: (context, index) {
              final poemData = poems[index];
              final formattedDate = DateFormat('yyyy년 M월 d일 a h:mm', 'ko_KR').format(poemData.createdAt);

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                // ✅ withOpacity -> withAlpha 로 수정
                color: Colors.grey.shade800.withAlpha((255 * 0.5).round()),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poemData.content,
                        style: GoogleFonts.notoSansKr(fontSize: 15, height: 1.6, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.share_outlined, size: 20),
                                color: Colors.grey.shade400,
                                tooltip: '시 공유하기',
                                onPressed: () {
                                  // ✅ Share.share -> SharePlus.share 로 수정
                                  Share.share(poemData.content);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                // ✅ withOpacity -> withAlpha 로 수정
                                color: Colors.redAccent.withAlpha((255 * 0.7).round()),
                                tooltip: '이 시 삭제하기',
                                onPressed: () {
                                  ref.read(poemHistoryProvider.notifier).deletePoem(index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}