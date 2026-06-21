# SkyCast Weather App 🌤️

[![Flutter](https://img.shields.io/badge/Flutter-3.16+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.2+-blue.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-10.0+-orange.svg)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **"Your Personal Weather Intelligence Assistant - Where Weather Meets Intelligence"**

---

## 📱 Overview

**SkyCast** is a comprehensive cross-platform weather application that goes beyond basic temperature display. It combines real-time weather data with **intelligent recommendations**, **cloud synchronization**, and a **beautiful user experience** to help you plan your day better.

### ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🌡️ **Real-time Weather** | Current temperature, feels like, humidity, wind speed |
| 📅 **Hourly Forecast** | 24-48 hours detailed weather predictions |
| 📆 **5-Day Forecast** | Plan your week ahead |
| 📍 **Location Intelligence** | Automatic GPS-based weather detection |
| 🔍 **City Search** | Weather for any city worldwide |
| ⭐ **Favorite Cities** | Save and organize your preferred locations |
| 🌡️ **°C / °F Toggle** | Switch temperature units instantly |
| 🎨 **Dark/Light Theme** | Customizable UI themes |
| 🔐 **User Authentication** | Email/Password + Google Sign-In |
| ☁️ **Cloud Sync** | Preferences synced across devices |
| 🧠 **Smart Recommendations** | Weather-based activity suggestions |
| ⏰ **Time-Based Tips** | What to bring based on time of day |
| ⚠️ **Severe Alerts** | Warnings for extreme conditions |
| 👥 **Team Info** | About us with developer credits |

---

## 🏗️ Architecture

### Technology Stack

```
┌─────────────────────────────────────────────────────────────┐
│                    SKYCAST WEATHER APP                       │
├─────────────────────────────────────────────────────────────┤
│  Frontend    │ Flutter 3.x (Dart)                          │
│  State       │ Provider Pattern                            │
│  Backend     │ Firebase (Authentication, Firestore)        │
│  Weather APIs│ OpenWeatherMap (5-day) + WeatherAPI (Hourly)│
│  Location    │ Geolocator + Geocoding                      │
│  Storage     │ SharedPreferences, Hive                     │
│  Design      │ Material Design 3 + Custom Gradients       │
└─────────────────────────────────────────────────────────────┘
```

### System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE (Screens)                            │
├───────────────┬───────────────┬───────────────┬───────────────────────────┤
│  Welcome      │  Login/       │  Home         │  About                     │
│  Screen       │  Signup       │  Screen       │  Screen                    │
├───────────────┴───────────────┴───────────────┴───────────────────────────┤
│                  STATE MANAGEMENT (Providers)                              │
├───────────────┬───────────────┬───────────────┬───────────────────────────┤
│  AuthProvider │ WeatherProvider│ ThemeProvider │  FirestoreService         │
├───────────────┴───────────────┴───────────────┴───────────────────────────┤
│                       SERVICES LAYER                                       │
├───────────────┬───────────────┬───────────────┬───────────────────────────┤
│  ApiService   │ WeatherApi    │ Location      │ Preferences               │
│  (OpenWeather)│ (WeatherAPI)  │ Service       │ Service                   │
├───────────────┴───────────────┴───────────────┴───────────────────────────┤
│                      EXTERNAL APIs                                         │
├───────────────┬───────────────┬───────────────┬───────────────────────────┤
│ OpenWeatherMap│ WeatherAPI.com│ Firebase Auth │  Google Sign-In           │
└───────────────┴───────────────┴───────────────┴───────────────────────────┘
```

---

## 📁 Project Structure

```
lib/
├── main.dart                    # Application entry point
├── firebase_options.dart        # Firebase configuration
│
├── models/                      # Data models
│   └── weather_model.dart       # Weather data structures
│
├── providers/                   # State management
│   ├── auth_provider.dart       # Authentication state
│   ├── weather_provider.dart    # Weather data state
│   └── theme_provider.dart      # Theme management
│
├── screens/                     # UI screens
│   ├── welcome_screen.dart      # Landing page (before login)
│   ├── login_screen.dart        # Login screen
│   ├── signup_screen.dart       # Registration screen
│   ├── home_screen.dart         # Main weather display
│   ├── search_screen.dart       # City search
│   ├── favorites_screen.dart    # Favorite cities
│   ├── about_screen.dart        # App information
│   ├── forgot_password_screen.dart # Password reset
│   └── recommendations_screen.dart # Smart suggestions
│
├── services/                    # Business logic
│   ├── api_service.dart         # OpenWeatherMap API
│   ├── weather_api_service.dart # WeatherAPI.com
│   ├── auth_service.dart        # Firebase Auth
│   ├── firestore_service.dart   # Cloud Firestore
│   ├── location_service.dart    # GPS services
│   └── preferences_service.dart # Local storage
│
├── widgets/                     # Reusable components
│   └── hourly_forecast_widget.dart # Hourly forecast UI
│
└── utils/                       # Utilities
    └── theme_provider.dart      # Theme configuration
```

---

## 🔧 Installation

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.16+)
- [Dart SDK](https://dart.dev/get-dart) (3.2+)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- [Firebase Account](https://firebase.google.com/) (for backend services)

### Setup Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/skycast-weatherapp.git
cd skycast-weatherapp
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Configure Firebase

**Android:**
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android app with package name `com.example.hamza_weatherapp`
3. Download `google-services.json` and place in `android/app/`
4. Enable Authentication (Email/Password + Google Sign-In)

**iOS:**
1. Add iOS app to Firebase
2. Download `GoogleService-Info.plist` and place in `ios/Runner/`
3. Update `ios/Podfile` if needed

**Web:**
1. Add Web app to Firebase
2. Copy Web SDK configuration to `web/index.html`

#### 4. API Keys Configuration

Update API keys in:

- `lib/services/api_service.dart` (OpenWeatherMap key)
- `lib/services/weather_api_service.dart` (WeatherAPI.com key)

```dart
// lib/services/api_service.dart
class ApiService {
  static const String apiKey = 'YOUR_OPENWEATHER_API_KEY';
}

// lib/services/weather_api_service.dart
class WeatherApiService {
  static const String apiKey = 'YOUR_WEATHERAPI_KEY';
}
```

#### 5. Run the App

```bash
flutter run
```

#### 6. Build for Production

```bash
flutter build apk  # Android
flutter build ios  # iOS
flutter build web  # Web
```

---

## 🚀 Features Breakdown

### 🔐 Authentication

| Feature | Status | Description |
|---------|--------|-------------|
| Email/Password Sign Up | ✅ | Create account with email and password |
| Email/Password Login | ✅ | Login with existing credentials |
| Google Sign-In | ✅ | One-click Google authentication |
| Password Reset | ✅ | Reset password via email |
| Auto-Login | ✅ | Stay logged in between sessions |

### 🌤️ Weather Features

| Feature | Status | Description |
|---------|--------|-------------|
| Current Weather | ✅ | Temperature, condition, feels like, humidity, wind |
| Location Detection | ✅ | Auto-detect city via GPS |
| City Search | ✅ | Search any city worldwide |
| Hourly Forecast | ✅ | 24-48 hours detailed predictions |
| 5-Day Forecast | ✅ | Weekly weather planning |
| Weather Icons | ✅ | Dynamic icons based on conditions |
| Unit Toggle | ✅ | °C/°F conversion |

### 🧠 Smart Features

| Feature | Status | Description |
|---------|--------|-------------|
| Weather Recommendations | ✅ | AI-powered suggestions |
| Time-Based Tips | ✅ | Morning/afternoon/night specific advice |
| Packing Suggestions | ✅ | What to bring based on weather |
| Severe Weather Alerts | ✅ | Critical warnings for extreme conditions |
| Best Time to Go Out | ✅ | Optimal outdoor activity timing |

### 💾 Data Management

| Feature | Status | Description |
|---------|--------|-------------|
| Favorite Cities | ✅ | Save and manage locations |
| Cloud Sync | ✅ | Preferences synced across devices |
| Local Storage | ✅ | Cached preferences and last city |
| Persistent State | ✅ | Theme and unit preferences saved |

---

## 📱 Screenshots

### Welcome Screen (Before Login)
```
┌─────────────────────────────────────┐
│              ☁️ SKYCAST             │
│         Your Personal Weather App   │
│                                     │
│    ┌─────────────────────────┐      │
│    │   📍 Karachi             │      │
│    │        ☀️                │      │
│    │       29.0°C            │      │
│    │     OVERCAST             │      │
│    │  Feels:35°C | 75% | 5m/s│    │
│    └─────────────────────────┘      │
│   ✨ FEATURES YOU'LL GET (10+)       │
│   [SIGN IN] [CREATE ACCOUNT]        │
│   [Continue as Guest]               │
└─────────────────────────────────────┘
```

### Home Screen (After Login)
```
┌─────────────────────────────────────┐
│ 📍 Karachi          🔍 🧠 ☰        │
│ Today's Weather                     │
│    ┌─────────────────────────┐      │
│    │         ☀️              │      │
│    │       29.0°C            │      │
│    │       OVERCAST           │      │
│    └─────────────────────────┘      │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │Feels   │ │Humidity│ │ Wind   │  │
│  │ 35.1°C │ │  75%   │ │5.3 m/s │  │
│  └────────┘ └────────┘ └────────┘  │
│  ┌─────────────────────────────┐    │
│  │     HOURLY FORECAST          │    │
│  │ 00:00 01:00 02:00 03:00     │    │
│  │  27°   27°   27°   27°       │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │      5-DAY FORECAST          │    │
│  │ Mon ☀️ 32°/25°              │    │
│  │ Tue 🌧️ 30°/24°              │    │
│  │ Wed ☁️ 31°/26°               │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

### Bottom Menu
```
┌─────────────────────────────────────┐
│                   ⚫                │
│              user@example.com       │
├─────────────────────────────────────┤
│  🌡️ Temperature Unit    °C   🔘   │
├─────────────────────────────────────┤
│  🌙 Dark Mode                🔘    │
├─────────────────────────────────────┤
│  ❤️ My Favorites                  > │
├─────────────────────────────────────┤
│  🧠 Weather Recommendations        > │
│      Smart tips for your day       │
├─────────────────────────────────────┤
│  💾 Save Current City              > │
├─────────────────────────────────────┤
│  📍 Current: Karachi               > │
├─────────────────────────────────────┤
│  ℹ️ About Us                       > │
├─────────────────────────────────────┤
│  🚪 Logout                         > │
└─────────────────────────────────────┘
```

---

## 🛠️ Development

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # Firebase
  firebase_core: ^3.15.2
  firebase_auth: ^5.7.0
  cloud_firestore: ^5.6.12
  google_sign_in: ^6.3.0

  # Weather APIs
  http: ^1.6.0

  # Location
  geolocator: ^13.0.4
  geocoding: ^3.0.0

  # Storage
  shared_preferences: ^2.5.5
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # UI
  google_fonts: ^6.3.3
  flutter_staggered_animations: ^1.1.1
  cupertino_icons: ^1.0.9

  # Utilities
  intl: ^0.19.0
  connectivity_plus: ^6.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.13
  hive_generator: ^2.0.1
```

---

## 🤝 Team

| Member | Role | Contributions |
|--------|------|---------------|
| **Syed Hamza Afzaal** | Team Lead + Developer | Project architecture, API integration, WeatherProvider, HomeScreen, Documentation |
| **Mustafa** | Developer | Authentication system, Firestore integration, Favorites feature, Testing |
| **Sufiyan** | Tester | UI/UX testing, Bug reporting, Quality assurance, Documentation review |

---

## 📝 Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| **API Rate Limiting** | Hybrid approach using two different APIs (OpenWeatherMap + WeatherAPI) |
| **Real-time Location** | Geolocator package with high accuracy mode and fallback to city search |
| **State Management** | Provider pattern with multiple providers for separate concerns |
| **UI Overflow** | Responsive design with flexible layouts and adaptive font sizes |
| **Google Sign-In** | Proper OAuth consent screen configuration and SHA-1 fingerprints |
| **Hourly Data** | Switched to WeatherAPI.com for detailed hourly forecasts |
| **Location Permissions** | Proper handling for Android (AndroidManifest.xml) and iOS (Info.plist) |
| **Theme Consistency** | Custom ThemeProvider with separate light/dark theme definitions |
| **Image Loading** | Added errorBuilder for network images with fallback icons |
| **Back Button** | Implemented WillPopScope with exit confirmation dialog |

---

## 🔮 Future Enhancements

- [ ] Weather Maps (radar view)
- [ ] Air Quality Index (AQI)
- [ ] UV Index display
- [ ] Push Notifications for severe weather
- [ ] Wear OS / Watch support
- [ ] Voice search
- [ ] Offline mode with cached data
- [ ] Widgets for home screen
- [ ] Multi-language support
- [ ] Time Machine (historical weather)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - UI Framework
- [Firebase](https://firebase.google.com) - Backend Services
- [OpenWeatherMap](https://openweathermap.org) - 5-Day Forecast API
- [WeatherAPI.com](https://weatherapi.com) - Hourly Forecast API
- [Google Fonts](https://fonts.google.com) - Typography

---

## 📞 Contact

| Method | Details |
|--------|---------|
| **Email** | hamzaafzaal669@gmail.com |
| **WhatsApp** | +92 327 2738970 |
| **GitHub** | [github.com/Hamzaafzaal786](https://github.com/Hamzaafzaal786) |

---

<div align="center">
  
**⭐ If you found this project helpful, please give it a star! ⭐**

</div>
