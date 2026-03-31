import 'package:sikshana/app/modules/chatbot/models/chatbot_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// The main view for the chatbot feature.
///
/// This view displays the chatbot interface, including a list of messages,
/// an input field for sending new messages, and an empty state message.
class ChatbotView extends GetView<ChatbotController> {
  /// Creates a new [ChatbotView].
  const ChatbotView({super.key});
  @override
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>()
          ..onReConnect = () {
            controller
              ..stopVoiceMessage()
              ..getChatMessages();
          };

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : Scaffold(
              key: scaffoldKey,
              body: RefreshIndicator(
                onRefresh: () async {
                  await controller.getChatMessages();
                },
                child: Obx(
                  () =>
                      (controller.chatbotModel().data?.messages?.isEmpty ??
                          true)
                      ? Column(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      '${LocaleKeys.hello.tr} '
                                      '${UserProvider.currentUser?.name ?? ''}',
                                      style: AppTextStyle.lato(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      LocaleKeys.howCanIHelpYou.tr,
                                      style: AppTextStyle.lato(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    20.verticalSpace,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.kEDF6FE,
                                        borderRadius: BorderRadius.circular(
                                          48,
                                        ).r,
                                      ),
                                      child: Text(
                                        LocaleKeys
                                            .helloIamHereToAssistYouJustTypeYourQuestionToGetStarted
                                            .tr,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.lato(
                                          color: AppColors.k46A0F1,
                                          fontSize: 10.sp,
                                        ),
                                      ).paddingSymmetric(horizontal: 20.w),
                                    ),
                                    100.verticalSpace,
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentGeometry.bottomLeft,
                              child: Obx(
                                () => controller.isSending.value
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 22.w,
                                          vertical: 4.h,
                                        ),
                                        child: ThreeDotsLoader(size: 24.dg),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                            const MessageInputField(),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                itemCount: controller
                                    .chatbotModel()
                                    .data!
                                    .messages!
                                    .length,
                                controller: controller.scrollController,
                                itemBuilder: (BuildContext context, int index) {
                                  final List<Message> messages = controller
                                      .chatbotModel()
                                      .data!
                                      .messages!
                                      .reversed
                                      .toList();
                                  final Message message = messages[index];
                                  return Column(
                                    key:
                                        (controller
                                                    .chatbotModel()
                                                    .data!
                                                    .messages!
                                                    .length -
                                                1) ==
                                            index
                                        ? controller.lastWidgetKey
                                        : null,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      24.verticalSpace,
                                      if (message.question != null &&
                                          message.question!.isNotEmpty)
                                        MessageBubble(
                                          text: message.question!,
                                          isUser: true,
                                        ),
                                      8.verticalSpace,
                                      if (message.answer != null &&
                                          message.answer!.isNotEmpty)
                                        MessageBubble(
                                          text: message.answer!,
                                          isUser: false,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Align(
                              alignment: AlignmentGeometry.bottomLeft,
                              child: Obx(
                                () => controller.isSending.value
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 22.w,
                                          vertical: 4.h,
                                        ),
                                        child: ThreeDotsLoader(size: 24.dg),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                            const MessageInputField(),
                          ],
                        ),
                ),
              ),
            ),
    );
  }
}
