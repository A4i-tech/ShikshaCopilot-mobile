import 'package:sikshana/app/utils/exports.dart';

/// Controller for Splash Screen
class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Animation controller for handling animations
  late AnimationController animationController;

  /// Animation for scaling effect
  late Animation<double> animation;

  @override
  /// Called when the controller is initialized.
  /// Initializes the animation controller and starts the animation.
  /// Navigates to the authentication screen after a delay.
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animation = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    animationController.forward();
    Future<void>.delayed(const Duration(seconds: 3), () {
      UserProvider.loadUser();
      if (UserProvider.currentUser?.rememberMeToken ?? false) {
        Get.offAllNamed(Routes.NAVIGATION_SCREEN);
      } else {
        Get.offAllNamed(Routes.AUTH);
      }
    });
  }

  @override
  /// Called when the controller is closed.
  /// Disposes the animation controller.
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
