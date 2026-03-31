import 'package:get/get.dart';

import '../controllers/lesson_plan_generation_details_controller.dart';

/// A binding class for the LessonPlanGenerationDetails screen.
///
/// This class sets up the necessary dependencies for the
/// [LessonPlanGenerationDetailsController], making it available for dependency injection.
class LessonPlanGenerationDetailsBinding extends Bindings {
  /// Sets up the dependencies for the LessonPlanGenerationDetails screen.
  @override
  void dependencies() {
    Get.lazyPut<LessonPlanGenerationDetailsController>(
      () => LessonPlanGenerationDetailsController(),
    );
  }
}
