import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';

class ApiService {
  static const String apiKey = 'APIkey*********';
  
  Future<WeatherModel> fetchWeather(String cityName) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey'
    );
    
    print('Weather URL: $url');
    final response = await http.get(url);
    print('Weather Response Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data, cityName);
    } else if (response.statusCode == 404) {
      throw Exception('City not found');
    } else {
      throw Exception('Failed to load weather. Status code: ${response.statusCode}');
    }
  }

  Future<List<ForecastDay>> fetchForecast(String cityName) async {
  final url = Uri.parse(
    'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric'
  );
  
  print('Forecast URL: $url');
  final response = await http.get(url);
  print('Forecast Response Status: ${response.statusCode}');
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> list = data['list'];
    
    Map<String, ForecastDay> dailyForecast = {};
    
    for (var item in list) {
      DateTime date = DateTime.parse(item['dt_txt']);
      String dayKey = '${date.year}-${date.month}-${date.day}';
      String dayName = _getDayName(date);
      
      double tempMax = (item['main']['temp_max'] as num).toDouble();
      double tempMin = (item['main']['temp_min'] as num).toDouble();
      String condition = item['weather'][0]['description'];
      String iconCode = item['weather'][0]['icon'];
      
      if (!dailyForecast.containsKey(dayKey)) {
        dailyForecast[dayKey] = ForecastDay(
          dayName: dayName,
          tempMax: tempMax,
          tempMin: tempMin,
          condition: condition,
          iconCode: iconCode,
        );
      } else {
        ForecastDay existing = dailyForecast[dayKey]!;
        dailyForecast[dayKey] = ForecastDay(
          dayName: dayName,
          tempMax: tempMax > existing.tempMax ? tempMax : existing.tempMax,
          tempMin: tempMin < existing.tempMin ? tempMin : existing.tempMin,
          condition: condition,
          iconCode: iconCode,
        );
      }
    }
    
    return dailyForecast.values.toList().take(5).toList();
  } else if (response.statusCode == 404) {
    print('City not found in OpenWeatherMap: $cityName');
    return []; // Return empty list instead of throwing
  } else {
    print('Failed to load forecast: ${response.statusCode}');
    return []; // Return empty list
  }
}

  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}
