import 'package:sikshana/app/utils/exports.dart';

class LessonResourceFeedbackSection
    extends GetView<LessonResourceGeneratedViewController> {
  const LessonResourceFeedbackSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(() {
    final bool isFeedbackPresent =
        controller.lessonResource.value?.data.feedback != null;

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.kFFFFFF,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.kDEE1E6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.lessonResourceFeedback.tr,
                    style: AppTextStyle.lato(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.k344767,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      controller.showResourceFeedbackSection.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.k6C7278,
                    ),
                    onPressed: controller.toggleResourceFeedbackSection,
                  ),
                ],
              ),
              if (controller.showResourceFeedbackSection.value) ...[
                24.verticalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: LocaleKeys.notMeet.tr,
                      groupValue: controller.feedbackRadioValue.value,
                      onChanged: isFeedbackPresent
                          ? null
                          : (String? v) =>
                                controller.feedbackRadioValue.value = v!,
                      enabled: !isFeedbackPresent,
                      title: Text(
                        LocaleKeys.notMeet.tr,
                        style: AppTextStyle.lato(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.k171A1F,
                        ),
                      ),
                    ),
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: LocaleKeys.improvementNeeded.tr,
                      groupValue: controller.feedbackRadioValue.value,
                      onChanged: isFeedbackPresent
                          ? null
                          : (String? v) =>
                                controller.feedbackRadioValue.value = v!,
                      enabled: !isFeedbackPresent,
                      title: Text(
                        LocaleKeys.improvementNeeded.tr,
                        style: AppTextStyle.lato(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.k171A1F,
                        ),
                      ),
                    ),
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: LocaleKeys.veryGood.tr,
                      groupValue: controller.feedbackRadioValue.value,
                      onChanged: isFeedbackPresent
                          ? null
                          : (String? v) =>
                                controller.feedbackRadioValue.value = v!,
                      enabled: !isFeedbackPresent,
                      title: Text(
                        LocaleKeys.veryGood.tr,
                        style: AppTextStyle.lato(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.k171A1F,
                        ),
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
                TextFormField(
                  controller: controller.feedbackCommentController,
                  minLines: 2,
                  maxLines: 5,
                  enabled: !isFeedbackPresent,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.leaveCommentsHint.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.kDEE1E6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                  style: AppTextStyle.lato(fontSize: 16.sp),
                ),
                24.verticalSpace,
              ],
            ],
          ),
        ),
        24.verticalSpace,
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: controller.saveResourcePlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.k46A0F1,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  LocaleKeys.saveResourcePlan.tr,
                  style: AppTextStyle.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: AppColors.kFFFFFF,
                  ),
                ),
              ),
            ),
          ],
        ),
        24.verticalSpace,
      ],
    );
  });
}
