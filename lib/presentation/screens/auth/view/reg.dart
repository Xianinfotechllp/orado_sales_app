import 'dart:io';
import 'package:demo/constants/colors.dart';
import 'package:demo/presentation/screens/auth/provider/login_reg_provider.dart';
import 'package:demo/presentation/screens/auth/provider/user_provider.dart';
import 'package:demo/presentation/screens/auth/view/login.dart';
import 'package:demo/widgets/custom_button.dart';
import 'package:demo/widgets/custom_container.dart';
import 'package:demo/widgets/text_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static String route = 'register';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // Changed from username to email for agent registration
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  File? _license;
  File? _rcBook;
  File? _pollutionCertificate;
  File? _profilePicture;
  File? _insurance;

  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile({
    required Function(File?) onFileSelected,
    ImageSource source = ImageSource.gallery,
  }) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      onFileSelected(File(pickedFile.path));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 1.7,
              width: MediaQuery.sizeOf(context).width,
              child: Image.asset('asstes/coverPic.png', fit: BoxFit.cover),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: CustomContainer(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  height: MediaQuery.sizeOf(context).height / 1.9,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        BuildTextFormField(
                          inputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          validator:
                              (text) =>
                                  text!.isEmpty ? 'Enter your name' : null,
                          controller: nameController,
                          fillColor: AppColors.greycolor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hint: 'Full Name',
                        ),
                        SizedBox(height: 15),
                        BuildTextFormField(
                          inputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.emailAddress, // Changed to email
                          validator:
                              (text) =>
                                  text!.isEmpty ? 'Enter your email' : null,
                          controller: emailController, // Using emailController
                          fillColor: AppColors.greycolor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hint: 'Email',
                        ),
                        SizedBox(height: 15),
                        BuildTextFormField(
                          inputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          validator:
                              (text) =>
                                  text!.isEmpty ? 'Enter mobile number' : null,
                          controller: mobileController,
                          fillColor: AppColors.greycolor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hint: 'Mobile Number',
                        ),
                        SizedBox(height: 15),
                        BuildTextFormField(
                          inputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator:
                              (text) => text!.isEmpty ? 'Enter password' : null,
                          controller: passwordController,
                          fillColor: AppColors.greycolor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hint: 'Password',
                        ),
                        SizedBox(height: 15),
                        BuildTextFormField(
                          inputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (text) {
                            if (text!.isEmpty) return 'Confirm your password';
                            if (text != passwordController.text)
                              return 'Passwords do not match';
                            return null;
                          },
                          controller: confirmPasswordController,
                          fillColor: AppColors.greycolor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hint: 'Confirm Password',
                        ),
                        SizedBox(height: 20),

                        // --- File Upload Sections ---
                        // License
                        _buildFilePickerButton(
                          label: 'Upload Driving License',
                          file: _license,
                          onPressed:
                              () => _pickFile(
                                onFileSelected: (file) {
                                  setState(() => _license = file);
                                },
                              ),
                        ),
                        SizedBox(height: 15),
                        // RC Book
                        _buildFilePickerButton(
                          label: 'Upload RC Book',
                          file: _rcBook,
                          onPressed:
                              () => _pickFile(
                                onFileSelected: (file) {
                                  setState(() => _rcBook = file);
                                },
                              ),
                        ),
                        SizedBox(height: 15),
                        // Pollution Certificate
                        _buildFilePickerButton(
                          label: 'Upload Pollution Certificate',
                          file: _pollutionCertificate,
                          onPressed:
                              () => _pickFile(
                                onFileSelected: (file) {
                                  setState(() => _pollutionCertificate = file);
                                },
                              ),
                        ),
                        SizedBox(height: 15),
                        // Profile Picture
                        _buildFilePickerButton(
                          label: 'Upload Profile Picture',
                          file: _profilePicture,
                          onPressed:
                              () => _pickFile(
                                onFileSelected: (file) {
                                  setState(() => _profilePicture = file);
                                },
                              ),
                        ),
                        SizedBox(height: 15),
                        _buildFilePickerButton(
                          label: 'Upload insurance',
                          file: _insurance,
                          onPressed:
                              () => _pickFile(
                                onFileSelected: (file) {
                                  setState(() => _insurance = file);
                                },
                              ),
                        ),
                        SizedBox(height: 20),

                        // --- End File Upload Sections ---
                        CustomButton().showColouredButton(
                          label:
                              context.watch<AgentProvider>().isLoading
                                  ? 'Registering...'
                                  : 'Register Agent', // Change button text
                          backGroundColor: AppColors.baseColor,
                          onPressed:
                              context.watch<AgentProvider>().isLoading
                                  ? null // Disable button when loading
                                  : () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    // Validate if all files are selected
                                    if (_license == null ||
                                        _rcBook == null ||
                                        _pollutionCertificate == null ||
                                        _profilePicture == null ||
                                        _insurance == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Please upload all required documents.",
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    await context
                                        .read<AgentProvider>()
                                        .registerAgent(
                                          context: context,
                                          name: nameController.text,
                                          email:
                                              emailController
                                                  .text, // Use emailController
                                          phone: mobileController.text,
                                          password: passwordController.text,
                                          license: _license!,
                                          rcBook: _rcBook!,
                                          pollutionCertificate:
                                              _pollutionCertificate!,
                                          profilePicture: _profilePicture!,
                                          insurance: _insurance!,
                                        );

                                    // Optional: After successful registration, navigate to login or show success message.
                                    // The AgentProvider already shows a SnackBar for success/error.
                                    if (!context
                                            .read<AgentProvider>()
                                            .isLoading &&
                                        context.read<AgentProvider>().error ==
                                            null) {
                                      Navigator.pushReplacement(
                                        // Use pushReplacement to prevent going back to registration
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                    }
                                  },
                        ),
                        const SizedBox(height: 16),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => const LoginScreen(),
                        //       ),
                        //     );
                        //   },
                        //   child: const Text(
                        //     "Do you have an account? Login",
                        //     style: TextStyle(
                        //       color: Colors.blue,
                        //       decoration: TextDecoration.underline,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePickerButton({
    required String label,
    required File? file,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.greycolor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            file != null ? 'Selected: ${file.path.split('/').last}' : label,
            style: TextStyle(
              color: file != null ? Colors.black : Colors.grey[700],
            ),
          ),
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: onPressed,
            color: AppColors.baseColor,
          ),
        ],
      ),
    );
  }
}
