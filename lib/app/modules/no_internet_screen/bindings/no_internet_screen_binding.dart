import 'package:get/get.dart';

import '../controllers/no_internet_screen_controller.dart';

/// A binding for the NoInternetScreen module.
class NoInternetScreenBinding extends Bindings {
  @override
  /// Initializes the [NoInternetScreenController] as a lazy put dependency.
  void dependencies() {
    Get.lazyPut<NoInternetScreenController>(
      () => NoInternetScreenController(),
    );
  }
}
