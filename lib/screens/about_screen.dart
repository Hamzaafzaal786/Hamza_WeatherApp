import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 22,
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // App Icon
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.isDarkMode
                            ? Colors.white.withOpacity(0.2)
                            : const Color(0xFF4A90E2).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: themeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white,
                    child: Icon(
                      Icons.cloud_queue,
                      size: 50,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : const Color(0xFF4A90E2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // App Name
                Text(
                  'SkyCast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  'Version 2.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Divider
                Divider(
                  color: themeProvider.isDarkMode ? Colors.white24 : Colors.grey.shade300,
                  thickness: 0.5,
                ),
                
                const SizedBox(height: 24),
                
                // Created by section
                Text(
                  'CREATED BY',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                    letterSpacing: 2,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Team Lead Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: themeProvider.isDarkMode
                          ? [const Color(0xFF2C3E50), const Color(0xFF1A252F)]
                          : [const Color(0xFF4A90E2), const Color(0xFF357ABD)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.isDarkMode
                            ? Colors.black.withOpacity(0.3)
                            : const Color(0xFF4A90E2).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Syed Hamza Afzaal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Team Lead + Developer',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Team Members Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: themeProvider.isDarkMode
                                ? [const Color(0xFF2C3E50), const Color(0xFF1A252F)]
                                : [const Color(0xFF667eea), const Color(0xFF4A90E2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: themeProvider.isDarkMode
                                  ? Colors.black.withOpacity(0.2)
                                  : const Color(0xFF4A90E2).withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Mustafa',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Developer',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: themeProvider.isDarkMode
                                ? [const Color(0xFF2C3E50), const Color(0xFF1A252F)]
                                : [const Color(0xFF667eea), const Color(0xFF4A90E2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: themeProvider.isDarkMode
                                  ? Colors.black.withOpacity(0.2)
                                  : const Color(0xFF4A90E2).withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Sufiyan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Tester',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Contact Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: themeProvider.isDarkMode
                          ? Colors.white24
                          : Colors.grey.shade200,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'CONTACT US',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Email
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkMode
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email,
                              color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'hamzaafzaal669@gmail.com',
                                style: TextStyle(
                                  color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      // WhatsApp
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkMode
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message,
                              color: const Color(0xFF25D366),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '+92 327 2738970',
                                style: TextStyle(
                                  color: themeProvider.isDarkMode ? Colors.white70 : Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Features Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: themeProvider.isDarkMode
                          ? Colors.white24
                          : Colors.grey.shade200,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '✨ App Features',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkMode ? Colors.white : Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFeatureChip(Icons.location_on, 'Current Location', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.search, 'Search City', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.calendar_today, 'Hourly Forecast', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.calendar_month, '5-Day Forecast', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.thermostat, '°C/°F Toggle', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.favorite, 'Favorites', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.psychology, 'Smart Tips', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.timer, 'Best Time', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.warning_amber, 'Severe Alerts', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.cloud_sync, 'Cloud Sync', themeProvider.isDarkMode),
                          _buildFeatureChip(Icons.security, 'Secure Auth', themeProvider.isDarkMode),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Footer
                Text(
                  '© 2024 SkyCast Weather App',
                  style: TextStyle(
                    fontSize: 10,
                    color: themeProvider.isDarkMode ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)]
              : [const Color(0xFF4A90E2).withOpacity(0.1), const Color(0xFF667eea).withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.2)
              : const Color(0xFF4A90E2).withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}