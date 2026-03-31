import 'package:sikshana/app/modules/chatbot/models/chatbot_model.dart';
import 'package:sikshana/app/modules/chatbot/repository/chatbot_api_repo.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A controller for managing the chatbot's state and interactions.
///
/// This controller handles fetching chat messages, sending new messages,
/// managing loading states, and voice input functionality.
class ChatbotController extends GetxController {
  final ChatbotApiRepo _chatbotApiRepo = ChatbotApiRepo();

  /// Reactive boolean indicating if chat messages are currently loading.
  final RxBool isLoading = false.obs;

  /// Reactive boolean indicating if a message is currently being sent.
  final RxBool isSending = false.obs;

  /// Reactive object holding the chatbot's message data.
  final Rx<ChatbotModel> chatbotModel = ChatbotModel().obs;

  /// Controller for the message input text field.
  final TextEditingController messageController = TextEditingController();

  /// Controller for scrolling the chat view.
  final ScrollController scrollController = ScrollController();

  /// Global key to identify the last widget in the chat list, used for scrolling.
  final GlobalKey lastWidgetKey = GlobalKey();

  /// Focus node for the message input text field.
  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    stopVoiceMessage();
    getChatMessages();
  }

  /// Fetches chat messages from the API.
  ///
  /// If [sending] is true, it indicates that a message is being sent,
  /// and only the `isSending` state will be affected. Otherwise, a
  /// full loader will be shown.
  /// After fetching, it calls [scrollDown] to show the latest messages.
  ///
  /// Returns `Future<void>`.
  Future<void> getChatMessages({bool sending = false}) async {
    if (sending) {
      isSending.value = true;
    } else {
      Loader.show();
      isLoading.value = true;
    }
    try {
      final ChatbotModel? response = await _chatbotApiRepo.getChatMessages();
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

  /// Scrolls the chat view down to the last message.
  ///
  /// This method ensures that the most recent message is visible to the user.
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

  /// Sends a chat message to the API.
  ///
  /// If the message input is empty, the method returns without sending.
  /// It unfocuses the input field, scrolls down, sets `isSending` to true,
  /// and attempts to send the message via `_chatbotApiRepo`.
  /// On success, it clears the message input and refreshes chat messages.
  /// Finally, `isSending` is set to false.
  ///
  /// Returns `Future<void>`.
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

  /// Starts voice message input.
  ///
  /// If currently listening, it stops the previous session.
  /// Otherwise, it initiates speech-to-text recognition.
  /// Detected speech is updated in the message input field.
  ///
  /// Returns `Future<void>`.
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

  /// Stops voice message input.
  ///
  /// If speech recognition is active, it stops the listening process.
  ///
  /// Returns `Future<void>`.
  Future<void> stopVoiceMessage() async {
    if (SpeechToTextRepo.isListening.value) {
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
