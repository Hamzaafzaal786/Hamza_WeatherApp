import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../providers/weather_provider.dart';

class ForecastWidget extends StatelessWidget {
  final List<ForecastDay> forecast;

  const ForecastWidget({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5-DAY FORECAST',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              IconButton(
                icon: Icon(
                  provider.isCelsius ? Icons.thermostat : Icons.thermostat_outlined,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () => provider.toggleUnit(),
                tooltip: 'Toggle °C/°F',
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: forecast.asMap().entries.map((entry) {
              int index = entry.key;
              ForecastDay day = entry.value;
              double maxTemp = provider.getTemperatureInCurrentUnit(day.tempMax);
              double minTemp = provider.getTemperatureInCurrentUnit(day.tempMin);
              String unit = provider.getTemperatureUnit();
              
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            day.dayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Image.network(
                          day.iconUrl,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            day.condition,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${maxTemp.toStringAsFixed(0)}$unit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${minTemp.toStringAsFixed(0)}$unit',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index != forecast.length - 1)
                    Divider(
                      color: Colors.white24,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}