import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final String condition;
  final Widget child;
  final bool isWelcomeScreen;

  const GradientBackground({
    required this.condition,
    required this.child,
    this.isWelcomeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isWelcomeScreen ? _getWelcomeGradient() : _getWeatherGradient(),
      ),
      child: child,
    );
  }

  LinearGradient _getWelcomeGradient() {
    // Darker gradient for welcome screen - deep purple gradient
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1A0A2E), // Deep dark purple
        Color(0xFF2A0A3A), // Very dark purple
        Color(0xFF3D0A5C), // Dark purple
        Color(0xFF5A0A7C), // Mid purple
        Color(0xFF2A0A3A), // Back to dark
      ],
      stops: [0.0, 0.2, 0.5, 0.8, 1.0],
    );
  }

  LinearGradient _getWeatherGradient() {
    // Sunny / Clear
    if (condition.contains('clear') || condition.contains('sun')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.orange.shade900,
          Colors.orange.shade800,
          Colors.amber.shade800,
        ],
      );
    }
    // Cloudy
    else if (condition.contains('cloud')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey.shade900,
          Colors.grey.shade800,
          Colors.grey.shade700,
        ],
      );
    }
    // Rain
    else if (condition.contains('rain') || condition.contains('drizzle')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0A1A3A), // Very dark blue
          Color(0xFF0F2A5A), // Dark blue
          Color(0xFF1A3A7A), // Mid blue
        ],
      );
    }
    // Snow
    else if (condition.contains('snow')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2A3A5A), // Dark blue-gray
          Color(0xFF3A4A6A), // Lighter blue-gray
          Color(0xFF5A6A8A), // Even lighter
        ],
      );
    }
    // Thunderstorm
    else if (condition.contains('thunder')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0A0A1A), // Almost black
          Color(0xFF1A1A3A), // Very dark purple
          Color(0xFF2A2A5A), // Dark purple-blue
        ],
      );
    }
    // Default / Night
    else {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0A0A2A), // Very dark
          Color(0xFF1A1A4A), // Dark indigo
          Color(0xFF2A2A6A), // Mid indigo
        ],
      );
    }
  }
}