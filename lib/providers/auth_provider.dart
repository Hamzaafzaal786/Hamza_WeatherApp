import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Listen to auth state changes
    _authService.user.listen((User? user) {
      _user = user;
      print('Auth state changed: ${user?.email ?? "null"}'); // Debug print
      notifyListeners();
    });
  }

  // Sign Up with Email
  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      User? user = await _authService.signUpWithEmail(email, password);
      _user = user;
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign In with Email
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      User? user = await _authService.signInWithEmail(email, password);
      _user = user;
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign In with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      User? user = await _authService.signInWithGoogle();
      _user = user;
      return user != null;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign Out
  // Sign Out
// Sign Out
Future<void> signOut() async {
  print('AuthProvider.signOut() called');
  try {
    await _authService.signOut();
    _user = null;
    notifyListeners();
    print('Sign out successful');
  } catch (e) {
    print('Sign out error in provider: $e');
    rethrow;
  }
}

  String _getErrorMessage(dynamic error) {
    String errorMessage = error.toString();
    
    if (errorMessage.contains('email-already-in-use')) {
      return 'This email is already registered. Please login.';
    } else if (errorMessage.contains('weak-password')) {
      return 'Password should be at least 6 characters.';
    } else if (errorMessage.contains('user-not-found')) {
      return 'No account found with this email.';
    } else if (errorMessage.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (errorMessage.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}