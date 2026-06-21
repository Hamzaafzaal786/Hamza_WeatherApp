import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme_provider.dart';
import '../services/location_service.dart';
import '../services/firestore_service.dart';
import '../services/preferences_service.dart';
import 'search_screen.dart';
import 'about_screen.dart';
import 'favorites_screen.dart';
import 'welcome_screen.dart';
import 'recommendations_screen.dart';
import '../widgets/hourly_forecast_widget.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService _locationService = LocationService();
  final FirestoreService _firestoreService = FirestoreService();
  final PreferencesService _prefsService = PreferencesService();
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _checkAndLoadWeather();
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (shouldExit == true) {
      SystemNavigator.pop();
    }
    return false;
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
  Future<void> _checkAndLoadWeather() async {
    // IMPORTANT: Clear any saved "Goth Shambah" from preferences
    String? lastCity = await _prefsService.getLastSearchedCity();
    
    // If the saved city is "Goth Shambah" or any small locality, ignore it
    if (lastCity != null && 
        (lastCity.toLowerCase().contains('goth') || 
         lastCity.toLowerCase().contains('shambah') ||
         lastCity.length < 3)) {
      print('⚠️ Ignoring saved bad city: $lastCity');
      await _prefsService.clearLastSearchedCity();
      lastCity = null;
    }
    
    if (lastCity != null && lastCity.isNotEmpty) {
      // If user searched for a valid city before, show that city
      print('📌 Using last searched city: $lastCity');
      await context.read<WeatherProvider>().fetchWeather(lastCity);
    } else {
      // Otherwise get current location using coordinates
      print('📍 No valid last city, getting current location...');
      await _getWeatherAtCurrentLocation();
    }
    _isFirstLoad = false;
  }

  Future<void> _getWeatherAtCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enable location services to get current weather'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }
      
      bool hasPermission = await _locationService.checkPermissions();

      if (hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Getting your location...'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        
        // IMPORTANT: Use fetchWeatherByLocation which uses coordinates
        await context.read<WeatherProvider>().fetchWeatherByLocation();
        
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied. Please search for a city.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not get your location. Please search for a city.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

String _getWeatherEmoji(String condition) {
  final cond = condition.toLowerCase();
  
  // Clear / Sunny
  if (cond.contains('clear') || cond.contains('sun')) {
    return '☀️';
  }
  // Partly Cloudy
  else if (cond.contains('partly cloudy')) {
    return '⛅';
  }
  // Cloudy
  else if (cond.contains('cloud') || cond.contains('overcast')) {
    return '☁️';
  }
  // Rain
  else if (cond.contains('rain') || cond.contains('drizzle')) {
    if (cond.contains('light')) return '🌦️';
    if (cond.contains('heavy')) return '☔';
    return '🌧️';
  }
  // Thunderstorm
  else if (cond.contains('thunder') || cond.contains('storm')) {
    return '⛈️';
  }
  // Snow
  else if (cond.contains('snow')) {
    if (cond.contains('light')) return '❄️';
    if (cond.contains('heavy')) return '🌨️';
    return '⛄';
  }
  // Fog / Mist
  else if (cond.contains('fog') || cond.contains('mist') || cond.contains('haze')) {
    return '🌫️';
  }
  // Wind
  else if (cond.contains('wind')) {
    return '💨';
  }
  // Hot
  else if (cond.contains('hot')) {
    return '🔥';
  }
  // Cold
  else if (cond.contains('cold')) {
    return '🥶';
  }
  // Default
  else {
    return '🌡️';
  }
} 
  Future<void> _searchAndFetchWeather(String city) async {
    // Save the searched city to preferences
    await _prefsService.saveLastSearchedCity(city);
    await context.read<WeatherProvider>().fetchWeather(city);
  }

  Future<void> _refreshToCurrentLocation() async {
    // Clear saved city and get current location
    await _prefsService.clearLastSearchedCity();
    await _getWeatherAtCurrentLocation();
  }

  Future<void> _logout(BuildContext context) async {
  // Navigate immediately without waiting
  if (mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }
  
  // Do cleanup in background (fire and forget)
  context.read<AuthProvider>().signOut();
  context.read<WeatherProvider>().clearWeather();
  _prefsService.clearLastSearchedCity();
}

  Widget _buildMenuSheet(BuildContext context) {
    final weatherProvider = context.read<WeatherProvider>();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    final currentCity = weatherProvider.weather?.cityName;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (user != null)
              Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email ?? 'User',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white70 
                          : Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                ],
              ),

            const Divider(height: 1, thickness: 0.5),

            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                return ListTile(
                  leading: Icon(
                    Icons.thermostat,
                    size: 22,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey.shade700,
                  ),
                  title: Text(
                    'Temperature Unit',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey.shade800,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        weatherProvider.isCelsius ? '°C' : '°F',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Switch(
                        value: weatherProvider.isCelsius,
                        onChanged: (_) {
                          weatherProvider.toggleUnit();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(height: 1, thickness: 0.5),

            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return ListTile(
                  leading: Icon(
                    themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    size: 22,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey.shade700,
                  ),
                  title: Text(
                    themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey.shade800,
                    ),
                  ),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                );
              },
            ),

            const Divider(height: 1, thickness: 0.5),

            ListTile(
              leading: Icon(
                Icons.favorite_border,
                size: 22,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey.shade700,
              ),
              title: Text(
                'My Favorites',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey.shade800,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.grey.shade500,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                );
              },
            ),

            const Divider(height: 1, thickness: 0.5),

            ListTile(
              leading: Icon(
                Icons.psychology,
                size: 22,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF4A90E2),
              ),
              title: Text(
                'Weather Recommendations',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey.shade800,
                ),
              ),
              subtitle: Text(
                'Smart tips for your day',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white54
                      : Colors.grey.shade500,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.grey.shade500,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecommendationsScreen()),
                );
              },
            ),

            const Divider(height: 1, thickness: 0.5),

            if (currentCity != null)
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red, size: 22),
                    title: Text(
                      'Save Current City',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.grey.shade800,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.grey.shade500,
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      try {
                        await _firestoreService.addFavoriteCity(currentCity);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$currentCity saved to favorites!')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login to save favorites')),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(height: 1, thickness: 0.5),
                ],
              ),

            // Current Location Menu Item - Shows the actual city
            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                final currentCityName = weatherProvider.weather?.cityName;
                return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    size: 22,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey.shade700,
                  ),
                  title: Text(
                    currentCityName != null 
                        ? 'Current: $currentCityName'
                        : 'Current Location',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey.shade800,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.grey.shade500,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _refreshToCurrentLocation();
                  },
                );
              },
            ),

            const Divider(height: 1, thickness: 0.5),

            ListTile(
              leading: Icon(
                Icons.info_outline,
                size: 22,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey.shade700,
              ),
              title: Text(
                'About Us',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey.shade800,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.grey.shade500,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),

            const Divider(height: 1, thickness: 0.5),

            ListTile(
  leading: const Icon(Icons.logout, color: Colors.red, size: 22),
  title: const Text(
    'Logout',
    style: TextStyle(color: Colors.red, fontSize: 14),
  ),
  trailing: Icon(
    Icons.arrow_forward_ios,
    size: 14,
    color: Colors.red.withOpacity(0.7),
  ),
  onTap: () {
    // Close menu and go to welcome screen
    Navigator.pop(context);
    _logout(context);
  },
),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          
          // Loading Screen
          if (provider.isLoading && _isFirstLoad) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF1A1A2E),
                            Color(0xFF16213E),
                            Color(0xFF0F3460),
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFE8F0FE),
                            Color(0xFFD4E4FC),
                            Color(0xFFB8D0F5),
                          ],
                        ),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            );
          }

          // Error Screen
          if (provider.error != null) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF1A1A2E),
                            Color(0xFF16213E),
                            Color(0xFF0F3460),
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFE8F0FE),
                            Color(0xFFD4E4FC),
                            Color(0xFFB8D0F5),
                          ],
                        ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.8)
                                : Colors.red.shade400,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Unable to Load Weather',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            provider.error!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              provider.clearWeather();
                              _refreshToCurrentLocation();
                            },
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF4A90E2),
                              foregroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF667eea)
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              provider.clearWeather();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SearchScreen()),
                              ).then((result) {
                                if (result != null && result is String && result.isNotEmpty) {
                                  _searchAndFetchWeather(result);
                                }
                              });
                            },
                            child: const Text('Search City Instead', style: TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // Welcome Screen - No weather loaded yet
          if (provider.weather == null && !provider.isLoading) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF1A1A2E),
                            Color(0xFF16213E),
                            Color(0xFF0F3460),
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFE8F0FE),
                            Color(0xFFD4E4FC),
                            Color(0xFFB8D0F5),
                          ],
                        ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.menu,
                                size: 22,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey.shade700,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => _buildMenuSheet(context),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
                                size: 22,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey.shade700,
                              ),
                              onPressed: () {
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  if (mounted) {
                                    themeProvider.toggleTheme();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_queue,
                                size: 70,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF4A90E2),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'SkyCast',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Search for a city to get started',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                                  );
                                  if (result != null) {
                                    await _searchAndFetchWeather(result);
                                  }
                                },
                                icon: const Icon(Icons.search, size: 18),
                                label: const Text('Search City'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF4A90E2),
                                  foregroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF667eea) : Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _refreshToCurrentLocation,
                                child: Text(
                                  'Use Current Location',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white70
                                        : const Color(0xFF4A90E2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Weather Display Screen
          final weather = provider.weather;
          if (weather == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final condition = weather.condition.toLowerCase();

          Gradient getGradient() {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            if (condition.contains('clear') || condition.contains('sun')) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                    : [const Color(0xFFFF9800), const Color(0xFFFF5722)],
              );
            } else if (condition.contains('cloud')) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF2C3E50), const Color(0xFF1A252F)]
                    : [Colors.grey.shade500, Colors.grey.shade700],
              );
            } else if (condition.contains('rain')) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF0F3460), const Color(0xFF1A1A2E)]
                    : [const Color(0xFF4A90E2), const Color(0xFF357ABD)],
              );
            } else {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF1A1A2E), const Color(0xFF0F3460)]
                    : [const Color(0xFF43A047), const Color(0xFF1B5E20)],
              );
            }
          }

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(gradient: getGradient()),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        size: 14, color: Colors.white70),
                                    const SizedBox(width: 3),
                                    Text(
                                      weather.cityName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Today\'s Weather',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                
                                IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Colors.white, size: 22),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchScreen()),
                                    );
                                    if (result != null &&
                                        result is String &&
                                        result.isNotEmpty) {
                                      await provider.fetchWeather(result);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.psychology,
                                      color: Colors.white, size: 22),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const RecommendationsScreen()),
                                    );
                                  },
                                  tooltip: 'Weather Recommendations',
                                ),
                                
                                IconButton(
                                  icon: const Icon(Icons.menu,
                                      color: Colors.white, size: 22),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          _buildMenuSheet(context),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.15),
    borderRadius: BorderRadius.circular(25),
  ),
  child: Column(
    children: [
      // Main Weather Icon - Using Material Icons (same as recommendations screen)
      Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Icon(
          _getWeatherIcon(weather.condition),
          size: 45,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 12),
      // Temperature
      Text(
        '${provider.getTemperatureInCurrentUnit(weather.temperature).toStringAsFixed(1)}${provider.getTemperatureUnit()}',
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      const SizedBox(height: 6),
      // Condition Text
      Text(
        weather.condition.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          color: Colors.white.withOpacity(0.8),
          letterSpacing: 1,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  ),
),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            _buildDetailCard(
                              icon: Icons.thermostat,
                              label: 'Feels Like',
                              value: '${provider.getTemperatureInCurrentUnit(weather.feelsLike).toStringAsFixed(1)}${provider.getTemperatureUnit()}',
                            ),
                            const SizedBox(width: 10),
                            _buildDetailCard(
                              icon: Icons.water_drop,
                              label: 'Humidity',
                              value: '${weather.humidity}%',
                            ),
                            const SizedBox(width: 10),
                            _buildDetailCard(
                              icon: Icons.air,
                              label: 'Wind Speed',
                              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Hourly Forecast
                        if (provider.hourlyForecast != null &&
                            provider.hourlyForecast!.isNotEmpty)
                          const HourlyForecastWidget(),

                        const SizedBox(height: 20),

                        // 5-Day Forecast
                        if (provider.forecast != null &&
                            provider.forecast!.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '5-DAY FORECAST',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...provider.forecast!.take(5).map((day) =>
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 45,
                                            child: Text(
                                              day.dayName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          Text(
  _getWeatherEmoji(day.condition),
  style: const TextStyle(fontSize: 24),
),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              day.condition,
                                              style: TextStyle(
                                                color:
                                                    Colors.white.withOpacity(0.7),
                                                fontSize: 11,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${provider.getTemperatureInCurrentUnit(day.tempMax).toStringAsFixed(0)}${provider.getTemperatureUnit()}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '${provider.getTemperatureInCurrentUnit(day.tempMin).toStringAsFixed(0)}${provider.getTemperatureUnit()}',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}