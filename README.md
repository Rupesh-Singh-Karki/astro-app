# TrustAstrology

A Flutter astrology app with authentication, real-time AI chat, user profiles, and subscription plans. Built with Riverpod and Material 3.

## Features

- 🔐 Email/OTP authentication
- 💬 AI astrologer chat
- 👤 User profile management
- 📋 Subscription plans
- 🎨 Material 3 design with purple theme

## Getting Started

### Prerequisites

- Flutter 3.8+
- Dart 3.8+

### Installation

```bash
# Clone repository
git clone https://github.com/Rupesh-Singh-Karki/astro-app.git
cd astrology-app

# Install dependencies
flutter pub get

# Run app
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## Configuration

Update backend URL in `lib/config/app_config.dart`:

```dart
static const String productionApiUrl = 'https://your-backend-url.com';
```

## Project Structure

```
lib/
├── config/          # App configuration
├── models/          # Data models
├── providers/       # Riverpod state management
├── screens/         # UI screens
├── services/        # API services
├── theme/           # App theme
└── utils/           # Utilities
```

## Testing

```bash
flutter test
```

## Tech Stack

- Flutter & Dart
- Riverpod (State Management)
- Material 3 (Design System)
- Shared Preferences (Local Storage)

---

Built with Flutter 💙
