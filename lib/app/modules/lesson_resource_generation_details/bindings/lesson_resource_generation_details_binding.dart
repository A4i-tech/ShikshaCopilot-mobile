import 'package:get/get.dart';

import '../controllers/lesson_resource_generation_details_controller.dart';

/// A binding class for the LessonResourceGenerationDetails screen.
///
/// This class is responsible for setting up the dependencies required by the
/// [LessonResourceGenerationDetailsController]. It uses GetX's dependency management
/// to lazily put the controller, making it available for the view.
class LessonResourceGenerationDetailsBinding extends Bindings {
  /// Sets up the dependencies for the LessonResourceGenerationDetails screen.
  ///
  /// This method is called by the GetX framework to initialize and register
  /// the [LessonResourceGenerationDetailsController] as a dependency.
  @override
  void dependencies() {
    Get.lazyPut<LessonResourceGenerationDetailsController>(
      () => LessonResourceGenerationDetailsController(),
    );
  }
}
