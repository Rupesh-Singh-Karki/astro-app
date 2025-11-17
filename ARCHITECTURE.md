# Architecture Documentation

## Overview

TrustAstrology follows **Clean Architecture** principles with a clear separation of concerns across multiple layers. The architecture is designed to be:

- **Testable**: Each layer can be tested independently
- **Maintainable**: Clear boundaries make changes easier
- **Scalable**: Easy to add new features without breaking existing code
- **Independent**: Business logic is independent of UI and frameworks

## Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│    (screens/, components/)              │
│  • UI components and screens            │
│  • Riverpod consumers                   │
│  • Navigation logic                     │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│      State Management Layer             │
│         (providers/)                    │
│  • Riverpod providers and notifiers     │
│  • State transformation                 │
│  • UI-agnostic business logic           │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          Domain Layer                   │
│     (models/, utils/)                   │
│  • Business entities (User, Message)    │
│  • Business rules and validation        │
│  • Domain utilities (Result, Logger)    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          Data Layer                     │
│        (repositories/)                  │
│  • Repository abstractions              │
│  • API/Database interactions            │
│  • DTO to Model conversions             │
└─────────────────────────────────────────┘
```

## Layer Responsibilities

### 1. Presentation Layer (`screens/`, `components/`)

**Purpose**: Render UI and handle user interactions

**Responsibilities**:
- Display data from providers
- Handle user input
- Navigate between screens
- Show loading/error states
- NO business logic

**Example**:
```dart
class LoginScreen extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return authState.when(
      data: (user) => HomeScreen(),
      loading: () => AppLoadingIndicator(),
      error: (error, _) => AppErrorWidget(message: error.toString()),
    );
  }
}
```

**Rules**:
- ✅ Use `ConsumerWidget` or `ConsumerStatefulWidget`
- ✅ Watch providers for state
- ✅ Call provider methods for actions
- ❌ No direct repository access
- ❌ No business logic
- ❌ No API calls

### 2. State Management Layer (`providers/`)

**Purpose**: Manage application state and business logic

**Responsibilities**:
- Manage state using StateNotifier
- Transform repository data for UI
- Handle loading/error/data states
- Cache data when appropriate
- Coordinate between repositories
- Implement UI-agnostic business rules

**Example**:
```dart
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repository;
  
  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadCurrentUser();
  }
  
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await _repository.signIn(email, password);
    result.when(
      success: (user) {
        state = AsyncValue.data(user);
        AppLogger.info('User signed in: ${user.email}');
      },
      failure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        AppLogger.error('Sign in failed', failure);
      },
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
```

**Rules**:
- ✅ Use `StateNotifier` for complex state
- ✅ Use `Provider` for computed values
- ✅ Handle AsyncValue states (loading/error/data)
- ✅ Log important state changes
- ❌ No direct API calls
- ❌ No UI code

### 3. Domain Layer (`models/`, `utils/`)

**Purpose**: Define business entities and rules

**Responsibilities**:
- Define data models (User, ChatMessage, Plan)
- Business validation logic
- Domain-specific utilities
- Error types and result types
- Constants and enums

**Example - Models**:
```dart
class User {
  final String id;
  final String email;
  final String name;
  final UserSubscription? subscription;
  
  User({
    required this.id,
    required this.email,
    required this.name,
    this.subscription,
  });
  
  String get displayName => name.isNotEmpty ? name : email.split('@')[0];
  
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String? ?? '',
    subscription: json['subscription'] != null
        ? UserSubscription.fromJson(json['subscription'])
        : null,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    if (subscription != null) 'subscription': subscription!.toJson(),
  };
}
```

**Example - Result Type**:
```dart
sealed class Result<T> {
  const Result();
  
  factory Result.success(T value) = Success<T>;
  factory Result.failure(AppFailure failure) = Failure<T>;
  
  R when<R>({
    required R Function(T value) success,
    required R Function(AppFailure failure) failure,
  });
}
```

**Rules**:
- ✅ Pure data classes with minimal logic
- ✅ JSON serialization support
- ✅ Immutable by default
- ✅ CopyWith methods for updates
- ❌ No framework dependencies
- ❌ No repository/provider references

### 4. Data Layer (`repositories/`)

**Purpose**: Abstract data sources and provide data to the domain

**Responsibilities**:
- Define repository interfaces
- Implement data fetching/storage
- Handle API requests
- Transform DTOs to models
- Cache management
- Error handling at data source level

**Example - Abstract Repository**:
```dart
abstract class AuthRepository {
  Future<Result<User>> signIn(String email, String password);
  Future<Result<User>> signUp(String email, String password, String name);
  Future<Result<void>> signOut();
  Future<Result<User?>> getCurrentUser();
  Future<Result<User>> updateProfile(String userId, String name, String? avatarUrl);
}
```

**Example - Implementation**:
```dart
class ApiAuthRepository implements AuthRepository {
  final Dio _dio;
  
  ApiAuthRepository(this._dio);
  
  @override
  Future<Result<User>> signIn(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      final user = User.fromJson(response.data);
      return Result.success(user);
    } on DioException catch (e) {
      AppLogger.error('Sign in failed', e);
      return Result.failure(NetworkFailure(
        message: e.response?.data['message'] ?? 'Network error',
      ));
    } catch (e) {
      AppLogger.error('Unexpected error during sign in', e);
      return Result.failure(UnknownFailure(message: e.toString()));
    }
  }
}
```

**Rules**:
- ✅ Return `Result<T>` for operations that can fail
- ✅ Log all errors
- ✅ Transform exceptions to domain failures
- ✅ Use dependency injection
- ❌ No direct UI references
- ❌ No state management

## Design Patterns

### 1. Repository Pattern

**Purpose**: Abstract data sources and provide a clean API to the domain layer

**Benefits**:
- Easy to swap implementations (mock, API, local DB)
- Testable without real data sources
- Single responsibility
- Dependency inversion

**Implementation**:
```dart
// Abstract interface
abstract class ChatRepository {
  Future<Result<List<ChatMessage>>> getMessages(String userId);
  Future<Result<ChatMessage>> sendMessage(String userId, String content);
}

// Dummy implementation for development
class DummyChatRepository implements ChatRepository {
  final List<ChatMessage> _messages = [];
  
  @override
  Future<Result<List<ChatMessage>>> getMessages(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_messages);
  }
}

// Real API implementation for production
class ApiChatRepository implements ChatRepository {
  final Dio _dio;
  
  @override
  Future<Result<List<ChatMessage>>> getMessages(String userId) async {
    try {
      final response = await _dio.get('/chat/$userId/messages');
      final messages = (response.data as List)
          .map((json) => ChatMessage.fromJson(json))
          .toList();
      return Result.success(messages);
    } catch (e) {
      return Result.failure(NetworkFailure(message: e.toString()));
    }
  }
}

// Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  // Switch between implementations based on environment
  if (AppConstants.isDevelopment) {
    return DummyChatRepository();
  } else {
    return ApiChatRepository(ref.watch(dioProvider));
  }
});
```

### 2. Result Pattern

**Purpose**: Type-safe error handling without exceptions

**Benefits**:
- Explicit error handling
- Forces handling of failures
- Type-safe
- Composable

**Implementation**:
```dart
// Result type
sealed class Result<T> {
  const Result();
  
  factory Result.success(T value) = Success<T>;
  factory Result.failure(AppFailure failure) = Failure<T>;
  
  R when<R>({
    required R Function(T value) success,
    required R Function(AppFailure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).value);
    } else {
      return failure((this as Failure<T>).failure);
    }
  }
}

// Failure hierarchy
sealed class AppFailure {
  final String message;
  const AppFailure({required this.message});
}

class NetworkFailure extends AppFailure {
  const NetworkFailure({required super.message});
}

class AuthFailure extends AppFailure {
  const AuthFailure({required super.message});
}

// Usage
Future<Result<User>> signIn(String email, String password) async {
  if (!Validators.isValidEmail(email)) {
    return Result.failure(
      ValidationFailure(message: 'Invalid email format'),
    );
  }
  
  try {
    final user = await _api.signIn(email, password);
    return Result.success(user);
  } catch (e) {
    return Result.failure(NetworkFailure(message: e.toString()));
  }
}

// Handle result
final result = await authRepository.signIn(email, password);
result.when(
  success: (user) => print('Logged in as ${user.email}'),
  failure: (failure) => print('Login failed: ${failure.message}'),
);
```

### 3. Provider Pattern (Riverpod)

**Purpose**: Reactive state management with dependency injection

**Benefits**:
- Compile-time safety
- No BuildContext required
- Automatic disposal
- Easy testing
- Dependency injection built-in

**Provider Types**:

```dart
// 1. Provider - Immutable value, computed state
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.whenOrNull(data: (user) => user);
});

// 2. StateNotifierProvider - Mutable state
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// 3. FutureProvider - Async data loading
final plansProvider = FutureProvider<List<Plan>>((ref) async {
  final repository = ref.watch(plansRepositoryProvider);
  final result = await repository.getPlans();
  return result.when(
    success: (plans) => plans,
    failure: (failure) => throw failure,
  );
});

// 4. StreamProvider - Real-time updates
final messagesStreamProvider = StreamProvider<List<ChatMessage>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchMessages(ref.watch(currentUserProvider)!.id);
});
```

## Data Flow

### Read Flow (Display Data)
```
Screen
  ↓ ref.watch(provider)
Provider
  ↓ calls repository
Repository
  ↓ fetches data
API/Database
  ↓ returns DTO
Repository
  ↓ converts to Model
Provider
  ↓ updates state
Screen
  ↓ rebuilds with new data
```

### Write Flow (User Action)
```
User Input
  ↓
Screen
  ↓ calls provider.method()
Provider
  ↓ sets loading state
  ↓ calls repository.method()
Repository
  ↓ sends request
API/Database
  ↓ returns result
Repository
  ↓ returns Result<T>
Provider
  ↓ updates state (success/error)
  ↓ logs result
Screen
  ↓ rebuilds with new state
  ↓ shows success/error UI
```

## Error Handling Strategy

### 1. Data Layer Errors
- Catch all exceptions
- Convert to domain failures
- Log errors
- Return Result.failure()

### 2. State Management Errors
- Receive Result from repository
- Update AsyncValue.error() on failure
- Log important errors
- Provide user-friendly messages

### 3. Presentation Layer Errors
- Display AsyncValue errors
- Show user-friendly messages
- Provide retry actions
- Use AppErrorWidget

### Example:
```dart
// Repository
Future<Result<User>> signIn(String email, String password) async {
  try {
    final response = await _dio.post('/auth/login', ...);
    return Result.success(User.fromJson(response.data));
  } on DioException catch (e) {
    AppLogger.error('API error', e);
    return Result.failure(NetworkFailure(
      message: e.response?.data['message'] ?? 'Connection failed',
    ));
  } catch (e, stack) {
    AppLogger.error('Unexpected error', e, stack);
    return Result.failure(UnknownFailure(message: 'Something went wrong'));
  }
}

// Provider
Future<void> signIn(String email, String password) async {
  state = const AsyncValue.loading();
  
  final result = await _repository.signIn(email, password);
  state = result.when(
    success: (user) => AsyncValue.data(user),
    failure: (failure) => AsyncValue.error(failure, StackTrace.current),
  );
}

// Screen
final authState = ref.watch(authProvider);

authState.when(
  data: (user) => Text('Welcome ${user?.displayName}'),
  loading: () => const CircularProgressIndicator(),
  error: (error, _) => AppErrorWidget(
    message: error is AppFailure ? error.message : 'An error occurred',
    onRetry: () => ref.refresh(authProvider),
  ),
);
```

## Testing Strategy

### 1. Unit Tests
Test individual functions and classes in isolation

**What to test**:
- Models (JSON serialization, copyWith, getters)
- Validators
- Utils
- Repository methods
- Provider logic

**Example**:
```dart
void main() {
  group('Validators', () {
    test('isValidEmail returns true for valid email', () {
      expect(Validators.isValidEmail('test@example.com'), true);
    });
    
    test('isValidEmail returns false for invalid email', () {
      expect(Validators.isValidEmail('invalid'), false);
    });
  });
}
```

### 2. Widget Tests
Test UI components in isolation

**What to test**:
- Individual widgets render correctly
- User interactions work
- State changes update UI
- Error states display properly

**Example**:
```dart
void main() {
  testWidgets('AppButton displays text correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Click Me',
            onPressed: () {},
          ),
        ),
      ),
    );
    
    expect(find.text('Click Me'), findsOneWidget);
  });
}
```

### 3. Provider Tests
Test state management logic

**What to test**:
- State transitions
- Async operations
- Error handling
- Side effects

**Example**:
```dart
void main() {
  test('AuthNotifier signs in successfully', () async {
    final mockRepository = MockAuthRepository();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    
    when(() => mockRepository.signIn(any(), any()))
        .thenAnswer((_) async => Result.success(testUser));
    
    await container.read(authProvider.notifier).signIn('test@test.com', 'password');
    
    final state = container.read(authProvider);
    expect(state.hasValue, true);
    expect(state.value, testUser);
  });
}
```

### 4. Integration Tests
Test complete user flows

**What to test**:
- Complete user journeys
- Navigation flows
- End-to-end features

**Example**:
```dart
void main() {
  testWidgets('User can sign in and see home screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Find and tap email field
    await tester.enterText(find.byType(TextField).first, 'test@test.com');
    
    // Find and tap password field
    await tester.enterText(find.byType(TextField).last, 'password123');
    
    // Tap sign in button
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    
    // Verify home screen is displayed
    expect(find.text('Welcome'), findsOneWidget);
  });
}
```

## Best Practices

### 1. Dependency Injection
```dart
// ✅ Good - Use providers for DI
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return DummyAuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// ❌ Bad - Hard-coded dependencies
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final repository = DummyAuthRepository(); // Hard to test!
}
```

### 2. Const Constructors
```dart
// ✅ Good - Use const for performance
const AppButton(
  text: 'Click Me',
  onPressed: handleClick,
)

// ❌ Bad - Unnecessary rebuilds
AppButton(
  text: 'Click Me',
  onPressed: handleClick,
)
```

### 3. Immutability
```dart
// ✅ Good - Immutable with copyWith
class User {
  final String id;
  final String name;
  
  const User({required this.id, required this.name});
  
  User copyWith({String? id, String? name}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

// ❌ Bad - Mutable state
class User {
  String id;
  String name;
}
```

### 4. Error Handling
```dart
// ✅ Good - Return Result type
Future<Result<User>> getUser(String id) async {
  try {
    final user = await _api.getUser(id);
    return Result.success(user);
  } catch (e) {
    return Result.failure(NetworkFailure(message: e.toString()));
  }
}

// ❌ Bad - Throw exceptions
Future<User> getUser(String id) async {
  final user = await _api.getUser(id); // Can throw!
  return user;
}
```

### 5. Logging
```dart
// ✅ Good - Structured logging
AppLogger.info('User signed in', data: {'userId': user.id});
AppLogger.error('API call failed', error, stackTrace);

// ❌ Bad - Print statements
print('User signed in: ${user.id}');
print('Error: $error');
```

## Performance Optimization

### 1. Const Constructors
Use `const` wherever possible to prevent unnecessary rebuilds

### 2. Provider Scoping
Use `select` to watch only specific parts of state:
```dart
final userName = ref.watch(currentUserProvider.select((user) => user?.name));
```

### 3. List Rendering
Use `ListView.builder` for efficient list rendering:
```dart
ListView.builder(
  itemCount: messages.length,
  itemBuilder: (context, index) => MessageTile(messages[index]),
)
```

### 4. Image Caching
Use `CachedNetworkImage` for image caching

### 5. Lazy Loading
Load data on-demand using `AutoDispose`:
```dart
final userProvider = FutureProvider.autoDispose<User>((ref) async {
  return await repository.getUser();
});
```

## Migration Guide

### From Provider to Riverpod

**Provider**:
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    return Text(user.name);
  }
}
```

**Riverpod**:
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Text(user.name);
  }
}
```

## Conclusion

This architecture provides:
- ✅ **Separation of concerns**: Each layer has a clear responsibility
- ✅ **Testability**: Easy to test each layer in isolation
- ✅ **Maintainability**: Easy to understand and modify
- ✅ **Scalability**: Easy to add new features
- ✅ **Type safety**: Compile-time error checking
- ✅ **Performance**: Optimized rendering and state management

Follow these patterns and principles to maintain code quality as the app grows!
