// lib/presentation/screens/splash_screen.dart
import 'package:demo/presentation/screens/auth/provider/user_provider.dart';
import 'package:demo/presentation/screens/auth/service/selfi_status_service.dart';
import 'package:demo/presentation/screens/auth/view/selfi_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo/presentation/screens/main_screen.dart';
import 'package:demo/presentation/screens/auth/view/login.dart';

class SplashScreen extends StatefulWidget {
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
    await Future.delayed(Duration.zero);

    if (authController.token != null) {
      final selfieStatus = await SelfieStatusService().fetchSelfieStatus();

      if (mounted) {
        if (selfieStatus?.selfieRequired == true) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const UploadSelfieScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'asstes/oradoLogo.png',
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
