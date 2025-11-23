import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poet/repositories/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100), // Placeholder for App Logo
            const SizedBox(height: 40),
            const Text(
              'Welcome to AI Poet',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.login), // Replace with Google icon if you have font_awesome_flutter or similar
              label: const Text('Sign in with Google'),
              onPressed: () {
                ref.read(authRepositoryProvider).signInWithGoogle();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              child: const Text('Continue as Anonymous'),
              onPressed: () {
                ref.read(authRepositoryProvider).signInAnonymously();
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(250, 50),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
