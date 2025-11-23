import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // flutterfire configure로 생성된 파일

import 'package:poet/screens/auth_gate.dart';
import 'camera_screen.dart';

void main() async {
  // Flutter 엔진과 위젯 바인딩 보장
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ML Kit을 위해 Firebase 초기화 (시동 걸기)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase 초기화 실패 시 에러를 출력합니다.
    // 실제 프로덕션 앱에서는 에러 리포팅 서비스를 사용하거나
    // 사용자에게 친화적인 에러 화면을 보여주는 것이 좋습니다.
    debugPrint('Firebase 초기화 실패: $e');
  }

  // 앱 전체를 ProviderScope로 감싸 Riverpod 활성화
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 시인',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const AuthGate(),
    );
  }
}