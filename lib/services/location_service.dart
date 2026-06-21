import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  
  // Check and request permissions
  Future<bool> checkPermissions() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
      return false;
    }
    
    // Check permission status
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      print('Permission requested, status: $permission');
      
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return false;
    }
    
    print('Location permission granted');
    return true;
  }

  // Get current city name from location with better error handling
  // Update getCurrentCity method to be more robust
Future<String> getCurrentCity() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
    
    print('Got position: ${position.latitude}, ${position.longitude}');
    
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    ).timeout(const Duration(seconds: 10));
    
    if (placemarks.isNotEmpty) {
      // Try multiple fields to get city name
      String city = placemarks.first.locality ?? 
                   placemarks.first.administrativeArea ?? 
                   placemarks.first.subAdministrativeArea ?? 
                   placemarks.first.subLocality ??
                   '';
      
      // If city is empty, try using postal code area
      if (city.isEmpty) {
        city = placemarks.first.postalCode ?? '';
      }
      
      // If still empty, return coordinates as string
      if (city.isEmpty) {
        city = '${position.latitude.toStringAsFixed(2)},${position.longitude.toStringAsFixed(2)}';
      }
      
      print('Got city from geocoding: $city');
      return city;
    }
    
    return 'Unknown';
  } catch (e) {
    print('Error getting city: $e');
    return 'Unknown';
  }
}
  
  // Get current position (for debugging)
  Future<Position?> getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      return position;
    } catch (e) {
      print('Error getting position: $e');
      return null;
    }
  }
  
  // Direct weather fetch by coordinates (bypass city name)
  // Get current position coordinates only (no geocoding)
Future<Map<String, double>> getCoordinates() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  } catch (e) {
    print('Error getting coordinates: $e');
    return {'latitude': 0, 'longitude': 0};
  }
}
}