import 'dart:io';
import 'package:demo/presentation/screens/auth/provider/upload_selfi_controller.dart';
import 'package:demo/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadSelfieScreen extends StatefulWidget {
  const UploadSelfieScreen({super.key});

  @override
  State<UploadSelfieScreen> createState() => _UploadSelfieScreenState();
}

class _UploadSelfieScreenState extends State<UploadSelfieScreen> {
  File? _imageFile;
  bool _isTakingPhoto = false;

  Future<void> _pickImage() async {
    setState(() => _isTakingPhoto = true);

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.front,
      );

      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
          _isTakingPhoto = false;
        });
      } else {
        setState(() => _isTakingPhoto = false);
      }
    } catch (e) {
      setState(() => _isTakingPhoto = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please take a selfie first."),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final controller = Provider.of<SelfieUploadController>(
      context,
      listen: false,
    );
    await controller.uploadSelfie(_imageFile!);

    if (controller.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${controller.error}"),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.uploadResponse?.message ?? "Upload successful!",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Navigate to main screen with a smooth transition
      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScreen(),
          transitionsBuilder:
              (_, a, __, c) => FadeTransition(opacity: a, child: c),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SelfieUploadController>(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("Verify Your Identity"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Take a selfie for verification",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "This helps us confirm your identity and keep your account secure",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Animated selfie container
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: size.width * 0.6,
                height: size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_imageFile != null)
                      ClipOval(
                        child: Image.file(
                          _imageFile!,
                          width: size.width * 0.58,
                          height: size.width * 0.58,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Icon(
                        Icons.face_retouching_natural,
                        size: 60,
                        color: theme.colorScheme.onBackground.withOpacity(0.3),
                      ),

                    if (_isTakingPhoto)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Camera button with animation
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: _isTakingPhoto ? 0.95 : 1.0,
                child: ElevatedButton(
                  onPressed: _isTakingPhoto ? null : _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    minimumSize: Size(size.width * 0.8, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt),
                      const SizedBox(width: 8),
                      Text(
                        _imageFile == null ? "Take Selfie" : "Retake Selfie",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Upload button
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    _imageFile == null
                        ? const SizedBox()
                        : ElevatedButton(
                          onPressed:
                              controller.isLoading
                                  ? null
                                  : () => _uploadImage(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onSecondary,
                            minimumSize: Size(size.width * 0.8, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                          child:
                              controller.isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.cloud_upload),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Upload & Continue",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                        ),
              ),
              const SizedBox(height: 20),

              // Help text
              if (_imageFile == null)
                Text(
                  "Make sure your face is clearly visible",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
