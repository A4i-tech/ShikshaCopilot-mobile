import 'package:get/get.dart';

import '../controllers/faq_controller.dart';

/// A binding class for the FAQ screen.
///
/// This class is responsible for setting up the dependencies required for the
/// FAQ feature, primarily the [FaqController]. By using [Bindings], we can
/// ensure that the controller is only instantiated when the FAQ screen is
/// navigated to, and it will be properly disposed of when the screen is
/// removed from the navigation stack.
class FaqBinding extends Bindings {
  /// Sets up the dependencies for the FAQ feature.
  ///
  /// This method is called by GetX when the route associated with this binding
  /// is navigated to. It lazily initializes and registers [FaqController]
  /// with GetX's dependency management system.
  @override
  void dependencies() {
    Get.lazyPut<FaqController>(
      () => FaqController(),
    );
  }
}
