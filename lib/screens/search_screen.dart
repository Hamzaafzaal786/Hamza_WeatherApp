import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String city) {
    if (city.trim().isNotEmpty) {
      // Return the city name to the previous screen
      Navigator.pop(context, city.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search City',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.grey.shade800,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white : Colors.grey.shade700,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_city,
                size: 80,
                color: isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
              ),
              const SizedBox(height: 24),
              Text(
                'Enter City Name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Search for weather in any city worldwide',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey.shade800,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., London, Tokyo, New York',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
                  ),
                  filled: true,
                  fillColor: isDarkMode
                      ? Colors.white.withOpacity(0.15)
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                      width: 1.5,
                    ),
                  ),
                ),
                onSubmitted: (value) => _search(value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _search(_controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                  foregroundColor: isDarkMode ? const Color(0xFF667eea) : Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'SEARCH',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}