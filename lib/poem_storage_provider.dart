import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON 인코딩/디코딩

part 'poem_storage_provider.g.dart';

// PoemData 클래스 정의 (시 내용과 생성 시간 저장)
class PoemData {
  final String content;
  final DateTime createdAt;

  PoemData({required this.content, required this.createdAt});

  // JSON 직렬화/역직렬화 메서드
  Map<String, dynamic> toJson() => {
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PoemData.fromJson(Map<String, dynamic> json) => PoemData(
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

// SharedPreferences 인스턴스를 제공하는 Provider (비동기)
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

// 시 기록을 관리하는 Notifier Provider
@riverpod
class PoemHistory extends _$PoemHistory {
  // SharedPreferences 키
  static const _storageKey = 'poem_history';

  // Provider 빌드 시 SharedPreferences에서 데이터 로드
  @override
  Future<List<PoemData>> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final jsonStringList = prefs.getStringList(_storageKey) ?? [];
    // JSON 문자열 리스트를 List<PoemData>로 변환
    return jsonStringList
        .map((jsonString) => PoemData.fromJson(jsonDecode(jsonString) as Map<String, dynamic>))
        .toList()
        .reversed // 최신 시가 위로 오도록 순서 뒤집기
        .toList();
  }

  // 내부 상태를 업데이트하고 SharedPreferences에 저장하는 비동기 메서드
  Future<void> _updateAndSave(List<PoemData> newState) async {
    // 상태 업데이트 (AsyncValue 사용)
    state = AsyncData(newState);
    // SharedPreferences에 저장
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final jsonStringList = newState
        .reversed // 저장할 때는 다시 원래 순서(오래된 순)로
        .map((poemData) => jsonEncode(poemData.toJson()))
        .toList();
    await prefs.setStringList(_storageKey, jsonStringList);
  }

  // 새로운 시 추가
  Future<void> addPoem(String content) async {
    final newPoem = PoemData(content: content, createdAt: DateTime.now());
    // 현재 상태(List<PoemData>)를 가져와서 맨 앞에 새 시를 추가
    final currentState = state.value ?? [];
    await _updateAndSave([newPoem, ...currentState]);
  }

  // 특정 인덱스의 시 삭제
  Future<void> deletePoem(int index) async {
    final currentState = state.value ?? [];
    // 인덱스가 유효한 경우에만 삭제 진행
    if (index >= 0 && index < currentState.length) {
      final newState = List<PoemData>.from(currentState)..removeAt(index);
      await _updateAndSave(newState);
    }
  }

  // 모든 기록 삭제
  Future<void> clearHistory() async {
    await _updateAndSave([]);
  }
}