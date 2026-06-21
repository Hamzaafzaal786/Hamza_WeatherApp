import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme_provider.dart';
import '../widgets/exit_confirmation.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, authProvider, themeProvider, child) {
        if (authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          });
        }
        
        return WillPopScope(
          onWillPop: () => ExitConfirmation.showExitDialog(context),
          child: Scaffold(
            body: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Theme Toggle
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade700,
                              size: 22,
                            ),
                            onPressed: () => themeProvider.toggleTheme(),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Logo
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            gradient: themeProvider.isDarkMode
                                ? const LinearGradient(
                                    colors: [Colors.white, Colors.white70],
                                  )
                                : const LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                  ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.isDarkMode
                                    ? Colors.white.withOpacity(0.2)
                                    : const Color(0xFF4A90E2).withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.cloud_queue,
                            size: 35,
                            color: themeProvider.isDarkMode ? const Color(0xFF667eea) : Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Welcome Text
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 6),
                        
                        Text(
                          'Sign in to continue',
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
                                  fontSize: 14,
                                  color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color: themeProvider.isDarkMode
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.grey.shade600,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    size: 18,
                                    color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  filled: true,
                                  fillColor: themeProvider.isDarkMode
                                      ? Colors.white.withOpacity(0.15)
                                      : Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
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
                                  fontSize: 14,
                                  color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color: themeProvider.isDarkMode
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.grey.shade600,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    size: 18,
                                    color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      size: 18,
                                      color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  filled: true,
                                  fillColor: themeProvider.isDarkMode
                                      ? Colors.white.withOpacity(0.15)
                                      : Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    minimumSize: Size.zero,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Error Message
                              if (authProvider.errorMessage != null)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    authProvider.errorMessage!,
                                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              
                              const SizedBox(height: 16),
                              
                              // Login Button
                              ElevatedButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          bool success = await authProvider.signIn(
                                            _emailController.text.trim(),
                                            _passwordController.text.trim(),
                                          );
                                          if (success && mounted) {
                                            Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                                              (route) => false,
                                            );
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                                  foregroundColor: themeProvider.isDarkMode ? const Color(0xFF667eea) : Colors.white,
                                  minimumSize: const Size(double.infinity, 44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
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
                                        'SIGN IN',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Google Sign In
                              OutlinedButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () async {
                                        bool success = await authProvider.signInWithGoogle();
                                        if (success && mounted) {
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                                            (route) => false,
                                          );
                                        }
                                      },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                                  ),
                                  minimumSize: const Size(double.infinity, 44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.g_mobiledata,
                                      size: 18,
                                      color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 12,
                                color: themeProvider.isDarkMode
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.grey.shade600,
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                minimumSize: Size.zero,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                                  (route) => false,
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
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
                            size: 16,
                            color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                          ),
                          label: Text(
                            'Continue as Guest',
                            style: TextStyle(
                              fontSize: 13,
                              color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: themeProvider.isDarkMode ? Colors.white24 : Colors.grey.shade400,
                            ),
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
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