# Testing Guide

## Overview

This guide covers testing strategies for the TrustAstrology Flutter app, including unit tests, widget tests, provider tests, and integration tests.

## Test Structure

```
test/
├── components/              # Component widget tests
│   ├── app_button_test.dart
│   ├── app_text_field_test.dart
│   └── app_widgets_test.dart
├── models/                  # Model tests
│   ├── user_test.dart
│   ├── chat_message_test.dart
│   └── plan_test.dart
├── providers/               # Provider state tests
│   ├── auth_provider_test.dart
│   └── chat_provider_test.dart
├── repositories/            # Repository tests
│   ├── dummy_auth_repository_test.dart
│   └── dummy_chat_repository_test.dart
├── screens/                 # Screen widget tests
│   ├── auth/
│   │   ├── login_screen_test.dart
│   │   └── signup_screen_test.dart
│   └── home/
│       └── home_screen_test.dart
├── utils/                   # Utility tests
│   ├── validators_test.dart
│   └── result_test.dart
└── helpers/                 # Test helpers
    ├── test_helpers.dart
    └── mock_providers.dart

integration_test/
└── app_test.dart           # E2E integration tests
```

## Running Tests

### All Tests
```powershell
flutter test
```

### With Coverage
```powershell
flutter test --coverage
```

### Specific Test File
```powershell
flutter test test/providers/auth_provider_test.dart
```

### Integration Tests
```powershell
flutter test integration_test/app_test.dart
```

### Watch Mode (runs on file change)
```powershell
flutter test --watch
```

## Unit Tests

### Testing Models

```dart
// test/models/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/models/user.dart';

void main() {
  group('User', () {
    test('creates user from JSON correctly', () {
      final json = {
        'id': '1',
        'email': 'test@example.com',
        'name': 'Test User',
      };

      final user = User.fromJson(json);

      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
    });

    test('converts user to JSON correctly', () {
      final user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final json = user.toJson();

      expect(json['id'], '1');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
    });

    test('displayName returns name when available', () {
      final user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      expect(user.displayName, 'Test User');
    });

    test('displayName returns email prefix when name is empty', () {
      final user = User(
        id: '1',
        email: 'test@example.com',
        name: '',
      );

      expect(user.displayName, 'test');
    });

    test('copyWith creates new user with updated fields', () {
      final user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final updated = user.copyWith(name: 'Updated Name');

      expect(updated.id, '1');
      expect(updated.email, 'test@example.com');
      expect(updated.name, 'Updated Name');
    });
  });
}
```

### Testing Validators

```dart
// test/utils/validators_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/utils/validators.dart';

void main() {
  group('Validators', () {
    group('Email', () {
      test('returns true for valid email', () {
        expect(Validators.isValidEmail('test@example.com'), true);
        expect(Validators.isValidEmail('user.name@domain.co.uk'), true);
      });

      test('returns false for invalid email', () {
        expect(Validators.isValidEmail('invalid'), false);
        expect(Validators.isValidEmail('test@'), false);
        expect(Validators.isValidEmail('@example.com'), false);
        expect(Validators.isValidEmail(''), false);
      });
    });

    group('Password', () {
      test('returns true for valid password', () {
        expect(Validators.isValidPassword('Password123!'), true);
      });

      test('returns false for password without uppercase', () {
        expect(Validators.isValidPassword('password123!'), false);
      });

      test('returns false for password without lowercase', () {
        expect(Validators.isValidPassword('PASSWORD123!'), false);
      });

      test('returns false for password without number', () {
        expect(Validators.isValidPassword('Password!'), false);
      });

      test('returns false for short password', () {
        expect(Validators.isValidPassword('Pass1!'), false);
      });
    });

    group('Required', () {
      test('returns true for non-empty string', () {
        expect(Validators.isRequired('value'), true);
      });

      test('returns false for empty string', () {
        expect(Validators.isRequired(''), false);
      });

      test('returns false for whitespace only', () {
        expect(Validators.isRequired('   '), false);
      });
    });
  });
}
```

### Testing Repositories

```dart
// test/repositories/dummy_auth_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/repositories/dummy_auth_repository.dart';
import 'package:astrology_app/utils/result.dart';

void main() {
  late DummyAuthRepository repository;

  setUp(() {
    repository = DummyAuthRepository();
  });

  group('DummyAuthRepository', () {
    test('signIn succeeds with valid credentials', () async {
      final result = await repository.signIn(
        'test@example.com',
        'password123',
      );

      expect(result, isA<Success>());
      result.when(
        success: (user) {
          expect(user.email, 'test@example.com');
        },
        failure: (_) => fail('Should not fail'),
      );
    });

    test('signIn fails with invalid email', () async {
      final result = await repository.signIn(
        'invalid-email',
        'password123',
      );

      expect(result, isA<Failure>());
      result.when(
        success: (_) => fail('Should not succeed'),
        failure: (failure) {
          expect(failure.message, contains('Invalid email'));
        },
      );
    });

    test('signUp creates new user', () async {
      final result = await repository.signUp(
        'new@example.com',
        'Password123!',
        'New User',
      );

      expect(result, isA<Success>());
      result.when(
        success: (user) {
          expect(user.email, 'new@example.com');
          expect(user.name, 'New User');
        },
        failure: (_) => fail('Should not fail'),
      );
    });

    test('getCurrentUser returns signed in user', () async {
      // First sign in
      await repository.signIn('test@example.com', 'password123');

      // Then get current user
      final result = await repository.getCurrentUser();

      expect(result, isA<Success>());
      result.when(
        success: (user) {
          expect(user, isNotNull);
          expect(user!.email, 'test@example.com');
        },
        failure: (_) => fail('Should not fail'),
      );
    });

    test('signOut clears current user', () async {
      // Sign in
      await repository.signIn('test@example.com', 'password123');

      // Sign out
      await repository.signOut();

      // Verify user is cleared
      final result = await repository.getCurrentUser();
      result.when(
        success: (user) => expect(user, isNull),
        failure: (_) => fail('Should not fail'),
      );
    });
  });
}
```

## Provider Tests

### Testing StateNotifier

```dart
// test/providers/auth_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:astrology_app/providers/auth_provider.dart';
import 'package:astrology_app/repositories/auth_repository.dart';
import 'package:astrology_app/models/user.dart';
import 'package:astrology_app/utils/result.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('AuthNotifier', () {
    test('initial state is loading', () {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Result.success(null));

      final state = container.read(authProvider);
      expect(state, isA<AsyncLoading>());
    });

    test('signIn updates state to user on success', () async {
      final testUser = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      when(() => mockRepository.signIn(any(), any()))
          .thenAnswer((_) async => Result.success(testUser));
      
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Result.success(null));

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      // Wait for initial load
      await container.read(authProvider.future);

      // Perform sign in
      await container.read(authProvider.notifier).signIn(
        'test@example.com',
        'password123',
      );

      final state = container.read(authProvider);
      expect(state.hasValue, true);
      expect(state.value, testUser);
    });

    test('signIn updates state to error on failure', () async {
      when(() => mockRepository.signIn(any(), any())).thenAnswer(
        (_) async => Result.failure(
          const AuthFailure(message: 'Invalid credentials'),
        ),
      );
      
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Result.success(null));

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      await container.read(authProvider.future);

      await container.read(authProvider.notifier).signIn(
        'test@example.com',
        'wrong-password',
      );

      final state = container.read(authProvider);
      expect(state.hasError, true);
    });

    test('signOut clears user state', () async {
      final testUser = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Result.success(testUser));
      
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => Result.success(null));

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      await container.read(authProvider.future);

      await container.read(authProvider.notifier).signOut();

      final state = container.read(authProvider);
      expect(state.value, isNull);
    });
  });

  group('Derived Providers', () {
    test('isAuthenticatedProvider returns true when user exists', () {
      final testUser = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(
            (ref) => AuthNotifier(mockRepository)..state = AsyncValue.data(testUser),
          ),
        ],
      );

      expect(container.read(isAuthenticatedProvider), true);
    });

    test('currentUserProvider returns user when authenticated', () {
      final testUser = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(
            (ref) => AuthNotifier(mockRepository)..state = AsyncValue.data(testUser),
          ),
        ],
      );

      expect(container.read(currentUserProvider), testUser);
    });
  });
}
```

## Widget Tests

### Testing Screens

```dart
// test/screens/auth/login_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/screens/auth/login_screen.dart';
import 'package:astrology_app/components/app_button.dart';
import 'package:astrology_app/components/app_text_field.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders all required elements', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Don\'t have an account?'), findsOneWidget);
    });

    testWidgets('email field accepts input', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      final emailField = find.byType(AppTextField).first;
      await tester.enterText(emailField, 'test@example.com');

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('password field obscures text', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      final passwordFields = find.byType(AppTextField);
      final passwordField = passwordFields.last;

      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      final textField = tester.widget<TextField>(
        find.descendant(
          of: passwordField,
          matching: find.byType(TextField),
        ),
      );

      expect(textField.obscureText, true);
    });

    testWidgets('shows validation error for invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      final emailField = find.byType(AppTextField).first;
      await tester.enterText(emailField, 'invalid-email');

      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('navigates to signup on link tap', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      final signUpLink = find.text('Sign up');
      await tester.tap(signUpLink);
      await tester.pumpAndSettle();

      // Verify navigation (in real app, check for SignupScreen)
      // This is a simplified test
    });
  });
}
```

### Testing Components

```dart
// test/components/app_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/components/app_button.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('AppButton', () {
    testWidgets('renders text correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          AppButton(
            text: 'Test Button',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          AppButton(
            text: 'Test Button',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      expect(wasPressed, true);
    });

    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          AppButton(
            text: 'Test Button',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const AppButton(
            text: 'Test Button',
            onPressed: null,
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.enabled, false);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          AppButton(
            text: 'Test Button',
            onPressed: () {},
            icon: Icons.add,
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
```

## Integration Tests

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:astrology_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('complete authentication flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we start at login screen
      expect(find.text('Welcome Back'), findsOneWidget);

      // Navigate to signup
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      // Fill signup form
      await tester.enterText(
        find.byType(TextField).at(0),
        'Test User',
      );
      await tester.enterText(
        find.byType(TextField).at(1),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextField).at(2),
        'Password123!',
      );
      await tester.enterText(
        find.byType(TextField).at(3),
        'Password123!',
      );

      // Tap sign up button
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're now on home screen
      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('chat flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(
        find.byType(TextField).at(0),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextField).at(1),
        'password123',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to chat
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();

      // Send a message
      await tester.enterText(
        find.byType(TextField),
        'Hello, astrologer!',
      );
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify message appears
      expect(find.text('Hello, astrologer!'), findsOneWidget);
    });
  });
}
```

## Test Helpers

```dart
// test/helpers/test_helpers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:astrology_app/repositories/auth_repository.dart';
import 'package:astrology_app/repositories/chat_repository.dart';
import 'package:astrology_app/models/user.dart';
import 'package:astrology_app/models/chat_message.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}
class MockChatRepository extends Mock implements ChatRepository {}

// Test data
final testUser = User(
  id: '1',
  email: 'test@example.com',
  name: 'Test User',
);

final testMessages = [
  ChatMessage(
    id: '1',
    content: 'Hello',
    timestamp: DateTime.now(),
    isFromUser: true,
  ),
  ChatMessage(
    id: '2',
    content: 'Hi there!',
    timestamp: DateTime.now(),
    isFromUser: false,
  ),
];

// Provider overrides helper
ProviderContainer createContainer({
  AuthRepository? authRepository,
  ChatRepository? chatRepository,
}) {
  return ProviderContainer(
    overrides: [
      if (authRepository != null)
        authRepositoryProvider.overrideWithValue(authRepository),
      if (chatRepository != null)
        chatRepositoryProvider.overrideWithValue(chatRepository),
    ],
  );
}
```

## Best Practices

### 1. Arrange-Act-Assert Pattern
```dart
test('description', () {
  // Arrange: Set up test data and mocks
  final repository = MockAuthRepository();
  when(() => repository.signIn(any(), any()))
      .thenAnswer((_) async => Result.success(testUser));

  // Act: Perform the action
  final result = await repository.signIn('test@test.com', 'password');

  // Assert: Verify the outcome
  expect(result, isA<Success>());
});
```

### 2. Use Descriptive Test Names
```dart
// ✅ Good
test('signIn returns Success when credentials are valid', () {});

// ❌ Bad
test('test1', () {});
```

### 3. Test One Thing at a Time
```dart
// ✅ Good
test('email validator returns true for valid email', () {});
test('email validator returns false for invalid email', () {});

// ❌ Bad
test('email validator works', () {
  // Tests multiple scenarios
});
```

### 4. Use setUp and tearDown
```dart
void main() {
  late MockRepository repository;

  setUp(() {
    repository = MockRepository();
  });

  tearDown(() {
    // Clean up if needed
  });

  test('...', () {});
}
```

### 5. Mock External Dependencies
```dart
// Always mock repositories, APIs, databases
class MockAuthRepository extends Mock implements AuthRepository {}

when(() => mockRepo.signIn(any(), any()))
    .thenAnswer((_) async => Result.success(testUser));
```

## Coverage Goals

- **Overall**: > 80%
- **Models**: > 95%
- **Repositories**: > 90%
- **Providers**: > 85%
- **Utils**: > 95%
- **Screens**: > 70%

## Continuous Integration

Tests run automatically on every push via GitHub Actions. See `.github/workflows/flutter.yml` for configuration.

---

Happy Testing! 🧪
