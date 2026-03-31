import 'package:get/get.dart';

import '../controllers/chatbot_controller.dart';

/// A binding class for the Chatbot screen.
///
/// This class sets up the dependencies required for the Chatbot screen,
/// primarily the [ChatbotController].
class ChatbotBinding extends Bindings {
  /// Sets up the dependencies for the Chatbot screen.
  ///
  /// This method uses [Get.lazyPut] to lazily initialize the
  /// [ChatbotController], which means the controller will only be
  /// created when it is first needed.
  @override
  void dependencies() {
    Get.lazyPut<ChatbotController>(() => ChatbotController());
  }
}
