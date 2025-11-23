import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poet/camera_screen.dart';
import 'package:poet/repositories/auth_repository.dart';
import 'package:poet/screens/login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authStateChangesProvider를 사용하여 인증 상태의 변화를 감지합니다.
    final authState = ref.watch(authStateChangesProvider);

    // AsyncValue의 when 메소드를 사용하여 로딩, 에러, 데이터 상태를 처리합니다.
    return authState.when(
      data: (user) {
        // 데이터가 성공적으로 로드되었을 때
        if (user == null) {
          // 사용자가 로그인하지 않은 경우 LoginScreen을 보여줍니다.
          return const LoginScreen();
        } else {
          // 사용자가 로그인한 경우 CameraScreen을 보여줍니다.
          return const CameraScreen();
        }
      },
      loading: () {
        // 데이터가 로딩 중일 때
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) {
        // 에러가 발생했을 때
        return Scaffold(
          body: Center(
            child: Text('Something went wrong!\n$error'),
          ),
        );
      },
    );
  }
}