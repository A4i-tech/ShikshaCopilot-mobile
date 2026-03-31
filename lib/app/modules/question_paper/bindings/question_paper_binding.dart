import 'package:get/get.dart';

import '../controllers/question_paper_controller.dart';

/// A binding for the QuestionPaper module.
class QuestionPaperBinding extends Bindings {
  @override
  /// Initializes the [QuestionPaperController] as a lazy put dependency.
  void dependencies() {
    Get.lazyPut<QuestionPaperController>(
      () => QuestionPaperController(),
    );
  }
}