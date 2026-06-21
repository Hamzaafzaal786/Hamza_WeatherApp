import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HourlyForecastWidget extends StatelessWidget {
  const HourlyForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        final hourly = provider.hourlyForecast;
        
        if (hourly == null || hourly.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'HOURLY FORECAST',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Next ${hourly.length > 24 ? 24 : hourly.length} hours',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: hourly.length > 24 ? 24 : hourly.length,
                itemBuilder: (context, index) {
                  final hour = hourly[index];
                  final temp = provider.getTemperatureInCurrentUnit(hour.temperature);
                  final unit = provider.getTemperatureUnit();
                  
                  return Container(
                    width: 75,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hour.formattedTime,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Rain chance indicator
                        if (hour.chanceOfRain > 20)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${hour.chanceOfRain}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Image.network(
                          hour.iconUrl,
                          height: 35,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(_getWeatherIcon(hour.condition), color: Colors.white, size: 30),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${temp.toStringAsFixed(0)}$unit',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getWeatherIcon(String condition) {
    final cond = condition.toLowerCase();
    if (cond.contains('sun') || cond.contains('clear')) return Icons.wb_sunny;
    if (cond.contains('cloud')) return Icons.cloud;
    if (cond.contains('rain')) return Icons.water_drop;
    if (cond.contains('thunder')) return Icons.flash_on;
    if (cond.contains('snow')) return Icons.ac_unit;
    return Icons.cloud_queue;
  }
  
}