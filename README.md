# TrustAstrology - Production-Grade Flutter Application

[![Flutter](https://img.shields.io/badge/Flutter-3.8+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8+-blue.svg)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.5-purple.svg)](https://riverpod.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A production-grade, scalable Flutter application for astrology services built with **Clean Architecture**, **Riverpod state management**, and **Material 3 design**. This app follows industry best practices with comprehensive error handling, validation, logging, and testing infrastructure.

## 🌟 Features

### Core Functionality
- ✅ **Complete Authentication Flow**: Email/password login, signup, session management
- ✅ **Real-time Chat Interface**: Intelligent chat with astrologer featuring smart replies
- ✅ **User Dashboard**: Personalized home screen with quick actions
- ✅ **Settings Management**: Profile display and account management
- ✅ **Subscription Plans**: In-app plan viewing (ready for purchase integration)

### Technical Excellence
- 🏗️ **Clean Architecture**: Modular, testable, maintainable code structure with clear separation of concerns
- 🔄 **Riverpod State Management**: Type-safe, compile-time safe state management with AsyncValue
- 🎨 **Material 3 Design**: Custom purple theme system with light/dark mode support
- ⚡ **Performance Optimized**: Const constructors, efficient list rendering, lazy loading
- 🛡️ **Type-Safe Error Handling**: Result pattern for explicit success/failure handling
- ✅ **Comprehensive Validation**: Reusable validators for email, password, forms
- 📊 **Structured Logging**: Professional logging system with request/response tracking
- 📱 **Responsive Design**: Adaptive layouts for mobile, tablet, and desktop
- 🧪 **Testing Ready**: Complete testing infrastructure with unit, widget, and integration tests

## 📁 Project Structure

```
lib/
├── main.dart                      # Application entry point with ProviderScope
│
├── components/                    # Reusable UI components
│   ├── app_button.dart           # Custom button with variants (filled, outlined, text, elevated)
│   ├── app_text_field.dart       # Form input with validation support
│   └── app_widgets.dart          # Loading, error, empty state widgets
│
├── constants/                     # Application-wide constants
│   └── app_constants.dart        # API config, storage keys, validation rules, error messages
│
├── models/                        # Domain entities
│   ├── user.dart                 # User and UserSubscription models
│   ├── chat_message.dart         # ChatMessage with sender types
│   └── plan.dart                 # Subscription Plan and Discount models
│
├── providers/                     # Riverpod state management
│   ├── auth_provider.dart        # AuthNotifier, auth state, current user provider
│   └── chat_provider.dart        # ChatNotifier, chat messages, unread count
│
├── repositories/                  # Data layer abstraction (Repository pattern)
│   ├── auth_repository.dart      # Abstract auth repository interface
│   ├── dummy_auth_repository.dart # Mock implementation with in-memory storage
│   ├── chat_repository.dart      # Abstract chat repository interface
│   └── dummy_chat_repository.dart # Mock implementation with smart replies
│
├── screens/                       # UI layer
│   ├── auth/
│   │   ├── login_screen.dart     # Login with email/password validation
│   │   └── signup_screen.dart    # Registration with password confirmation
│   ├── chat/
│   │   └── chat_screen.dart      # Chat interface with message bubbles
│   ├── home/
│   │   ├── home_screen.dart      # Dashboard with welcome card and quick actions
│   │   └── main_scaffold_screen.dart # Bottom navigation shell
│   └── settings/
│       └── settings_screen.dart  # Profile display and logout
│
├── theme/                         # Material 3 theme system
│   ├── app_colors.dart           # Purple-based color palette with gradients
│   ├── app_spacing.dart          # 8dp grid system, sizes, breakpoints, durations
│   ├── app_typography.dart       # Material 3 text styles (Poppins/Inter fonts)
│   └── app_theme.dart            # Complete light/dark theme configuration
│
└── utils/                         # Utility classes and helpers
    ├── result.dart               # Result<T> type and AppFailure hierarchy
    ├── logger.dart               # AppLogger with structured logging methods
    └── validators.dart           # Form validation utilities
```

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

### Layers

1. **Presentation Layer** (`screens/`, `components/`) - UI components, no business logic
2. **State Management Layer** (`providers/`) - Riverpod providers, state transformation
3. **Domain Layer** (`models/`, `utils/`) - Business entities, rules, and utilities
4. **Data Layer** (`repositories/`) - Data source abstraction, API/DB interactions

### Design Patterns

- **Repository Pattern**: Abstracts data sources for easy testing and swapping
- **Result Pattern**: Type-safe error handling without exceptions
- **Provider Pattern**: Reactive state management with Riverpod
- **Factory Pattern**: Model creation from JSON
- **Singleton Pattern**: Logger and constants

📖 **[Read Full Architecture Documentation](ARCHITECTURE.md)**

## 🎨 Theme System

Material 3 theme with comprehensive styling:

- **Primary Color**: Soft Pastel Purple (#B794F6) with gentle gradient variants
- **Typography**: Poppins for headings, Inter for body text
- **Spacing**: Consistent 8dp grid system
- **Components**: Fully themed buttons, cards, inputs, navigation
- **Dark Mode**: Complete dark theme with proper contrasts
- **Responsive**: Breakpoints for mobile, tablet, desktop

## 🚀 Getting Started

### Prerequisites

- Flutter SDK **3.8.1** or higher
- Dart SDK **3.8.1** or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**:
```bash
git clone https://github.com/yourusername/astrology-app.git
cd astrology-app
```

2. **Install dependencies**:
```powershell
flutter pub get
```

3. **Run the app**:
```powershell
# Development mode
flutter run

# With specific device
flutter run -d chrome    # Web
flutter run -d emulator  # Android
```

### Build for Production

**Android:**
```powershell
flutter build apk --release          # APK
flutter build appbundle --release    # App Bundle (for Play Store)
```

**iOS:**
```powershell
flutter build ios --release
```

**Web:**
```powershell
flutter build web --release
```

**Windows:**
```powershell
flutter build windows --release
```

## 🧪 Testing

### Run All Tests
```powershell
flutter test
```

### Run with Coverage
```powershell
flutter test --coverage
```

### View Coverage Report
```powershell
# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html

# Open in browser
start coverage/html/index.html
```

## 📦 State Management with Riverpod

### Provider Types

**1. Provider** - Immutable/computed values
```dart
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).valueOrNull;
});
```

**2. StateNotifierProvider** - Mutable state
```dart
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
```

### Watching State in UI

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return authState.when(
      data: (user) => Text('Hello ${user?.name}'),
      loading: () => AppLoadingIndicator(),
      error: (error, _) => AppErrorWidget(message: error.toString()),
    );
  }
}
```

## 🔐 Authentication Flow

1. **Login/Signup** - Email/password with validation
2. **Session Management** - Token storage and auto-login
3. **Protected Routes** - Navigate based on auth state
4. **Logout** - Clear session and return to login

**Note**: Currently using dummy authentication. Any email/password combination will work for testing.

## 🎭 Error Handling

Type-safe error handling using the **Result Pattern**:

```dart
Future<Result<User>> signIn(String email, String password) async {
  try {
    final user = await _api.signIn(email, password);
    return Result.success(user);
  } catch (e) {
    return Result.failure(NetworkFailure(message: e.toString()));
  }
}

// Usage
final result = await repository.signIn(email, password);
result.when(
  success: (user) => print('Welcome ${user.name}'),
  failure: (failure) => print('Error: ${failure.message}'),
);
```

## 📝 Validation

Comprehensive validation utilities in `utils/validators.dart`:

```dart
Validators.isValidEmail('test@example.com')  // true
Validators.isValidPassword('Pass123!')       // true
Validators.isRequired('value')               // true
```

## 🔍 Logging

Structured logging with `AppLogger`:

```dart
AppLogger.info('User logged in', data: {'userId': user.id});
AppLogger.error('Login failed', error, stackTrace);
AppLogger.logRequest('POST', '/api/auth/login');
```

## 🌐 API Integration (Ready)

The app is ready for real API integration:

- **Dio** configured for HTTP requests
- **Retrofit** ready for type-safe API clients
- **Interceptors** for auth tokens and logging
- **Error handling** with proper retry logic

Switch from dummy to real API by updating the repository provider.

## 📱 Responsive Design

Breakpoints defined in `theme/app_spacing.dart`:

- **Mobile**: < 600px
- **Tablet**: 600px - 1024px  
- **Desktop**: > 1024px

## 🎯 Performance Optimization

- ✅ **Const constructors** - Prevent unnecessary rebuilds
- ✅ **ListView.builder** - Efficient list rendering  
- ✅ **Lazy loading** - Load data on-demand
- ✅ **Provider caching** - Memoize expensive operations

## 🔄 CI/CD with GitHub Actions

Automated workflows configured in `.github/workflows/flutter.yml`:

- ✅ **Code Analysis** - Flutter analyze, formatting checks
- ✅ **Testing** - Unit, widget, and integration tests
- ✅ **Build** - Android (APK/AAB), iOS, Web builds
- ✅ **Coverage** - Code coverage reports to Codecov
- ✅ **Deploy** - Auto-deploy web to GitHub Pages

## 📚 Documentation

### Available Documentation

- **README.md** (this file) - Getting started and overview
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Detailed architecture guide
- **API Docs** - Generate with `dart doc .`

### Generate API Documentation

```powershell
# Generate documentation
dart doc .

# Open documentation
start doc/api/index.html
```

## 🛠️ Development Tools

### Recommended VS Code Extensions

- **Flutter** - Flutter SDK support
- **Dart** - Dart language support
- **Riverpod Snippets** - Code snippets for Riverpod
- **Error Lens** - Inline error highlighting
- **GitLens** - Git supercharged

### Useful Commands

```powershell
# Format code
dart format .

# Analyze code
flutter analyze

# Check outdated packages
flutter pub outdated

# Clean build files
flutter clean

# Rebuild
flutter pub get ; flutter run
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Contribution Guidelines

- Follow the existing code style
- Write tests for new features
- Update documentation
- Ensure all tests pass

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

## 🙏 Acknowledgments

- **Flutter Team** - Amazing cross-platform framework
- **Riverpod** - Excellent state management solution
- **Material Design** - Beautiful design system
- **Open Source Community** - Countless helpful packages

## 📞 Support

For support:
- 📧 Email: support@trustastrology.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/astrology-app/issues)

## 🗺️ Roadmap

### Phase 1: Foundation ✅
- [x] Clean architecture setup
- [x] Riverpod state management
- [x] Material 3 theme
- [x] Authentication flow
- [x] Basic screens

### Phase 2: Features 🚧
- [ ] Real API integration
- [ ] Payment integration
- [ ] Push notifications
- [ ] Daily horoscope
- [ ] Chat history

### Phase 3: Enhancement 📋
- [ ] AI-powered insights
- [ ] Social sharing
- [ ] Multi-language support
- [ ] Accessibility improvements
- [ ] Advanced analytics

---

**Built with ❤️ using Flutter**

⭐ Star this repo if you find it helpful!
