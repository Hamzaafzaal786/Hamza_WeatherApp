// File: lib/firebase_options.dart
// IMPORTANT: Replace the values below with your actual Firebase project values

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbHk2tBqTa3sCsZq_fLBDHa8ru7r0E86w',           // Replace this
    appId: '1:1065123572322:android:d8fdd0c756be8fe82eff3b',             // Replace this
    messagingSenderId: '1065123572322',      // Replace this
    projectId: 'hamza-weatherapp',             // Replace this
    storageBucket: 'hamza-weatherapp.firebasestorage.app',
  );
}