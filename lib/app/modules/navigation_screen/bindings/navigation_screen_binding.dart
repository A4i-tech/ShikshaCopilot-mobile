import 'package:sikshana/app/utils/exports.dart';

import '../controllers/navigation_screen_controller.dart';

/// A binding class for the NavigationScreen.
///
/// This class sets up the dependencies for the [NavigationScreenView] and its
/// controller, [NavigationScreenController]. It also initializes other
/// controllers that are used across different tabs of the navigation screen,
/// making them available for dependency injection.
class NavigationScreenBinding extends Bindings {
  /// Sets up the dependencies for the navigation screen.
  ///
  /// This method uses `GetX`'s dependency injection system to register
  /// controllers.
  ///
  /// - [NavigationScreenController] is registered using `lazyPut`, so it is
  ///   instantiated only when it's first needed.
  /// - [HomeController], [ContentGenerationController], [ProfileController],
  ///   and [ChatbotController] are registered as permanent dependencies using
  ///   `put`, ensuring they remain in memory and accessible throughout the app's
  ///   lifecycle, as they manage the state for each of the main tabs.
  @override
  void dependencies() {
    Get
      ..lazyPut<NavigationScreenController>(() => NavigationScreenController())
      ..put<HomeController>(HomeController(), permanent: true)
      ..put<ContentGenerationController>(
        ContentGenerationController(),
        permanent: true,
      )
      ..put<ProfileController>(ProfileController(), permanent: true)
      ..put<ChatbotController>(ChatbotController(), permanent: true);
  }
}
