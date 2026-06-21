import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  // Replace with your WeatherAPI.com key
  static const String apiKey = '2fca8792f41746c895262408261705';
  static const String baseUrl = 'https://api.weatherapi.com/v1';

  // Fetch current weather + hourly forecast ONLY
  Future<Map<String, dynamic>> fetchHourlyForecast(String cityName) async {
    final url = Uri.parse(
      '$baseUrl/forecast.json?key=$apiKey&q=$cityName&days=3&aqi=no&alerts=no'
    );
    
    print('WeatherAPI URL: $url');
    final response = await http.get(url);
    print('Response status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('City not found');
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Parse ONLY current weather
  Map<String, dynamic> parseCurrentWeather(Map<String, dynamic> data) {
    final current = data['current'];
    final location = data['location'];
    
    return {
      'cityName': location['name'],
      'temperature': current['temp_c'].toDouble(),
      'feelsLike': current['feelslike_c'].toDouble(),
      'humidity': current['humidity'],
      'windSpeed': current['wind_kph'].toDouble() / 3.6,
      'condition': current['condition']['text'],
      'iconCode': current['condition']['code'].toString(),
    };
  }

  // Parse ONLY hourly forecast
  List<Map<String, dynamic>> parseHourlyForecast(Map<String, dynamic> data) {
    final forecast = data['forecast']['forecastday'];
    List<Map<String, dynamic>> hourlyData = [];
    
    for (var day in forecast) {
      final hours = day['hour'] as List;
      for (var hour in hours) {
        final time = DateTime.parse(hour['time']);
        hourlyData.add({
          'time': time,
          'temperature': hour['temp_c'].toDouble(),
          'humidity': hour['humidity'],
          'condition': hour['condition']['text'],
          'iconCode': hour['condition']['code'].toString(),
          'windSpeed': (hour['wind_kph'].toDouble() / 3.6),
          'chanceOfRain': hour['chance_of_rain'],
        });
      }
    }
    
    // Return only next 24-48 hours
    final now = DateTime.now();
    return hourlyData.where((hour) => hour['time'].isAfter(now)).take(48).toList();
  }

  // Add this method to WeatherApiService class
Future<Map<String, dynamic>> fetchWeatherByCoordinates(
  double latitude, 
  double longitude
) async {
  final url = Uri.parse(
    '$baseUrl/forecast.json?key=$apiKey&q=$latitude,$longitude&days=3&aqi=no&alerts=no'
  );
  
  print('WeatherAPI URL (by coordinates): $url');
  final response = await http.get(url);
  print('Response status: ${response.statusCode}');
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else if (response.statusCode == 400) {
    throw Exception('Location not found');
  } else {
    throw Exception('Failed to load weather data');
  }
}
}