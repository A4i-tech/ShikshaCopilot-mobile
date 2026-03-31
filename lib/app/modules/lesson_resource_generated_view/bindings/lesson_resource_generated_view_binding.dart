import 'package:get/get.dart';

import '../controllers/lesson_resource_generated_view_controller.dart';

/// Binding for the LessonResourceGeneratedView.
///
/// This binding is responsible for creating and initializing the
/// [LessonResourceGeneratedViewController].
class LessonResourceGeneratedViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonResourceGeneratedViewController>(
      () => LessonResourceGeneratedViewController(),
    );
  }
}