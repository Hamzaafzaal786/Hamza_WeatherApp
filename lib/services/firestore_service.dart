import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // ============ FAVORITES METHODS ============
  
  // Add a city to favorites
  Future<void> addFavoriteCity(String cityName) async {
    if (currentUserId == null) {
      throw Exception('User not logged in');
    }
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('favorites')
          .doc(cityName.toLowerCase())
          .set({
        'cityName': cityName,
        'addedAt': FieldValue.serverTimestamp(),
      });
      print('Added $cityName to favorites');
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  // Remove a city from favorites
  Future<void> removeFavoriteCity(String cityName) async {
    if (currentUserId == null) {
      throw Exception('User not logged in');
    }
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('favorites')
          .doc(cityName.toLowerCase())
          .delete();
      print('Removed $cityName from favorites');
    } catch (e) {
      print('Error removing favorite: $e');
      rethrow;
    }
  }

  // Get all favorite cities (returns Stream for real-time updates)
  Stream<List<String>> getFavoriteCitiesStream() {
    if (currentUserId == null) {
      return Stream.value([]);
    }
    
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('favorites')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc['cityName'] as String).toList();
        });
  }

  // Check if a city is favorite
  Future<bool> isFavorite(String cityName) async {
    if (currentUserId == null) return false;
    
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('favorites')
          .doc(cityName.toLowerCase())
          .get();
      
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // ============ USER SETTINGS METHODS ============
  
  // Save user preferences
  Future<void> saveUserSettings({
    required bool isCelsius,
    String? lastCity,
  }) async {
    if (currentUserId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .set({
        'isCelsius': isCelsius,
        'lastCity': lastCity ?? '',
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving settings: $e');
      rethrow;
    }
  }

  // Get user preferences
  Future<Map<String, dynamic>> getUserSettings() async {
    if (currentUserId == null) return {'isCelsius': true, 'lastCity': ''};
    
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();
      
      if (doc.exists) {
        return {
          'isCelsius': doc['isCelsius'] ?? true,
          'lastCity': doc['lastCity'] ?? '',
        };
      }
      return {'isCelsius': true, 'lastCity': ''};
    } catch (e) {
      print('Error getting settings: $e');
      return {'isCelsius': true, 'lastCity': ''};
    }
  }
}