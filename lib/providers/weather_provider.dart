import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/weather_api_service.dart';
import '../services/preferences_service.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeatherProvider extends ChangeNotifier {
  final ApiService _openWeatherService = ApiService();
  final WeatherApiService _weatherApiService = WeatherApiService();
  final PreferencesService _prefsService = PreferencesService();
  final FirestoreService _firestoreService = FirestoreService();
  final LocationService _locationService = LocationService();
  
  WeatherModel? _weather;
  List<ForecastDay>? _forecast;
  List<HourlyWeather>? _hourlyForecast;
  bool _isLoading = false;
  String? _error;
  bool _isCelsius = true;

  WeatherModel? get weather => _weather;
  List<ForecastDay>? get forecast => _forecast;
  List<HourlyWeather>? get hourlyForecast => _hourlyForecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCelsius => _isCelsius;

  WeatherProvider() {
    _loadUnitPreference();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadPreferencesFromFirestore();
      } else {
        await _loadUnitPreference();
      }
    });
  }

  Future<void> _loadPreferencesFromFirestore() async {
    try {
      final settings = await _firestoreService.getUserSettings();
      _isCelsius = settings['isCelsius'] ?? true;
      notifyListeners();
    } catch (e) {
      print('Error loading preferences from Firestore: $e');
      await _loadUnitPreference();
    }
  }

  Future<void> _loadUnitPreference() async {
    _isCelsius = await _prefsService.getUnit();
    notifyListeners();
  }

  Future<void> toggleUnit() async {
    _isCelsius = !_isCelsius;
    await _prefsService.saveUnit(_isCelsius);
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestoreService.saveUserSettings(isCelsius: _isCelsius);
    }
    
    notifyListeners();
  }

  double getTemperatureInCurrentUnit(double celsius) {
    if (_isCelsius) {
      return celsius;
    } else {
      return (celsius * 9 / 5) + 32;
    }
  }

  String getTemperatureUnit() {
    return _isCelsius ? '°C' : '°F';
  }

  // Helper method to get correct city name from coordinates
  String _getCityNameFromCoordinates(double latitude, double longitude) {
    // Karachi coordinates range
    if (latitude >= 24.80 && latitude <= 24.95 && 
        longitude >= 66.90 && longitude <= 67.20) {
      return 'Karachi';
    }
    
    // You can add more cities here
    // Islamabad
    if (latitude >= 33.50 && latitude <= 33.80 && longitude >= 73.00 && longitude <= 73.20) {
      return 'Islamabad';
    }
    
    // Lahore
    if (latitude >= 31.40 && latitude <= 31.60 && longitude >= 74.20 && longitude <= 74.40) {
      return 'Lahore';
    }
    
    // If not in our override list, return null to use API name
    return '';
  }

  // Fetch weather by city name (for search)
  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('Fetching weather for: $city');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      print('📡 Fetching from WeatherAPI.com...');
      final weatherApiData = await _weatherApiService.fetchHourlyForecast(city);
      
      final current = _weatherApiService.parseCurrentWeather(weatherApiData);
      _weather = WeatherModel(
        cityName: current['cityName'],
        temperature: current['temperature'],
        feelsLike: current['feelsLike'],
        humidity: current['humidity'],
        windSpeed: current['windSpeed'],
        condition: current['condition'],
        iconCode: current['iconCode'],
      );
      print('✅ Current weather: ${_weather?.condition}, ${_weather?.temperature}°C');
      
      final hourlyList = _weatherApiService.parseHourlyForecast(weatherApiData);
      _hourlyForecast = hourlyList.map((hour) => HourlyWeather(
        time: hour['time'],
        temperature: hour['temperature'],
        humidity: hour['humidity'],
        condition: hour['condition'],
        iconCode: hour['iconCode'],
        windSpeed: hour['windSpeed'],
        chanceOfRain: hour['chanceOfRain'],
      )).toList();
      print('✅ Hourly forecast: ${_hourlyForecast?.length} entries');
      
      print('📡 Fetching from OpenWeatherMap...');
      _forecast = await _openWeatherService.fetchForecast(city);
      print('✅ 5-day forecast: ${_forecast?.length} days');
      
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('✅ All data fetched successfully!');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && _weather != null) {
        await _firestoreService.saveUserSettings(
          isCelsius: _isCelsius,
          lastCity: city,
        );
      }
    } catch (e) {
      print('❌ Error in fetchWeather: $e');
      _error = 'City "$city" not found. Please check the name.';
      _weather = null;
      _hourlyForecast = null;
      _forecast = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearWeather() {
    _weather = null;
    _forecast = null;
    _hourlyForecast = null;
    _error = null;
    notifyListeners();
  }
  
  // Fetch weather by current location - ALWAYS uses coordinates, never geocoding
  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('Fetching weather by current location...');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      // Get coordinates directly from GPS
      final coords = await _locationService.getCoordinates();
      final latitude = coords['latitude']!;
      final longitude = coords['longitude']!;
      
      if (latitude == 0 || longitude == 0) {
        throw Exception('Could not get location coordinates');
      }
      
      print('📍 Coordinates: $latitude, $longitude');
      
      // Determine the correct city name based on coordinates
      String cityName = _getCityNameFromCoordinates(latitude, longitude);
      
      if (cityName.isEmpty) {
        // If not in our override list, fetch from WeatherAPI using coordinates
        print('📍 Fetching city name from WeatherAPI...');
        final weatherData = await _weatherApiService.fetchWeatherByCoordinates(
          latitude, 
          longitude
        );
        final current = _weatherApiService.parseCurrentWeather(weatherData);
        cityName = current['cityName'];
        print('📍 API returned city: $cityName');
      } else {
        print('📍 Using overridden city name: $cityName');
      }
      
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📍 Final city name: $cityName');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      // Now fetch weather using the city name
      await fetchWeather(cityName);
      
    } catch (e) {
      print('❌ Error fetching weather by location: $e');
      _error = 'Could not get weather for your location. Please search for a city.';
      _weather = null;
      _hourlyForecast = null;
      _forecast = null;
      _isLoading = false;
      notifyListeners();
    }
  }
}

// HourlyWeather class
class HourlyWeather {
  final DateTime time;
  final double temperature;
  final int humidity;
  final String condition;
  final String iconCode;
  final double windSpeed;
  final int chanceOfRain;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.iconCode,
    required this.windSpeed,
    required this.chanceOfRain,
  });

  String get formattedTime {
    final hour = time.hour.toString().padLeft(2, '0');
    return '$hour:00';
  }

  String get iconUrl {
    return 'https://openweathermap.org/img/w/${_getOpenWeatherIcon()}.png';
  }

  String _getOpenWeatherIcon() {
    final cond = condition.toLowerCase();
    if (cond.contains('sun') || cond.contains('clear')) return '01d';
    if (cond.contains('partly cloudy')) return '02d';
    if (cond.contains('cloud')) return '03d';
    if (cond.contains('rain')) return '10d';
    if (cond.contains('thunder')) return '11d';
    if (cond.contains('snow')) return '13d';
    if (cond.contains('fog') || cond.contains('mist')) return '50d';
    return '01d';
  }
}