import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get user => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Email/Password Sign Up
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // Email/Password Sign In
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      return userCredential.user;
    } catch (e) {
      print('Google sign in error: $e');
      rethrow;
    }
  }

  // Sign Out
  // Sign Out
// Sign Out
Future<void> signOut() async {
  print('AuthService.signOut() started');
  try {
    // Sign out from Google
    await _googleSignIn.signOut();
    print('Google sign out successful');
    
    // Sign out from Firebase
    await _auth.signOut();
    print('Firebase sign out successful');
    
    print('AuthService.signOut() completed');
  } catch (e) {
    print('AuthService.signOut() error: $e');
    rethrow;
  }
}

  // Password Reset
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}