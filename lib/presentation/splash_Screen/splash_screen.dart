// lib/presentation/screens/splash_screen.dart
import 'package:demo/presentation/screens/auth/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:demo/presentation/screens/auth/provider/login_reg_provider.dart'; // Assuming AuthController is here
// import 'package:demo/presentation/screens/home/home.dart'; // No longer navigate directly to HomeScreen
import 'package:demo/presentation/screens/main_screen.dart'; // Import MainScreen
import 'package:demo/presentation/screens/auth/view/login.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/'; // Make this the initial route

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authController = context.read<AuthController>();

    // A small delay to ensure the widget tree is fully built
    // and the provider has had a chance to initialize and load data.
    // While Future.delayed(Duration.zero) is minimal, it defers
    // the check until the next microtask queue, which is often enough.
    await Future.delayed(Duration.zero);

    if (authController.token != null) {
      // Token exists, navigate to MainScreen (which will then show HomeScreen by default)
      if (context.mounted) {
        context.goNamed(MainScreen.route); // Navigate to MainScreen
      }
    } else {
      // No token, navigate to login
      if (context.mounted) {
        context.goNamed(LoginScreen.route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      ),
    );
  }
}
