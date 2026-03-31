import 'package:sikshana/app/modules/question_paper/models/question_bank_model.dart';
import 'package:sikshana/app/modules/view_question_paper/repository/view_question_paper_api_repo.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Controller for the view question paper screen.
class ViewQuestionPaperController extends GetxController {
  /// Reactive string to hold the question paper ID.
  final RxString qpId = ''.obs;

  /// Repository for question paper API calls.
  final ViewQpApiRepo _viewQpApiRepo = ViewQpApiRepo();

  /// Reactive object to hold the fetched question bank model.
  final Rx<QuestionBankModel?> questionBankModel = Rx<QuestionBankModel?>(null);

  /// Text editing controller for the feedback text field.
  final TextEditingController feedbackController = TextEditingController();

  /// Reactive string to hold the selected feedback option.
  final RxString selectedOption = LocaleKeys.agree.obs;

  /// Scroll controller for the main scrollable view.
  final ScrollController scrollController = ScrollController();

  /// Scroll controller for the blueprint scrollable view.
  final ScrollController bluePrintScrollController = ScrollController();

  @override
  /// Called when the controller is initialized.
  /// Retrieves the question paper ID from arguments and fetches details.
  void onInit() {
    qpId.value = Get.arguments['id'] ?? '';
    getQuestionPaperDetails();
    super.onInit();
  }

  /// Converts an integer to its Roman numeral representation.
  ///
  /// Parameters:
  /// - `number`: The integer to convert (must be between 1 and 3999).
  ///
  /// Returns:
  /// A `String` representing the Roman numeral.
  ///
  /// Throws:
  /// `ArgumentError` if the number is out of the valid range.
  String toRoman(int number) {
    if (number < 1 || number > 3999) {
      throw ArgumentError('Value must be between 1 and 3999');
    }

    final Map<int, String> romanMap = <int, String>{
      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I',
    };

    final StringBuffer result = StringBuffer();
    int remaining = number;

    romanMap.forEach((int value, String symbol) {
      while (remaining >= value) {
        result.write(symbol);
        remaining -= value;
      }
    });

    return result.toString();
  }

  /// Fetches the details of the question paper by its ID.
  ///
  /// Parameters:
  /// - `fromFeedback`: A boolean indicating if the call is from feedback submission,
  ///   which triggers scrolling to the bottom.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the details are fetched.
  Future<void> getQuestionPaperDetails({bool fromFeedback = false}) async {
    try {
      Loader.show();
      questionBankModel.value = QuestionBankModel();
      final QuestionBankModel? response = await _viewQpApiRepo
          .getQuestionBankById(questionBankId: qpId.value);
      if (response != null) {
        questionBankModel.value = response;
        feedbackController.text =
            questionBankModel
                .value
                ?.data
                ?.questionBank
                ?.feedback
                ?.overallFeedback ??
            '';
        if (questionBankModel
                .value
                ?.data
                ?.questionBank
                ?.feedback
                ?.feedback
                ?.isNotEmpty ??
            false) {
          selectedOption.value = Locales.en.entries
              .firstWhere(
                (MapEntry<String, String> element) =>
                    element.value ==
                    questionBankModel
                        .value
                        ?.data
                        ?.questionBank
                        ?.feedback
                        ?.feedback,
              )
              .key;
        }
      }
      if (fromFeedback) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    } catch (e) {
      print('Error fetching question paper details: $e');
    } finally {
      Loader.dismiss();
    }
  }

  /// Submits the user's feedback for the current question paper.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the feedback is submitted.
  Future<void> submitFeedback() async {
    try {
      Loader.show();
      final bool success = await _viewQpApiRepo.submitFeedback(
        questionBankId: questionBankModel.value?.data?.questionBank?.id,
        question:
            Locales.en[LocaleKeys
                .doYouFeelThatTheQuestionsInThisPaperAreRelevantToYourSpecifiedConfigurationAndRequirements],
        feedback: Locales.en[selectedOption.value],
        overallFeedback: feedbackController.text,
      );
      if (success) {
        appSnackBar(
          message: 'Feedback submitted successfully',
          state: SnackBarState.success,
          type: SnackBarType.top,
        );
        await getQuestionPaperDetails(fromFeedback: true);
      } else {
        appSnackBar(
          message: 'Failed to submitted successfully',
          state: SnackBarState.danger,
          type: SnackBarType.top,
        );
      }
    } catch (e) {
      print('Error submitting feedback: $e');
    } finally {
      Loader.dismiss();
    }
  }

  @override
  /// Called when the controller is closed.
  /// Disposes the feedback text editing controller.
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
