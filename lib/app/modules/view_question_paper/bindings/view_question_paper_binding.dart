import 'package:get/get.dart';

import '../controllers/view_question_paper_controller.dart';

/// A binding for the ViewQuestionPaper module.
class ViewQuestionPaperBinding extends Bindings {
  @override
  /// Initializes the [ViewQuestionPaperController] as a lazy put dependency.
  void dependencies() {
    Get.lazyPut<ViewQuestionPaperController>(
      () => ViewQuestionPaperController(),
    );
  }
}
