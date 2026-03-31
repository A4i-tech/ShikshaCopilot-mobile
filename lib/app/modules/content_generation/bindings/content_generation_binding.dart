import 'package:get/get.dart';

import '../controllers/content_generation_controller.dart';

/// A binding class for the ContentGeneration screen.
///
/// This class sets up the dependencies required for the ContentGeneration screen,
/// primarily the [ContentGenerationController].
class ContentGenerationBinding extends Bindings {
  /// Sets up the dependencies for the ContentGeneration screen.
  ///
  /// This method uses [Get.lazyPut] to lazily initialize the
  /// [ContentGenerationController], which means the controller will only be
  /// created when it is first needed.
  @override
  void dependencies() {
    Get.lazyPut<ContentGenerationController>(
      () => ContentGenerationController(),
    );
  }
}
