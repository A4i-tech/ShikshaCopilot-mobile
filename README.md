# Sikshana Mobile App

This is the official mobile application for Sikshana Copilot, built with Flutter.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Building and Running the App

This project uses Flutter flavors to manage different environments (development and production).

### Flavors

-   **dev**: For development and testing. Connects to the development server.
-   **prod**: For the production release. Connects to the live server.

### Running the App

To run the application, you need to specify the flavor and the target entry point file.

**Run the `dev` flavor:**

```bash
flutter run --flavor dev -t lib/main_dev.dart
```

**Run the `prod` flavor:**

```bash
flutter run --flavor prod -t lib/main_prod.dart
```

### Building the App

**Build an APK:**

-   **dev**: `flutter build apk --flavor dev -t lib/main_dev.dart`
-   **prod**: `flutter build apk --flavor prod -t lib/main_prod.dart`

**Build an App Bundle (for Google Play):**

-   **dev**: `flutter build appbundle --flavor dev -t lib/main_dev.dart`
-   **prod**: `flutter build appbundle --flavor prod -t lib/main_prod.dart`