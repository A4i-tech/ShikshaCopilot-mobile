# Project Overview

This is a Flutter mobile application for Sikshana Copilot. It is built using the Flutter framework and utilizes the GetX ecosystem for state management, routing, and dependency injection. The project is structured with a clear separation of concerns, with modules for different features of the application.

## Key Technologies

*   **Framework:** Flutter
*   **State Management:** GetX
*   **Routing:** GetX
*   **Localization:** GetX
*   **UI:** Material Design

## Project Structure

The project follows a modular structure, with each feature having its own directory containing bindings, controllers, and views.

*   `lib/app/modules`: Contains the different modules of the application.
*   `lib/app/data`: Contains data-related files, such as configuration, enums, extensions, and remote API services.
*   `lib/app/routes`: Defines the application's routes using GetX.
*   `lib/app/ui`: Contains UI-related components and styles.
*   `lib/app/utils`: Contains utility functions and exports.
*   `assets`: Contains static assets like images, SVGs, and Lottie animations.
*   `assets/locales`: Contains the localization files.

## Building and Running

To build and run the project, you can use the standard Flutter commands:

```bash
flutter pub get
flutter run
```

## Development Conventions

### Localization

The project uses the GetX framework for localization. To add or update translations, modify the JSON files in the `assets/locales` directory and then run the following script to generate the necessary Dart code:

```bash
./generate_locales.sh
```

### State Management

The project uses GetX for state management. Controllers are used to manage the state of each screen, and bindings are used to inject the necessary dependencies.

### Routing

The project uses GetX for routing. Routes are defined in the `lib/app/routes/app_pages.dart` file.

### Code Style

The project follows the standard Dart and Flutter code style guidelines. The `analysis_options.yaml` file contains a set of recommended lints to encourage good coding practices.
