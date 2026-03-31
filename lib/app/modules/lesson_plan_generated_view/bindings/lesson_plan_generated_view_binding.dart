import 'package:get/get.dart';

import '../controllers/lesson_plan_generated_view_controller.dart';

/// A GetX [Bindings] class responsible for injecting the
/// dependencies required by the `LessonPlanGeneratedView`.
///
/// This binding ensures that the `LessonPlanGeneratedViewController`
/// is created lazily — meaning it will be instantiated only when it
/// is first used, optimizing memory usage.
class LessonPlanGeneratedViewBinding extends Bindings {
  /// Registers all required dependencies for the
  /// `LessonPlanGeneratedView` using GetX dependency injection.
  ///
  /// In this case, it lazily puts:
  /// - [LessonPlanGeneratedViewController]
  ///
  /// The controller will be created only once and reused as needed.
  @override
  void dependencies() {
    Get.lazyPut<LessonPlanGeneratedViewController>(
      () => LessonPlanGeneratedViewController(),
    );
  }
}
