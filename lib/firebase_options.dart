// File: lib/firebase_options.dart
// IMPORTANT: Replace the values below with your actual Firebase project values

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'APIkey*****************',           // Replace this
    appId: 'AppID************************',             // Replace this
    messagingSenderId: 'MessagingsenderID*******************',      // Replace this
    projectId: 'hamza-weatherapp',             // Replace this
    storageBucket: 'hamza-weatherapp.firebasestorage.app',
  );
}
