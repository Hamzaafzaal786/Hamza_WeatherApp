import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/theme_provider.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  DateTime _selectedTime = DateTime.now();
  bool _isLoading = false;
  
  // Recommendation items
  List<RecommendationItem> _recommendations = [];
  
  // Weather conditions mapping
  final Map<String, List<RecommendationItem>> _recommendationMap = {
    'rain': [
      RecommendationItem(
        icon: Icons.beach_access,
        title: 'Take an Umbrella',
        description: 'Rain expected. Don\'t forget your umbrella!',
        priority: 'high',
        color: Colors.blue,
      ),
      RecommendationItem(
        icon: Icons.umbrella,
        title: 'Wear Raincoat',
        description: 'Waterproof jacket recommended',
        priority: 'high',
        color: Colors.blue,
      ),
      RecommendationItem(
        icon: Icons.science,
        title: 'Waterproof Shoes',
        description: 'Keep your feet dry with waterproof footwear',
        priority: 'medium',
        color: Colors.blue,
      ),
      RecommendationItem(
        icon: Icons.charging_station,
        title: 'Charge Your Phone',
        description: 'Stay connected in case of power outages',
        priority: 'low',
        color: Colors.grey,
      ),
    ],
    'thunderstorm': [
      RecommendationItem(
        icon: Icons.warning_amber,
        title: 'STAY INDOORS!',
        description: 'Severe thunderstorm warning. Avoid going outside.',
        priority: 'critical',
        color: Colors.red,
      ),
      RecommendationItem(
        icon: Icons.power,
        title: 'Unplug Electronics',
        description: 'Protect devices from power surges',
        priority: 'high',
        color: Colors.orange,
      ),
      RecommendationItem(
        icon: Icons.shield,
        title: 'Stay Away from Windows',
        description: 'Move to an interior room',
        priority: 'high',
        color: Colors.red,
      ),
      RecommendationItem(
        icon: Icons.emergency,
        title: 'Emergency Kit Ready',
        description: 'Keep flashlight and first aid nearby',
        priority: 'medium',
        color: Colors.orange,
      ),
    ],
    'clear': [
      RecommendationItem(
        icon: Icons.wb_sunny,
        title: 'Wear Sunscreen',
        description: 'SPF 30+ recommended for sun protection',
        priority: 'high',
        color: Colors.orange,
      ),
      RecommendationItem(
        icon: Icons.emoji_emotions,
        title: 'Sunglasses',
        description: 'Protect your eyes from UV rays',
        priority: 'medium',
        color: Colors.orange,
      ),
      RecommendationItem(
        icon: Icons.water_drop,
        title: 'Stay Hydrated',
        description: 'Carry a water bottle with you',
        priority: 'high',
        color: Colors.blue,
      ),
      RecommendationItem(
        icon: Icons.sports_baseball,
        title: 'Wear a Cap',
        description: 'Protect your face from direct sunlight',
        priority: 'medium',
        color: Colors.orange,
      ),
      RecommendationItem(
        icon: Icons.sports_tennis,
        title: 'Perfect for Outdoor Activities',
        description: 'Great weather for sports and walks',
        priority: 'low',
        color: Colors.green,
      ),
    ],
    'clouds': [
      RecommendationItem(
        icon: Icons.cloud,
        title: 'Light Jacket',
        description: 'Cloudy skies might feel cooler',
        priority: 'medium',
        color: Colors.blue,
      ),
      RecommendationItem(
        icon: Icons.visibility,
        title: 'Good Visibility',
        description: 'Safe for driving and outdoor activities',
        priority: 'low',
        color: Colors.green,
      ),
      RecommendationItem(
        icon: Icons.camera_alt,
        title: 'Great for Photography',
        description: 'Diffused lighting is perfect for photos',
        priority: 'low',
        color: Colors.purple,
      ),
    ],
    'snow': [
      RecommendationItem(
        icon: Icons.ac_unit,
        title: 'Wear Heavy Jacket',
        description: 'Stay warm with layered clothing',
        priority: 'high',
        color: Colors.blue,
      ),
      RecommendationItem(
        icon: Icons.warning,
        title: 'Watch Your Step',
        description: 'Icy surfaces can be slippery',
        priority: 'high',
        color: Colors.orange,
      ),
      RecommendationItem(
        icon: Icons.car_repair,
        title: 'Winter Tires',
        description: 'Ensure your vehicle is snow-ready',
        priority: 'medium',
        color: Colors.blue,
      ),
      RecommendationItem(
        icon: Icons.health_and_safety,
        title: 'Gloves & Scarf',
        description: 'Protect exposed skin from frost',
        priority: 'high',
        color: Colors.blue,
      ),
    ],
    'hot': [
      RecommendationItem(
        icon: Icons.local_drink,
        title: 'Drink More Water',
        description: 'High temperatures increase dehydration risk',
        priority: 'high',
        color: Colors.blue,
      ),
      RecommendationItem(
        icon: Icons.beach_access,
        title: 'Stay in Shade',
        description: 'Avoid direct sunlight during peak hours',
        priority: 'high',
        color: Colors.orange,
      ),
      RecommendationItem(
        icon: Icons.wb_sunny,
        title: 'Light Clothing',
        description: 'Wear breathable, light-colored clothes',
        priority: 'high',
        color: Colors.orange,
      ),
      RecommendationItem(
        icon: Icons.ac_unit,
        title: 'Plan Indoor Activities',
        description: 'Avoid outdoor activities in afternoon',
        priority: 'medium',
        color: Colors.blue,
      ),
    ],
    'fog': [
      RecommendationItem(
        icon: Icons.health_and_safety,
        title: 'Wear Mask',
        description: 'Fog can trap pollutants. Protect your lungs.',
        priority: 'high',
        color: Colors.grey,
      ),
      RecommendationItem(
        icon: Icons.car_repair,
        title: 'Drive Carefully',
        description: 'Use fog lights and maintain safe distance',
        priority: 'high',
        color: Colors.orange,
      ),
      RecommendationItem(
        icon: Icons.access_time,
        title: 'Allow Extra Travel Time',
        description: 'Visibility may cause delays',
        priority: 'medium',
        color: Colors.blue,
      ),
    ],
    'wind': [
      RecommendationItem(
        icon: Icons.wind_power,
        title: 'Secure Loose Items',
        description: 'Strong winds can blow away light objects',
        priority: 'high',
        color: Colors.orange,
      ),
      RecommendationItem(
        icon: Icons.air,
        title: 'Wear Windbreaker',
        description: 'Protect yourself from cold wind',
        priority: 'medium',
        color: Colors.blue,
      ),
      RecommendationItem(
        icon: Icons.warning_amber,
        title: 'Avoid Tall Trees',
        description: 'Risk of falling branches in high winds',
        priority: 'high',
        color: Colors.red,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _updateRecommendations();
  }

  void _updateRecommendations() {
    setState(() {
      _isLoading = true;
      _recommendations = _getRecommendationsForTime(_selectedTime);
      _isLoading = false;
    });
  }

  List<RecommendationItem> _getRecommendationsForTime(DateTime time) {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final weather = weatherProvider.weather;
    
    if (weather == null) return [];
    
    final condition = weather.condition.toLowerCase();
    final temp = weather.temperature;
    final humidity = weather.humidity;
    final windSpeed = weather.windSpeed;
    final hour = time.hour;
    
    String primaryCondition = _getPrimaryCondition(condition, temp, humidity, windSpeed);
    
    List<RecommendationItem> recommendations = [];
    
    // Get base recommendations from condition map
    if (_recommendationMap.containsKey(primaryCondition)) {
      recommendations.addAll(_recommendationMap[primaryCondition]!);
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      recommendations.addAll(_recommendationMap['rain']!);
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      recommendations.addAll(_recommendationMap['thunderstorm']!);
    } else if (condition.contains('clear') || condition.contains('sun')) {
      if (temp > 30) {
        recommendations.addAll(_recommendationMap['hot']!);
      } else {
        recommendations.addAll(_recommendationMap['clear']!);
      }
    } else if (condition.contains('cloud')) {
      recommendations.addAll(_recommendationMap['clouds']!);
    } else if (condition.contains('snow')) {
      recommendations.addAll(_recommendationMap['snow']!);
    } else if (condition.contains('fog') || condition.contains('mist')) {
      recommendations.addAll(_recommendationMap['fog']!);
    } else {
      // Default recommendations
      recommendations.addAll(_getDefaultRecommendations());
    }
    
    // Add time-specific recommendations
    recommendations.addAll(_getTimeSpecificRecommendations(hour, temp, condition));
    
    // Add extreme weather warnings
    if (windSpeed > 15) {
      recommendations.add(RecommendationItem(
        icon: Icons.warning,
        title: 'High Wind Alert!',
        description: 'Wind speed ${windSpeed.toStringAsFixed(1)} m/s. Be cautious outdoors.',
        priority: 'high',
        color: Colors.red,
      ));
    }
    
    if (temp > 35) {
      recommendations.add(RecommendationItem(
        icon: Icons.health_and_safety,
        title: 'Extreme Heat Warning',
        description: 'Stay indoors during peak hours (12 PM - 4 PM)',
        priority: 'critical',
        color: Colors.red,
      ));
    }
    
    if (temp < 0) {
      recommendations.add(RecommendationItem(
        icon: Icons.ac_unit,
        title: 'Sub-Zero Alert!',
        description: 'Dress in multiple layers. Limit time outdoors.',
        priority: 'critical',
        color: Colors.red,
      ));
    }
    
    if (humidity > 80) {
      recommendations.add(RecommendationItem(
        icon: Icons.water_drop,
        title: 'High Humidity',
        description: 'You may feel sticky. Stay hydrated and wear breathable fabrics.',
        priority: 'medium',
        color: Colors.blue,
      ));
    }
    
    // Sort by priority (critical > high > medium > low)
    recommendations.sort((a, b) {
      final priorityOrder = {'critical': 0, 'high': 1, 'medium': 2, 'low': 3};
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });
    
    // Remove duplicates based on title
    final uniqueRecommendations = <RecommendationItem>[];
    final titles = <String>{};
    for (var rec in recommendations) {
      if (!titles.contains(rec.title)) {
        titles.add(rec.title);
        uniqueRecommendations.add(rec);
      }
    }
    
    return uniqueRecommendations.take(8).toList();
  }
  IconData _getWeatherIcon(String condition) {
  final cond = condition.toLowerCase();
  
  if (cond.contains('thunder') || cond.contains('storm')) {
    return Icons.flash_on;
  } else if (cond.contains('rain') || cond.contains('drizzle')) {
    return Icons.grain;
  } else if (cond.contains('snow')) {
    return Icons.ac_unit;
  } else if (cond.contains('clear') || cond.contains('sun')) {
    return Icons.wb_sunny;
  } else if (cond.contains('cloud')) {
    if (cond.contains('partly')) {
      return Icons.wb_cloudy;
    }
    return Icons.cloud;
  } else if (cond.contains('fog') || cond.contains('mist')) {
    return Icons.foggy;
  } else if (cond.contains('wind')) {
    return Icons.air;
  } else {
    return Icons.cloud_queue;
  }
}
  String _getPrimaryCondition(String condition, double temp, int humidity, double windSpeed) {
    if (condition.contains('thunder')) return 'thunderstorm';
    if (condition.contains('rain') || condition.contains('drizzle')) return 'rain';
    if (condition.contains('snow')) return 'snow';
    if (condition.contains('fog') || condition.contains('mist')) return 'fog';
    if (windSpeed > 10) return 'wind';
    if (temp > 30) return 'hot';
    if (condition.contains('clear')) return 'clear';
    if (condition.contains('cloud')) return 'clouds';
    return 'clear';
  }

  List<RecommendationItem> _getTimeSpecificRecommendations(int hour, double temp, String condition) {
    List<RecommendationItem> timeRecs = [];
    
    // Morning (5 AM - 11 AM)
    if (hour >= 5 && hour <= 11) {
      timeRecs.add(RecommendationItem(
        icon: Icons.wb_twilight,
        title: 'Morning Hours',
        description: 'Great time for morning walk or exercise',
        priority: 'low',
        color: Colors.orange,
      ));
      if (hour <= 8 && temp < 15) {
        timeRecs.add(RecommendationItem(
          icon: Icons.brush,
          title: 'Morning Chill',
          description: 'Layer up for the cool morning air',
          priority: 'medium',
          color: Colors.blue,
        ));
      }
    }
    // Afternoon (12 PM - 4 PM)
    else if (hour >= 12 && hour <= 16) {
      if (temp > 30) {
        timeRecs.add(RecommendationItem(
          icon: Icons.shield,
          title: 'Peak Sun Hours',
          description: 'Avoid direct sunlight. Seek shade or stay indoors.',
          priority: 'high',
          color: Colors.red,
        ));
      }
      timeRecs.add(RecommendationItem(
        icon: Icons.restaurant,
        title: 'Lunch Time',
        description: 'Stay hydrated and eat light meals',
        priority: 'low',
        color: Colors.green,
      ));
    }
    // Evening (5 PM - 8 PM)
    else if (hour >= 17 && hour <= 20) {
      timeRecs.add(RecommendationItem(
        icon: Icons.terrain,
        title: 'Golden Hour',
        description: 'Perfect time for outdoor photos and walks',
        priority: 'low',
        color: Colors.purple,
      ));
    }
    // Night (9 PM - 4 AM)
    else {
      timeRecs.add(RecommendationItem(
        icon: Icons.nights_stay,
        title: 'Night Time',
        description: 'If going out, wear reflective clothing for safety',
        priority: 'medium',
        color: Colors.blue,
      ));
    }
    
    return timeRecs;
  }

  List<RecommendationItem> _getDefaultRecommendations() {
    return [
      RecommendationItem(
        icon: Icons.health_and_safety,
        title: 'Stay Healthy',
        description: 'Get enough rest and stay hydrated',
        priority: 'low',
        color: Colors.green,
      ),
      RecommendationItem(
        icon: Icons.phone_android,
        title: 'Check Forecast',
        description: 'Weather can change. Stay updated.',
        priority: 'low',
        color: Colors.grey,
      ),
    ];
  }

  Future<void> _selectTime(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTime,
      firstDate: now,
      lastDate: now.add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Provider.of<ThemeProvider>(context).isDarkMode 
                  ? Colors.white 
                  : const Color(0xFF4A90E2),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedTime) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: Provider.of<ThemeProvider>(context).isDarkMode 
                    ? Colors.white 
                    : const Color(0xFF4A90E2),
              ),
            ),
            child: child!,
          );
        },
      );
      
      if (time != null) {
        setState(() {
          _selectedTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
          _updateRecommendations();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.weather;
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Recommendations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: weather == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 64,
                    color: isDarkMode ? Colors.white54 : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No weather data available',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A1A2E),
                          Color(0xFF16213E),
                          Color(0xFF0F3460),
                        ],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE8F0FE),
                          Color(0xFFD4E4FC),
                          Color(0xFFB8D0F5),
                        ],
                      ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Weather Summary
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: isDarkMode 
        ? Colors.white.withOpacity(0.1) 
        : Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Row(
    children: [
      // Updated icon section - same as home screen
      weather.iconCode.isNotEmpty
          ? Image.network(
              weather.iconUrl,
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _getWeatherIcon(weather.condition),
                  size: 50,
                  color: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              },
            )
          : Icon(
              _getWeatherIcon(weather.condition),
              size: 50,
              color: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
            ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.cityName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.grey.shade800,
              ),
            ),
            Text(
              '${weather.condition} • ${weatherProvider.getTemperatureInCurrentUnit(weather.temperature).toStringAsFixed(1)}${weatherProvider.getTemperatureUnit()}',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

                      const SizedBox(height: 24),

                      // Time Selection Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? Colors.white.withOpacity(0.1) 
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'WHEN ARE YOU GOING OUT?',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () => _selectTime(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isDarkMode 
                                      ? Colors.white.withOpacity(0.05) 
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDarkMode 
                                        ? Colors.white24 
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 20,
                                          color: isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          _formatDateTime(_selectedTime),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: isDarkMode ? Colors.white : Colors.grey.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.edit_calendar,
                                      color: isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Recommendations Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '📋 RECOMMENDATIONS',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: isDarkMode ? Colors.white : Colors.grey.shade800,
                            ),
                          ),
                          if (_recommendations.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_recommendations.length} tips',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Recommendations List
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_recommendations.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: isDarkMode 
                                ? Colors.white.withOpacity(0.1) 
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.psychology,
                                size: 48,
                                color: isDarkMode ? Colors.white54 : Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No specific recommendations\nfor this time',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recommendations.length,
                          itemBuilder: (context, index) {
                            final rec = _recommendations[index];
                            return _buildRecommendationCard(rec, isDarkMode);
                          },
                        ),

                      const SizedBox(height: 16),

                      // Disclaimer
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Recommendations are based on current weather forecast. Always use your best judgment.',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildRecommendationCard(RecommendationItem rec, bool isDarkMode) {
    Color priorityColor;
    switch (rec.priority) {
      case 'critical':
        priorityColor = Colors.red;
        break;
      case 'high':
        priorityColor = Colors.orange;
        break;
      case 'medium':
        priorityColor = Colors.blue;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            rec.color.withOpacity(isDarkMode ? 0.2 : 0.1),
            isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: rec.priority == 'critical'
              ? Colors.red
              : priorityColor.withOpacity(0.3),
          width: rec.priority == 'critical' ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rec.color.withOpacity(0.2),
          child: Icon(rec.icon, color: rec.color),
        ),
        title: Text(
          rec.title,
          style: TextStyle(
            fontWeight: rec.priority == 'critical' ? FontWeight.bold : FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.grey.shade800,
          ),
        ),
        subtitle: Text(
          rec.description,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.white54 : Colors.grey.shade600,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: priorityColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            rec.priority.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: priorityColor,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    
    String dateStr;
    if (dateTime.day == now.day && dateTime.month == now.month && dateTime.year == now.year) {
      dateStr = 'Today';
    } else if (dateTime.day == tomorrow.day && dateTime.month == tomorrow.month && dateTime.year == tomorrow.year) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}';
    }
    
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$dateStr at $hour:$minute';
  }
}

class RecommendationItem {
  final IconData icon;
  final String title;
  final String description;
  final String priority; // critical, high, medium, low
  final Color color;

  RecommendationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.priority,
    required this.color,
  });
}