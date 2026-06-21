import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/theme_provider.dart';
import '../services/location_service.dart';
import '../widgets/exit_confirmation.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final LocationService _locationService = LocationService();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeatherAtCurrentLocation();
  }

  Future<void> _loadWeatherAtCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      bool hasPermission = await _locationService.checkPermissions();

      if (hasPermission) {
        String city = await _locationService.getCurrentCity();
        if (city != 'Unknown' && mounted) {
          await context.read<WeatherProvider>().fetchWeather(city);
        } else {
          setState(() {
            _error = 'Could not detect your location';
          });
        }
      } else {
        setState(() {
          _error = 'Location permission denied';
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _error = 'Failed to get weather';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return WillPopScope(
      onWillPop: () => ExitConfirmation.showExitDialog(context),
      child: Scaffold(
        body: Container(
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
          child: SafeArea(
            child: Column(
              children: [
                // Top Bar with Theme Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: isDarkMode ? Colors.white : Colors.grey.shade700,
                        ),
                        onPressed: () => themeProvider.toggleTheme(),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // App Logo
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              gradient: isDarkMode
                                  ? const LinearGradient(
                                      colors: [Colors.white, Colors.white70],
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                    ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.cloud_queue,
                              size: 35,
                              color: isDarkMode ? const Color(0xFF667eea) : Colors.white,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // App Name
                          Text(
                            'SkyCast',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.grey.shade800,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Your Personal Weather App',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Weather Card
                          _buildWeatherCard(weatherProvider, isDarkMode, _isLoading, _error),

                          const SizedBox(height: 24),

                          // Divider
                          Divider(
                            color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
                            thickness: 0.5,
                          ),

                          const SizedBox(height: 20),

                          // Features Section
                          _buildFeaturesSection(isDarkMode),

                          const SizedBox(height: 24),

                          // Sign In / Sign Up Buttons
                          _buildActionButtons(context, isDarkMode),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard(WeatherProvider provider, bool isDarkMode, bool isLoading, String? error) {
    if (isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 12),
            Text(
              'Getting your weather...',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (error != null || provider.weather == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(
              Icons.location_off,
              size: 40,
              color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
            ),
            const SizedBox(height: 12),
            Text(
              error ?? 'Unable to load weather',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadWeatherAtCurrentLocation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                backgroundColor: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                foregroundColor: isDarkMode ? const Color(0xFF667eea) : Colors.white,
              ),
              child: const Text('Retry', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      );
    }

    final weather = provider.weather!;
    final temp = provider.getTemperatureInCurrentUnit(weather.temperature);
    final unit = provider.getTemperatureUnit();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 14,
                color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
              ),
              const SizedBox(width: 3),
              Text(
                weather.cityName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Image.network(
            weather.iconUrl,
            height: 55,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.cloud, size: 55, color: isDarkMode ? Colors.white : const Color(0xFF4A90E2)),
          ),
          const SizedBox(height: 6),

          Text(
            '${temp.toStringAsFixed(1)}$unit',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            weather.condition.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.5,
              color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBasicDetail(
                icon: Icons.thermostat,
                label: 'Feels',
                value: '${provider.getTemperatureInCurrentUnit(weather.feelsLike).toStringAsFixed(1)}$unit',
                isDarkMode: isDarkMode,
              ),
              _buildBasicDetail(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '${weather.humidity}%',
                isDarkMode: isDarkMode,
              ),
              _buildBasicDetail(
                icon: Icons.air,
                label: 'Wind',
                value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicDetail({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: isDarkMode ? Colors.white54 : Colors.grey.shade500),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(bool isDarkMode) {
    final List<Map<String, dynamic>> features = [
      {'icon': Icons.search, 'title': 'Search Any City', 'desc': 'Weather for any city'},
      {'icon': Icons.calendar_today, 'title': 'Hourly Forecast', 'desc': '24-hour forecast'},
      {'icon': Icons.calendar_month, 'title': '5-Day Forecast', 'desc': 'Plan your week'},
      {'icon': Icons.thermostat, 'title': '°C / °F Toggle', 'desc': 'Switch units'},
      {'icon': Icons.favorite, 'title': 'Favorite Cities', 'desc': 'Save cities'},
      {'icon': Icons.cloud_sync, 'title': 'Cloud Sync', 'desc': 'Sync devices'},
      {'icon': Icons.psychology, 'title': 'Smart Tips', 'desc': 'Weather advice'},
      {'icon': Icons.wb_twilight, 'title': 'Packing Tips', 'desc': 'What to bring'},
      {'icon': Icons.warning_amber, 'title': 'Severe Alerts', 'desc': 'Weather warnings'},
      {'icon': Icons.timer, 'title': 'Best Time', 'desc': 'Optimal timing'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '✨ FEATURES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.grey.shade800,
                letterSpacing: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF667eea)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${features.length}+',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.8,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]
                      : [Colors.white, Colors.grey.shade50],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.1) 
                      : Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF667eea)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      feature['icon'],
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature['title'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          feature['desc'],
                          style: TextStyle(
                            fontSize: 8,
                            color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
            foregroundColor: isDarkMode ? const Color(0xFF667eea) : Colors.white,
            minimumSize: const Size(double.infinity, 42),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'SIGN IN',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),

        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SignupScreen()),
              (route) => false,
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
              width: 1,
            ),
            minimumSize: const Size(double.infinity, 42),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'CREATE NEW ACCOUNT',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
            ),
          ),
        ),

        const SizedBox(height: 12),

        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Sign in to unlock all features!'),
                backgroundColor: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Text(
            'Maybe later',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }
}