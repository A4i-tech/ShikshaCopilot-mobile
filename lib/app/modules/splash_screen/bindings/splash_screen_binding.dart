import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

/// A binding for the SplashScreen module.
class SplashScreenBinding extends Bindings {
  @override
  /// Initializes the [SplashScreenController] as a lazy put dependency.
  void dependencies() {
    Get.lazyPut<SplashScreenController>(
      () => SplashScreenController(),
    );
  }
}
