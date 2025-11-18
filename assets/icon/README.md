# App Icon Setup

## Quick Start

1. **Add your icon image** (1024x1024 PNG recommended):
   - Place your icon as: `assets/icon/app_icon.png`
   - For Android adaptive icon, also add: `assets/icon/app_icon_foreground.png`

2. **Install the package**:
   ```bash
   flutter pub get
   ```

3. **Generate icons**:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

## Icon Requirements

### Main Icon (`app_icon.png`)
- **Size**: 1024x1024 pixels (recommended)
- **Format**: PNG with transparency
- **Content**: Your full app icon design

### Adaptive Icon Foreground (`app_icon_foreground.png`) - Android only
- **Size**: 1024x1024 pixels
- **Format**: PNG with transparency
- **Content**: Icon foreground layer (keep important content within safe zone - center 66%)
- **Background color**: Set in pubspec.yaml (currently: #B794F6 - your app's purple)

## Quick Icon Creation Options

### Option 1: Use Online Tools
- [Icon Kitchen](https://icon.kitchen/) - Free, easy icon generator
- [AppIcon.co](https://appicon.co/) - Upload and generate all sizes
- [MakeAppIcon](https://makeappicon.com/) - Simple icon generator

### Option 2: Design Your Own
1. Create a 1024x1024 PNG with your design
2. For astrology app, consider:
   - ⭐ Stars/constellation design
   - 🌙 Moon phases
   - ♈ Zodiac symbols
   - 🔮 Crystal ball
   - ✨ Mystical elements with purple gradient

### Option 3: Use the Placeholder
I've configured it to use a purple background (#B794F6) with your foreground icon.

## Current Configuration

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#B794F6"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
  remove_alpha_ios: true
```

## Customization

### Change Background Color
Edit `pubspec.yaml`:
```yaml
adaptive_icon_background: "#YOUR_COLOR_HEX"
```

### Use Image Background (Android)
```yaml
adaptive_icon_background: "assets/icon/app_icon_background.png"
```

### Generate for Specific Platforms Only
```yaml
flutter_launcher_icons:
  android: true  # Set to false to skip Android
  ios: false     # Set to false to skip iOS
```

## After Generating

The script will automatically:
- ✅ Generate all required icon sizes for Android (mdpi, hdpi, xhdpi, etc.)
- ✅ Generate all required icon sizes for iOS (@2x, @3x)
- ✅ Create adaptive icons for Android 8.0+
- ✅ Update Android and iOS configuration files

## Testing

After generating icons:
1. Clean build: `flutter clean`
2. Rebuild: `flutter run`
3. Check the app icon on your device/emulator

## Troubleshooting

**Icons not showing?**
- Make sure icon files exist in `assets/icon/`
- Run `flutter clean` and rebuild
- For Android: Uninstall app and reinstall
- For iOS: Clean build folder in Xcode

**Generation errors?**
- Verify image paths in `pubspec.yaml`
- Ensure PNG format (not JPEG)
- Check image sizes (1024x1024 recommended)
