class WeatherModel {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String iconCode;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.iconCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String city) {
    return WeatherModel(
      cityName: city,
      temperature: ((json['main']['temp'] as num) - 273.15).toDouble(),
feelsLike: ((json['main']['feels_like'] as num) - 273.15).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      condition: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/${iconCode}@2x.png';
}
class ForecastDay {
  final String dayName;
  final double tempMax;
  final double tempMin;
  final String condition;
  final String iconCode;

  ForecastDay({
    required this.dayName,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
    required this.iconCode,
  });

  // FIXED: Changed from /img/w/ to /img/wn/ and added @2x.png
  String get iconUrl => 'https://openweathermap.org/img/wn/${iconCode}@2x.png';
  
  // Alternative: If you want to use Material Icons completely instead of network images
  String get iconEmoji {
    final cond = condition.toLowerCase();
    if (cond.contains('thunder') || cond.contains('storm')) return '⛈️';
    if (cond.contains('rain') || cond.contains('drizzle')) return '🌧️';
    if (cond.contains('snow')) return '❄️';
    if (cond.contains('clear') || cond.contains('sun')) return '☀️';
    if (cond.contains('cloud')) {
      if (cond.contains('partly')) return '⛅';
      return '☁️';
    }
    if (cond.contains('fog') || cond.contains('mist')) return '🌫️';
    if (cond.contains('wind')) return '💨';
    return '🌤️';
  }
}

// Add this new class at the end of the file
class HourlyWeatherItem {
  final String time;
  final double temperature;
  final int humidity;
  final String condition;
  final String iconCode;
  final double windSpeed;

  HourlyWeatherItem({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.iconCode,
    required this.windSpeed,
  });

  String get iconUrl => 'https://openweathermap.org/img/w/$iconCode.png';
}