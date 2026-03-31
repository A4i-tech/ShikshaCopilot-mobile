import 'package:sikshana/app/modules/lesson_chatbot/models/lesson_chatbot_model.dart';
import 'package:sikshana/app/modules/lesson_chatbot/repository/lesson_chatbot_api_repo.dart';
import 'package:sikshana/app/utils/exports.dart';

/// The controller for the lesson chatbot feature.
///
/// This controller manages the state and business logic for the lesson chatbot,
/// including fetching messages, sending messages, and handling user input.
class LessonChatbotController extends GetxController {
  final LessonChatbotApiRepo _chatbotApiRepo = LessonChatbotApiRepo();

  /// Indicates whether the chat messages are currently being loaded.
  final RxBool isLoading = false.obs;

  /// Indicates whether a message is currently being sent.
  final RxBool isSending = false.obs;

  /// The model that holds the chatbot messages and related data.
  final Rx<LessonChatbotModel> chatbotModel = LessonChatbotModel().obs;

  /// The text editing controller for the message input field.
  final TextEditingController messageController = TextEditingController();

  /// The scroll controller for the chat message list.
  final ScrollController scrollController = ScrollController();

  /// A global key for the last widget in the list, used for scrolling.
  final GlobalKey lastWidgetKey = GlobalKey();

  /// The focus node for the message input field.
  final FocusNode focusNode = FocusNode();

  /// The ID of the current lesson.
  String? lessonId;

  /// The ID of the current chapter.
  String? chapterId;

  @override
  void onInit() {
    final arg = Get.arguments;
    if (arg?['lessonId'] != null) {
      lessonId = arg['lessonId'];
    }
    if (arg?['chapterId'] != null) {
      chapterId = arg['chapterId'];
    }
    super.onInit();
    stopVoiceMessage();
    getChatMessages();
  }

  /// Fetches the chat messages for the current lesson and chapter.
  ///
  /// The [sending] parameter determines whether to show a sending indicator
  /// or a full-page loader.
  Future<void> getChatMessages({bool sending = false}) async {
    if (sending) {
      isSending.value = true;
    } else {
      Loader.show();
      isLoading.value = true;
    }
    try {
      final LessonChatbotModel? response = await _chatbotApiRepo
          .getChatMessages(lessonId: lessonId!, chapterId: chapterId!);
      if (response != null) {
        chatbotModel
          ..value = response
          ..refresh();
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (sending) {
        isSending.value = false;
      } else {
        isLoading.value = false;
        Loader.dismiss();
      }
      scrollDown();
    }
  }

  /// Scrolls the chat view to the last message.
  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context = lastWidgetKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Sends a chat message to the server.
  Future<void> sendChatMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }
    focusNode.unfocus();
    scrollDown();
    isSending.value = true;
    try {
      final String? response = await _chatbotApiRepo.sendChatMessage(
        messageController.text,
        lessonId: lessonId!,
        chapterId: chapterId!,
      );
      if (response != null) {
        messageController.clear();
        await getChatMessages(sending: true);
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      isSending.value = false;
    }
  }

  /// Starts the voice-to-text functionality.
  Future<void> startVoiceMessage() async {
    if (SpeechToTextRepo.isListening.value) {
      await SpeechToTextRepo.stop();
      return;
    }

    try {
      await SpeechToTextRepo.start(
        onSpeech: (String speechText) {
          messageController.text = speechText;
          debugPrint(speechText);
        },
      );
    } catch (e) {
      appSnackBar(
        message: 'Voice Message unavailable',
        state: SnackBarState.warning,
      );
    }
  }

  /// Stops the voice-to-text functionality.
  Future<void> stopVoiceMessage() async {
    if (SpeechToTextRepo.isListening()) {
      await SpeechToTextRepo.stop();
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    SpeechToTextRepo.reset();
    super.onClose();
  }
}
