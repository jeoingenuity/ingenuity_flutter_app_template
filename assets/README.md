# Assets Directory

This directory contains the app's static assets including images, icons, and other resources.

## Required Assets (Currently Missing)

To complete the app configuration, you'll need to add the following image files:

### App Icon
- **File:** `app_icon.png`
- **Size:** 1024x1024px
- **Format:** PNG with transparency
- **Purpose:** Used for generating platform-specific app icons

### Splash Screen Images
- **File:** `splash_logo.png`
- **Size:** 512x512px (recommended)
- **Format:** PNG with transparency
- **Purpose:** Logo displayed on light theme splash screen

- **File:** `splash_logo_dark.png`
- **Size:** 512x512px (recommended)
- **Format:** PNG with transparency
- **Purpose:** Logo displayed on dark theme splash screen

## Enabling Native Splash & Icons

Once you've added the required images, uncomment the configuration in `pubspec.yaml`:

```yaml
flutter_native_splash:
  color: "#ffffff"
  image: assets/splash_logo.png
  color_dark: "#000000"
  image_dark: assets/splash_logo_dark.png

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/app_icon.png"
```

Then run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create
```

## Adding More Assets

Place any additional assets (fonts, images, data files) in this directory and reference them in `pubspec.yaml` under the `flutter: assets:` section.
