import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/theme_provider.dart';
import '../services/firestore_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.isDarkMode
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
        child: StreamBuilder<List<String>>(
          stream: _firestoreService.getFavoriteCitiesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: themeProvider.isDarkMode ? Colors.white54 : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Error loading favorites: ${snapshot.error}',
                      style: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white54 : Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            
            final favorites = snapshot.data ?? [];
            
            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: themeProvider.isDarkMode ? Colors.white54 : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No favorite cities yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: themeProvider.isDarkMode ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Save cities from the menu to see them here',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeProvider.isDarkMode ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final city = favorites[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_city,
                      color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
                    ),
                    title: Text(
                      city,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<WeatherProvider>().fetchWeather(city);
                          },
                          tooltip: 'View Weather',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () async {
                            await _firestoreService.removeFavoriteCity(city);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$city removed from favorites')),
                              );
                            }
                          },
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}