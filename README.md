# TrustAstrology (Frontend)

Clean, modern Flutter frontend prototype for TrustAstrology – an AI‑powered astrology insights app. This rebuild provides authentication flow (dummy), home dashboard, chat interface, and subscription plans using static data. Ready for future backend + AI integration.

## Features

- Login & Signup (dummy, local state only)
- Home page with welcome, chat CTA, and featured plans preview
- Chat screen with simulated astrologer replies
- Plans listing page (dummy subscription plans)
- Modular architecture (core + feature folders)
- Provider state management, Material 3 design, Google Fonts

## Project Structure

```
lib/
	main.dart                # App entry (TrustAstrologyApp)
	core/
		theme/app_theme.dart   # Central theme
		routes/app_routes.dart # Named route definitions
		models/                # Data models (ChatMessage, Plan)
		repositories/          # DummyData provider
		widgets/               # Reusable UI widgets
	features/
		auth/                  # Auth pages + controller
		home/                  # Home dashboard
		chat/                  # Chat controller & page
		plans/                 # Plans page
```

## Getting Started (Windows PowerShell)

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

## Dummy Auth
Any email/password accepted. Login or Signup sets an in‑memory session via `AuthController`. Use the logout icon on the Home AppBar to clear session.

## Navigation Flow
`Login → Signup → Home → Chat / Plans` (back supported). Direct routes guarded by showing Login if not authenticated.

## Extending Later
- Replace `AuthController` methods with API calls.
- Swap `DummyData` with network layer (e.g., REST/GraphQL) and streaming chat via WebSocket.
- Add secure storage & token refresh.
- Introduce error / loading states & skeletons.

## Tests
Basic smoke test ensures login screen renders. Add more tests for controllers & navigation as backend stabilizes.

## License
Internal prototype – not for distribution.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
