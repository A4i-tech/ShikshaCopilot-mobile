import 'package:sikshana/app/modules/view_question_paper/controllers/view_question_paper_controller.dart';
import 'package:sikshana/app/ui/widgets/custom_radio_group.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that allows users to submit feedback for the displayed question paper.
class FeedbackSection extends GetView<ViewQuestionPaperController> {
  /// Constructs a [FeedbackSection].
  const FeedbackSection({super.key});

  @override
  /// Builds the UI for the feedback section.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying feedback options and a text field for comments.
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(22.w),
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.kDEE1E6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          LocaleKeys.questionPaperFeedback.tr,
          style: AppTextStyle.lato(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        6.verticalSpace,
        Text(
          LocaleKeys
              .doYouFeelThatTheQuestionsInThisPaperAreRelevantToYourSpecifiedConfigurationAndRequirements
              .tr,
          style: AppTextStyle.lato(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        12.verticalSpace,
        Obx(
          () => CustomRadioGroup(
            isVertical: true,
            enabled:
                controller
                    .questionBankModel
                    .value
                    ?.data
                    ?.questionBank
                    ?.feedback ==
                null,
            options: const <String>[
              LocaleKeys.stronglyDisagree,
              LocaleKeys.disagree,
              LocaleKeys.neutral,
              LocaleKeys.agree,
              LocaleKeys.stronglyAgree,
            ],
            optionTitles: <String>[
              '${LocaleKeys.stronglyDisagree.tr} 😠',
              '${LocaleKeys.disagree.tr} 😞',
              '${LocaleKeys.neutral.tr} 😐',
              '${LocaleKeys.agree.tr} 😊',
              '${LocaleKeys.stronglyAgree.tr} 😄',
            ],
            selectedValue: controller.selectedOption.value,
            textStyle: AppTextStyle.lato(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            onChanged: (String value) {
              controller.selectedOption.value = value;
            },
          ),
        ),
        16.verticalSpace,
        TextFormField(
          controller: controller.feedbackController,
          enabled:
              controller
                  .questionBankModel
                  .value
                  ?.data
                  ?.questionBank
                  ?.feedback ==
              null,
          maxLines: 3,
          onTapOutside: (PointerDownEvent event) {
            FocusScope.of(context).unfocus();
          },
          style: AppTextStyle.lato(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: AppColors.k72767C,
          ),
          decoration: InputDecoration(
            hintText: LocaleKeys.leaveCommentsHint.tr,
            hintStyle: AppTextStyle.lato(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: AppColors.k72767C,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.k9095A0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.k9095A0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.k9095A0),
            ),
          ),
        ),
        16.verticalSpace,
        if (controller.questionBankModel.value?.data?.questionBank?.feedback ==
            null)
          AppButton(
            onPressed: controller.submitFeedback,
            buttonText: LocaleKeys.submitFeedback.tr,
          ),
      ],
    ),
  );
}
