import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, authProvider, themeProvider, child) {
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: themeProvider.isDarkMode
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A1A2E),
                        Color(0xFF16213E),
                        Color(0xFF0F3460),
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE8F0FE),
                        Color(0xFFD4E4FC),
                        Color(0xFFB8D0F5),
                      ],
                    ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade700,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            IconButton(
                              icon: Icon(
                                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade700,
                              ),
                              onPressed: () => themeProvider.toggleTheme(),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Icon
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: themeProvider.isDarkMode
                                ? const LinearGradient(
                                    colors: [Colors.white, Colors.white70],
                                  )
                                : const LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                  ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_reset,
                            size: 50,
                            color: themeProvider.isDarkMode ? const Color(0xFF667eea) : Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Title
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Text(
                          'Enter your email address and we\'ll send you a link to reset your password.',
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.isDarkMode
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.grey.shade600,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                            ),
                            filled: true,
                            fillColor: themeProvider.isDarkMode
                                ? Colors.white.withOpacity(0.15)
                                : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Success Message
                        if (_emailSent)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Password reset email sent! Check your inbox.',
                              style: TextStyle(color: Colors.greenAccent),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        
                        // Error Message
                        if (authProvider.errorMessage != null && !_emailSent)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              authProvider.errorMessage!,
                              style: const TextStyle(color: Colors.redAccent),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        
                        const SizedBox(height: 24),
                        
                        // Send Button
                        ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  if (_emailController.text.isNotEmpty) {
                                    FocusScope.of(context).unfocus();
                                    bool success = await authProvider.resetPassword(
                                      _emailController.text.trim(),
                                    );
                                    if (success && mounted) {
                                      setState(() {
                                        _emailSent = true;
                                      });
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                            foregroundColor: themeProvider.isDarkMode ? const Color(0xFF667eea) : Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'SEND RESET EMAIL',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Back to Login
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Back to Login',
                            style: TextStyle(
                              color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}