import 'package:sikshana/app/modules/chatbot/views/widgets/sample_instructions_dialog.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget representing the input field for chatbot messages specific to lessons.
///
/// This widget provides a text input field, a voice input button,
/// a send message button, and displays information about daily chat limits.
class LessonMessageInputField extends GetView<LessonChatbotController> {
  /// Creates a new [LessonMessageInputField].
  const LessonMessageInputField({super.key});

  /// Builds the suffix icon for the message input field.
  ///
  /// This icon dynamically changes between a recording animation (when voice
  /// input is active) and a microphone icon (when voice input is inactive).
  /// Tapping the icon toggles the voice message recording.
  ///
  /// Returns a [Widget] representing the suffix icon.
  Widget suffixIcon() => GestureDetector(
    onTap: SpeechToTextRepo.isListening()
        ? controller.stopVoiceMessage
        : controller.startVoiceMessage,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: SpeechToTextRepo.isListening()
          ? Lottie.asset(AppImages.recording, height: 24.h, width: 24.w)
          : SvgPicture.asset(height: 20.h, width: 20.w, AppImages.sound),
    ),
  );

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: controller.focusNode,
          builder: (BuildContext context, Widget? child) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: controller.focusNode.hasFocus
                    ? AppColors.k46A0F1.withOpacity(0.8)
                    : AppColors.kE0E0E0,
              ),
            ),
            padding: EdgeInsets.only(left: 18.w),
            child: child,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  focusNode: controller.focusNode,
                  controller: controller.messageController,
                  onTapOutside: (PointerDownEvent event) {
                    FocusScope.of(context).unfocus();
                  },
                  style: AppTextStyle.lato(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: '${LocaleKeys.askAnything.tr}...',
                    hintStyle: AppTextStyle.lato(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.k9095A0,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Obx(() => suffixIcon()),
                  Obx(
                    () => controller.isSending.value
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : Transform.rotate(
                            angle: 0.82,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                AppImages.sendSolid,
                                height: 24.h,
                                width: 24.h,
                              ),
                              onPressed: () {
                                controller.sendChatMessage();
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
        15.verticalSpace,
        RichText(
          text: TextSpan(
            text: LocaleKeys.dailyChatLimit20Messages.tr,
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: AppColors.k72767C,
            ),
            children: <InlineSpan>[
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(
                      const SampleInstructionsDialog(),
                      barrierDismissible: false,
                    );
                  },
                  child: Text(
                    ' Sample Instructions',
                    style: AppTextStyle.lato(
                      color: AppColors.kFFC11E,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.kFFC11E,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        8.verticalSpace,
      ],
    ),
  );
}
