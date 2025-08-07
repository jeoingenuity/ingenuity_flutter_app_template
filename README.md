# Ingenuity Flutter App Template

![coverage][coverage_badge]
[![License: MIT][license_badge]][license_link]

A production-ready Flutter application template featuring **Clean Architecture**, **AWS Amplify Authentication**, **BLoC State Management**, and comprehensive development tools.

## ✨ Features

### 🏗️ Architecture & Design Patterns

- **Clean Architecture** with clear separation of concerns
- **Feature-based** folder structure for scalability
- **BLoC Pattern** for predictable state management
- **Dependency Injection** using GetIt
- **Result/Either Pattern** for robust error handling

### 🔐 Authentication & Security

- **AWS Amplify Cognito** integration for authentication
- **Flutter Secure Storage** for sensitive data
- **JWT token management** with automatic refresh
- **Biometric authentication** support (planned)

### 🎨 UI/UX & Theming

- **Material Design 3** with custom theme system
- **Dark/Light mode** support with system theme detection
- **Responsive design** for multiple screen sizes
- **Custom animations** and transitions
- **Internationalization** (i18n) with English and Filipino support

### 🔧 Development Experience

- **Advanced logging** system with Talker integration
- **Over-the-air updates** with Shorebird Code Push
- **Form validation** with Formz
- **Comprehensive error handling** with custom exceptions
- **Hot reload** and **hot restart** support
- **VS Code launch configurations** for all flavors

### 🚀 Performance & Quality

- **Optimized build configurations** for each environment
- **Code generation** for localizations
- **Static analysis** with Flutter Lints
- **Unit and widget testing** setup
- **Coverage reporting** integration

---

## 📱 Getting Started

### Prerequisites

1. **Flutter SDK** (3.5.0 or higher)
2. **Dart SDK** (3.8.0 or higher)
3. **AWS Account** for Amplify services (optional)
4. **Shorebird Account** for OTA updates (optional)

### � Environment Flavors

This project contains 3 flavors optimized for different stages of development:

- **development** - Debug builds with verbose logging and development tools
- **staging** - Release-candidate builds for testing
- **production** - Optimized builds for app store distribution

### 🏃‍♂️ Running the App

Choose your preferred method:

#### VS Code / Android Studio

Use the provided launch configurations for easy debugging.

#### Command Line

```sh
# Development (with verbose logging)
flutter run --flavor development --target lib/main_development.dart

# Staging (optimized for testing)
flutter run --flavor staging --target lib/main_staging.dart

# Production (optimized for release)
flutter run --flavor production --target lib/main_production.dart
```

### 📦 First-Time Setup

1. **Clone and install dependencies:**

   ```sh
   git clone <repository-url>
   cd ingenuity_flutter_app_template
   flutter pub get
   ```

2. **Configure Assets (Optional):**

   ```sh
   # Add your app icons and splash images to assets/ folder
   # Then uncomment and run:
   # flutter pub run flutter_launcher_icons:main
   # flutter pub run flutter_native_splash:create
   ```

3. **Configure AWS Amplify (Optional):**

   ```sh
   # Update lib/amplifyconfiguration.dart with your Amplify config
   # Or remove Amplify integration if not needed
   ```

**Platform Support:** iOS, Android, Web, Windows, macOS (universal compatibility)

---

## 🧪 Testing & Quality Assurance

### Running Tests

To run all unit and widget tests use the following command:

```sh
flutter test --coverage --test-randomize-ordering-seed random
```

### Coverage Reports

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

---

## 🏗️ Project Architecture

This template follows **Clean Architecture** principles with the following structure:

```text
lib/
├── app/                    # Application layer
│   └── view/              # App-wide configuration
├── core/                  # Core functionality
│   ├── di/               # Dependency injection
│   ├── errors/           # Error handling
│   ├── services/         # Core services
│   ├── theme/            # Theme configuration
│   └── utils/            # Utilities
├── features/             # Feature modules
│   └── auth/            # Authentication feature
│       ├── data/        # Data layer
│       ├── domain/      # Domain layer
│       └── presentation/ # Presentation layer
├── l10n/                # Localization
├── models/              # Shared models
└── views/               # Shared views
```

### Key Architectural Decisions

- **Feature-driven** folder structure for better scalability
- **Dependency injection** with GetIt for loose coupling
- **Result pattern** for robust error handling
- **BLoC pattern** for predictable state management
- **Service layer** for business logic abstraction

---

## 🌐 Internationalization (i18n)

This project supports multiple languages with **English** and **Filipino** built-in. The internationalization system uses Flutter's official localization framework.

### 📝 Adding New Strings

1. **Add to English ARB file** (`lib/l10n/arb/app_en.arb`):

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "newStringKey": "Your new text here",
    "@newStringKey": {
        "description": "Description of your new string"
    }
}
```

2. **Add translation to Filipino ARB file** (`lib/l10n/arb/app_fil.arb`):

```arb
{
    "@@locale": "fil",
    "counterAppBarTitle": "Sumukat",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "newStringKey": "Ang inyong bagong teksto dito",
    "@newStringKey": {
        "description": "Description of your new string"
    }
}
```

3. **Use in your Dart code:**

```dart
import 'package:ingenuity_flutter_app_template/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.newStringKey);
}
```

### 🌍 Adding New Languages

1. **Create new ARB file:** `lib/l10n/arb/app_[language_code].arb`

2. **Update supported locales** in `lib/app/view/app.dart`:

```dart
supportedLocales: const [
  Locale('en', ''),
  Locale('fil', ''),
  Locale('es', ''), // Add your new language
],
```

3. **Update iOS configuration** (`ios/Runner/Info.plist`):

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>fil</string>
    <string>es</string>
</array>
```

### 🔄 Generating Translations

Translations are automatically generated when you run the app. To manually generate:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

---

## 🔧 Advanced Configuration

### 📱 App Icons & Splash Screen

The template supports custom app icons and splash screens:

1. **Add your assets** to the `assets/` folder:
   - `app_icon.png` (1024x1024px)
   - `splash_logo.png` (512x512px for light theme)
   - `splash_logo_dark.png` (512x512px for dark theme)

2. **Uncomment configuration** in `pubspec.yaml`:

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

3. **Generate assets:**

```sh
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create
```

### 🔐 AWS Amplify Setup

To use AWS authentication:

1. **Configure Amplify CLI** and create your Cognito User Pool
2. **Update `lib/amplifyconfiguration.dart`** with your configuration
3. **The app will automatically handle** sign-in, sign-up, and authentication flow

### 🚀 Shorebird OTA Updates

For over-the-air updates:

1. **Install Shorebird CLI:** [https://shorebird.dev](https://shorebird.dev)
2. **Configure your project** with Shorebird
3. **Deploy updates** without app store approval

---

## 📚 Key Dependencies

- **State Management:** `flutter_bloc`, `bloc`
- **Dependency Injection:** `get_it`
- **Authentication:** `amplify_flutter`, `amplify_auth_cognito`
- **Form Validation:** `formz`
- **HTTP Client:** `dio`
- **Secure Storage:** `flutter_secure_storage`
- **Logging:** `talker_flutter`
- **OTA Updates:** `shorebird_code_push`
- **Internationalization:** `intl`, `flutter_localizations`

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

[coverage_badge]: coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
