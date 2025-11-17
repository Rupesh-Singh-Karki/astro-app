# Cleanup Instructions

## Old Files to Remove

The refactoring created a new architecture in the following directories:
- `lib/screens/` - New screen implementations
- `lib/components/` - New reusable components
- `lib/providers/` - New Riverpod providers

The following old directories can be safely **deleted** as they are no longer needed:

### 1. Old Feature Directory
```
lib/features/
├── auth/
│   ├── login_page.dart      ❌ DELETE (replaced by lib/screens/auth/login_screen.dart)
│   ├── signup_page.dart     ❌ DELETE (replaced by lib/screens/auth/signup_screen.dart)
│   └── auth_controller.dart ❌ DELETE (replaced by lib/providers/auth_provider.dart)
├── home/
│   └── home_page.dart       ❌ DELETE (replaced by lib/screens/home/home_screen.dart)
├── chat/
│   ├── chat_page.dart       ❌ DELETE (replaced by lib/screens/chat/chat_screen.dart)
│   └── chat_controller.dart ❌ DELETE (replaced by lib/providers/chat_provider.dart)
├── settings/
│   └── settings_page.dart   ❌ DELETE (replaced by lib/screens/settings/settings_screen.dart)
├── plans/
│   └── plans_page.dart      ❌ DELETE (can be recreated if needed)
└── main_scaffold.dart       ❌ DELETE (replaced by lib/screens/home/main_scaffold_screen.dart)
```

### 2. Old Core Directory (if exists)
```
lib/core/
├── theme/
│   └── app_theme.dart       ❌ DELETE (replaced by lib/theme/app_theme.dart)
├── routes/
│   └── app_routes.dart      ❌ DELETE (navigation now in screens directly)
├── models/                  ❌ DELETE (replaced by lib/models/)
├── repositories/            ❌ DELETE (replaced by lib/repositories/)
└── widgets/                 ❌ DELETE (replaced by lib/components/)
```

### 3. Old Service/Repository Files
```
lib/services/                ❌ DELETE (merged into repositories)
lib/repositories/DummyData.dart ❌ DELETE (replaced by new dummy repositories)
```

## Cleanup Commands (PowerShell)

Run these commands from your project root to remove old files:

```powershell
# Remove old features directory
Remove-Item -Path "lib\features" -Recurse -Force

# Remove old core directory (if it exists)
Remove-Item -Path "lib\core" -Recurse -Force

# Remove old services directory (if it exists)
Remove-Item -Path "lib\services" -Recurse -Force
```

## After Cleanup

After removing old files, run:

```powershell
# Clean the project
flutter clean

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Verification

After cleanup, your `lib/` directory should look like this:

```
lib/
├── main.dart
├── components/
│   ├── app_button.dart
│   ├── app_text_field.dart
│   └── app_widgets.dart
├── constants/
│   └── app_constants.dart
├── models/
│   ├── user.dart
│   ├── chat_message.dart
│   └── plan.dart
├── providers/
│   ├── auth_provider.dart
│   └── chat_provider.dart
├── repositories/
│   ├── auth_repository.dart
│   ├── dummy_auth_repository.dart
│   ├── chat_repository.dart
│   └── dummy_chat_repository.dart
├── screens/
│   ├── auth/
│   ├── chat/
│   ├── home/
│   └── settings/
├── theme/
│   ├── app_colors.dart
│   ├── app_spacing.dart
│   ├── app_typography.dart
│   └── app_theme.dart
└── utils/
    ├── result.dart
    ├── logger.dart
    └── validators.dart
```

## Important Note

**DO NOT** delete these files as they are part of the new architecture:
- ✅ `lib/screens/` - Keep all files
- ✅ `lib/components/` - Keep all files
- ✅ `lib/providers/` - Keep all files
- ✅ `lib/repositories/` - Keep all files
- ✅ `lib/models/` - Keep all files
- ✅ `lib/theme/` - Keep all files
- ✅ `lib/utils/` - Keep all files
- ✅ `lib/constants/` - Keep all files
- ✅ `lib/main.dart` - Keep (updated version)

## Why Remove Old Files?

1. **Avoid Confusion** - Having both old and new implementations can confuse developers
2. **Reduce Errors** - Old files use Provider which is no longer in dependencies
3. **Clean Codebase** - Keeps the project clean and maintainable
4. **IDE Performance** - Fewer files = faster IDE indexing
5. **Clear Direction** - Makes it obvious which files to use

## If You Need Old Code

If you need to reference old implementations:

1. **Don't delete yet** - Keep them temporarily
2. **Check git history** - All old code is in git commits
3. **Export to backup** - Copy `lib/features/` to a backup folder outside the project

```powershell
# Backup before deleting
Copy-Item -Path "lib\features" -Destination "backup_features" -Recurse
```

---

**After cleanup, all compile errors will be resolved! ✅**
