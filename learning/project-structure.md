# TrustAstrology - Project Structure Guide

## Overview
This document explains the complete file structure of the TrustAstrology Flutter app, detailing what each file does and how they interact with each other.

---

## 📁 Project Root Files

### `pubspec.yaml`
**Purpose**: Defines project metadata, dependencies, and assets.

**Key Dependencies**:
- `provider: ^6.0.5` - State management across the app
- `google_fonts: ^6.2.1` - Custom typography (Poppins font)
- `cupertino_icons: ^1.0.8` - iOS-style icons

**Usage**: Run `flutter pub get` after modifying dependencies.

---

### `README.md`
**Purpose**: Project documentation with setup instructions, features list, and architecture overview.

**Contains**:
- Getting started guide
- Project structure explanation
- Dummy auth usage
- Navigation flow diagram
- Future extension notes

---

### `analysis_options.yaml`
**Purpose**: Dart analyzer configuration and linting rules.

**Usage**: Enforces code quality standards using `flutter_lints` package.

---

## 📁 lib/ - Main Source Code

### `lib/main.dart`
**Purpose**: App entry point and root widget configuration.

**Key Features**:
- Initializes `MultiProvider` for state management
- Sets up `AuthController` and `ChatController`
- Configures `MaterialApp` with theme and routing
- Conditionally shows `LoginPage` or `MainScaffold` based on auth state

**Flow**:
```
main() 
  → TrustAstrologyApp 
    → MultiProvider (AuthController, ChatController)
      → MaterialApp
        → LoginPage (if not logged in)
        → MainScaffold (if logged in)
```

---

## 📁 lib/core/ - Shared Core Logic

### `lib/core/theme/app_theme.dart`
**Purpose**: Centralized theme configuration using Material 3.

**Features**:
- `AppTheme.light` - Light theme with purple primary color (#7C3AED)
- Google Fonts integration (Poppins)
- Custom `InputDecorationTheme` with rounded borders
- Custom `ElevatedButtonTheme` styling
- `AppBarTheme` with no elevation

**Usage**: Applied in `main.dart` via `theme: AppTheme.light`

---

### `lib/core/routes/app_routes.dart`
**Purpose**: Named route definitions and navigation logic.

**Routes**:
- `/login` → `LoginPage`
- `/signup` → `SignupPage`
- `/home` → `MainScaffold` (with bottom nav)
- `/chat` → `ChatPage`
- `/plans` → `PlansPage`
- `/settings` → `SettingsPage`
- `/language` → `LanguagePage`

**Usage**: 
```dart
Navigator.of(context).pushNamed(AppRoutes.chat);
```

---

### `lib/core/models/`

#### `chat_message.dart`
**Purpose**: Data model for chat messages.

**Fields**:
- `id`: Unique identifier
- `text`: Message content
- `timestamp`: When message was sent
- `fromUser`: Boolean (true = user, false = bot)

**Usage**: Used by `ChatController` and `ChatPage` to render messages.

---

#### `plan.dart`
**Purpose**: Data model for subscription plans.

**Fields**:
- `id`: Plan identifier
- `name`: Display name
- `description`: Plan details
- `pricePerMonth`: Pricing (double)
- `features`: List of feature strings

**Usage**: Rendered in `HomePage` and `PlansPage` cards.

---

### `lib/core/repositories/dummy_data.dart`
**Purpose**: Static data provider for development.

**Methods**:
- `DummyData.initialMessages()` - Returns 3 sample chat messages
- `DummyData.plans()` - Returns 3 subscription plans (Basic, Plus, Pro)

**Usage**: Injected into `ChatController` on app start and fetched by plan pages.

---

### `lib/core/widgets/primary_button.dart`
**Purpose**: Reusable button component.

**Props**:
- `label`: Button text
- `onPressed`: Callback function
- `outlined`: Boolean for outlined vs filled style

**Usage**: Used across auth, home, chat, and plan pages for consistent CTAs.

---

## 📁 lib/features/ - Feature Modules

### `lib/features/main_scaffold.dart`
**Purpose**: Main container with bottom navigation bar.

**Features**:
- Manages 5 tabs: Home, Language, Chat, Plans, Settings
- Uses `IndexedStack` to preserve state when switching tabs
- Dynamically updates AppBar title based on selected tab
- Single Scaffold wrapping all main pages

**State**: `_currentIndex` tracks active tab (0-4)

**Usage**: Shown after successful login as the main app shell.

---

## 📁 lib/features/auth/

### `auth_controller.dart`
**Purpose**: Manages authentication state using Provider.

**State**:
- `_loggedIn`: Boolean auth status
- `_email`: Current user's email

**Methods**:
- `login(email, password)` - Simulates async login (500ms delay)
- `signup(email, password)` - Simulates async signup (700ms delay)
- `logout()` - Clears session

**Usage**: 
```dart
context.read<AuthController>().login(email, password);
context.watch<AuthController>().isLoggedIn;
```

---

### `login_page.dart`
**Purpose**: User login form.

**Features**:
- Email and password `TextFormField` with validation
- Loading state during login
- Navigation to `SignupPage` or `HomePage`
- Branded card layout with purple theme

**Validation**:
- Email: Required
- Password: Required

**Flow**: Login → calls `AuthController.login()` → navigates to `/home`

---

### `signup_page.dart`
**Purpose**: User registration form.

**Features**:
- Email and password fields with validation
- Password length check (min 6 chars)
- Loading state during signup
- Navigation to `LoginPage` or `HomePage`

**Flow**: Signup → calls `AuthController.signup()` → navigates to `/home`

---

## 📁 lib/features/home/

### `home_page.dart`
**Purpose**: Main dashboard after login.

**Sections**:
1. **Hero Card** - Welcome message with sun icon
2. **Quick Actions** - 2 cards (Chat, Explore Plans)
3. **Popular Plans** - Horizontal scrolling plan cards
4. **Features** - 3 feature tiles (AI, Security, Support)

**Widgets**:
- `_QuickActionCard` - Clickable action card with icon
- `_PlanCard` - Compact plan preview (260px width)
- `_FeatureTile` - Feature description with icon

**Navigation**: 
- Quick Action "Chat" → `/chat`
- Quick Action "Explore" → `/plans`
- "View all" plans → `/plans`

---

## 📁 lib/features/chat/

### `chat_controller.dart`
**Purpose**: Manages chat state and bot simulation.

**State**:
- `_messages`: List of `ChatMessage` objects

**Methods**:
- `sendUserMessage(text)` - Adds user message and triggers bot reply
- Bot reply simulated after 600ms delay

**Usage**: Consumed by `ChatPage` via `Provider`

---

### `chat_page.dart`
**Purpose**: Real-time chat interface.

**Features**:
- Scrollable message list with `ListView.builder`
- User and bot message bubbles (different colors/alignment)
- Text input with Send button
- Auto-scroll to bottom on new message
- `SafeArea` for input field

**Widgets**:
- `_MessageBubble` - Styled message container (rounded corners, dynamic color)

**State**: 
- `_text`: TextEditingController for input
- `_scroll`: ScrollController for auto-scroll

---

## 📁 lib/features/plans/

### `plans_page.dart`
**Purpose**: Full subscription plans listing.

**Features**:
- Vertical `ListView` of all plans
- Detailed plan cards with features shown as `Chip` widgets
- "Select" button for each plan (placeholder action)

**Widgets**:
- `_PlanDetailCard` - Full plan card with:
  - Title and description
  - Feature chips (wrapped layout)
  - Price and Select button

**Data**: Fetches from `DummyData.plans()`

---

## 📁 lib/features/language/

### `language_page.dart`
**Purpose**: Language selection interface.

**Features**:
- List of 5 languages with flags (emoji)
  - English 🇬🇧
  - Hindi 🇮🇳
  - Spanish 🇪🇸
  - French 🇫🇷
  - Chinese 🇨🇳
- Current selection marked with checkmark
- SnackBar feedback on selection

**Widgets**:
- `_LanguageTile` - Language option with flag, name, and selection indicator

**Note**: Currently dummy - no actual localization implemented.

---

## 📁 lib/features/settings/

### `settings_page.dart`
**Purpose**: User settings and account management.

**Sections**:
1. **Profile Card** - User avatar and email
2. **Menu Items**:
   - My Activity (journey history)
   - Credits (balance management)
   - Shop (products)
   - Support (help)
   - Terms and Conditions
   - Legal (privacy policy)
3. **Logout Button** - Red outlined style

**Widgets**:
- `_SettingsTile` - Menu item with icon, title, subtitle, and chevron

**Actions**: All menu items show "Coming soon" snackbar. Logout calls `AuthController.logout()`.

---

## 📁 test/

### `widget_test.dart`
**Purpose**: Basic smoke test for app initialization.

**Test**:
- Verifies `TrustAstrologyApp` renders
- Checks `LoginPage` loads by default (unauthenticated)
- Confirms "TrustAstrology" title appears

**Run**: `flutter test`

---

## 🔄 Data Flow

### Authentication Flow
```
LoginPage 
  → AuthController.login() 
    → notifyListeners() 
      → main.dart Consumer rebuilds 
        → Shows MainScaffold
```

### Chat Flow
```
User types message 
  → ChatPage._send() 
    → ChatController.sendUserMessage() 
      → Adds user message 
        → notifyListeners() 
          → ChatPage rebuilds 
            → Simulates bot reply (600ms) 
              → Adds bot message 
                → notifyListeners() 
                  → ChatPage rebuilds
```

### Navigation Flow
```
Login 
  → MainScaffold (bottom nav) 
    → Home / Language / Chat / Plans / Settings tabs
      → Each maintains state via IndexedStack
```

---

## 🎨 Theme System

### Color Scheme
- **Primary**: Purple (#7C3AED)
- **Surface**: White/Light gray
- **Containers**: `primaryContainer`, `secondaryContainer`, `surfaceContainerHighest`

### Typography
- **Font Family**: Poppins (via Google Fonts)
- **Styles**: `titleLarge`, `headlineSmall`, `bodyLarge`, etc.

### Component Styling
- **Cards**: Rounded corners (12-20px), outlined border
- **Buttons**: 12px border radius, 14px vertical padding
- **Inputs**: 12px border radius, outlined style with focus state

---

## 🛠️ State Management

### Provider Pattern
- **AuthController**: Global auth state
- **ChatController**: Chat messages state

### Consumer Widgets
```dart
Consumer<AuthController>(
  builder: (context, auth, _) {
    return auth.isLoggedIn ? HomePage() : LoginPage();
  },
)
```

### Read/Watch
- `context.read<T>()` - One-time access (for methods)
- `context.watch<T>()` - Reactive access (rebuilds on change)

---

## 🚀 Future Integration Points

### Backend Ready
- Replace `AuthController.login()` with API calls
- Swap `DummyData` with HTTP/GraphQL client
- Add JWT token storage (shared_preferences/secure_storage)

### AI Integration
- Replace bot reply simulation in `ChatController`
- Integrate OpenAI/Gemini API for astrology responses
- Add streaming chat support

### Features to Add
- Push notifications
- Payment gateway (for plans)
- User profile editing
- Chat history persistence
- Dark theme toggle
- Localization (i18n)

---

## 📝 Best Practices Used

1. **Feature-based folder structure** - Easy to scale
2. **Provider for state management** - Reactive and simple
3. **Reusable widgets** - `PrimaryButton`, tiles, cards
4. **Centralized theme** - Consistent design system
5. **Named routes** - Clean navigation
6. **Dummy data layer** - Easy to swap with real API
7. **Model classes** - Type-safe data handling
8. **Material 3 design** - Modern UI guidelines

---

## 🔍 Key Files Summary

| File | Purpose | Used By |
|------|---------|---------|
| `main.dart` | App entry | - |
| `app_theme.dart` | Theme config | main.dart |
| `app_routes.dart` | Navigation | All pages |
| `auth_controller.dart` | Auth state | Login, Signup, Settings |
| `chat_controller.dart` | Chat state | ChatPage |
| `dummy_data.dart` | Mock data | Home, Plans, Chat |
| `main_scaffold.dart` | Bottom nav shell | main.dart (after login) |
| `login_page.dart` | Login UI | main.dart |
| `home_page.dart` | Dashboard | MainScaffold |
| `chat_page.dart` | Chat UI | MainScaffold |
| `plans_page.dart` | Plans list | MainScaffold |
| `settings_page.dart` | Settings menu | MainScaffold |

---

**Last Updated**: November 11, 2025  
**Author**: GitHub Copilot  
**Version**: 1.0.0
