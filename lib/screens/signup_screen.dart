import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme_provider.dart';
import '../widgets/exit_confirmation.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, authProvider, themeProvider, child) {
        return WillPopScope(
          onWillPop: () => ExitConfirmation.showExitDialog(context),
          child: Scaffold(
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
                          
                          // Header with back and theme toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade700,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    (route) => false,
                                  );
                                },
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
                          
                          const SizedBox(height: 20),
                          
                          // Logo
                          Container(
                            height: 80,
                            width: 80,
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
                              Icons.person_add,
                              size: 40,
                              color: themeProvider.isDarkMode ? const Color(0xFF667eea) : Colors.white,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Title
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Text(
                            'Sign up to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: themeProvider.isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Email
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Email',
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Password
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: TextStyle(
                                    color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: themeProvider.isDarkMode
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.grey.shade600,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Confirm Password
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  style: TextStyle(
                                    color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(
                                      color: themeProvider.isDarkMode
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.grey.shade600,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                        color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
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
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Error Message
                                if (authProvider.errorMessage != null)
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
                                
                                const SizedBox(height: 20),
                                
                                // Sign Up Button
                                ElevatedButton(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!.validate()) {
                                            bool success = await authProvider.signUp(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            );
                                            if (success && mounted) {
                                              Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                                                (route) => false,
                                              );
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
                                          'SIGN UP',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey.shade600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Continue as Guest Button
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                                (route) => false,
                              );
                            },
                            icon: Icon(
                              Icons.person_outline,
                              color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                              size: 18,
                            ),
                            label: Text(
                              'Continue as Guest',
                              style: TextStyle(
                                color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: themeProvider.isDarkMode ? Colors.white24 : Colors.grey.shade400,
                              ),
                              minimumSize: const Size(double.infinity, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
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
          ),
        );
      },
    );
  }
}