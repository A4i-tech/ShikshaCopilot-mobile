import 'package:get/get.dart';

import '../controllers/question_paper_generation_controller.dart';

/// A binding for the QuestionPaperGeneration module.
class QuestionPaperGenerationBinding extends Bindings {
  @override
  /// Initializes the [QuestionPaperGenerationController] as a lazy put dependency.
  void dependencies() {
    Get.lazyPut<QuestionPaperGenerationController>(
      () => QuestionPaperGenerationController(),
    );
  }
}
