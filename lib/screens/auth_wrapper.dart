
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/providers/auth_provider.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const HomeScreen(); // User is signed in
        } else {
          return LoginScreen(); // User is not signed in
        }
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}