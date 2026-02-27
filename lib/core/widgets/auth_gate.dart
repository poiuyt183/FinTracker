import 'package:flutter/material.dart';
import 'package:frontend/features/auth/viewmodel/auth_provider.dart';
import 'package:frontend/features/get_started/views/pages/get_started_page.dart';
import 'package:frontend/features/home/view/pages/home_page.dart';
import 'package:provider/provider.dart';

/// A widget that listens to authentication state and redirects accordingly
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading indicator while checking auth state
        if (authProvider.user == null && authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Redirect based on authentication state
        return authProvider.isAuthenticated
            ? const HomePage()
            : const GetStartedPage();
      },
    );
  }
}
