// lib/presentation/screens/auth/view/profile_review_screen.dart
import 'package:flutter/material.dart';

class ProfileReviewScreen extends StatelessWidget {
  const ProfileReviewScreen({Key? key}) : super(key: key);

  // Define the static route name
  static String route = '/profileReview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile Status'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.grey[800],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Main content area
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top card with status
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Clock emoji and title
                          const Text('🕓', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          const Text(
                            'Your profile is under review',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Status lines
                          _buildStatusLine(
                            '📄',
                            'Documents submitted successfully',
                          ),
                          const SizedBox(height: 16),
                          _buildStatusLine('👀', 'Waiting for admin approval'),
                          const SizedBox(height: 32),

                          // Note
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('✅', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                'You\'ll be notified once approved',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons
              Column(
                children: [
                  // Check Status button (Outlined)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Handle check status action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Checking status...')),
                        );
                      },
                      icon: const Text('🔄', style: TextStyle(fontSize: 16)),
                      label: const Text(
                        'Check Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        side: BorderSide(color: Colors.blue[700]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Contact Support button (Elevated)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle contact support action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening support chat...'),
                          ),
                        );
                      },
                      icon: const Text('📞', style: TextStyle(fontSize: 16)),
                      label: const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusLine(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
