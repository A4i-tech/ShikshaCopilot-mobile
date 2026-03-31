import 'package:get/get.dart';

import '../controllers/lesson_chatbot_controller.dart';

/// A binding class for the LessonChatbotView.
///
/// This class sets up the dependencies for the [LessonChatbotController].
class LessonChatbotBinding extends Bindings {
  /// Sets up the dependencies for the [LessonChatbotController].
  @override
  void dependencies() {
    Get.lazyPut<LessonChatbotController>(
      () => LessonChatbotController(),
    );
  }
}
