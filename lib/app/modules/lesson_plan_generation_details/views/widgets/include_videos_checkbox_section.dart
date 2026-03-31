import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a checkbox section for including videos in the lesson plan.
class IncludeVideosCheckboxSection
    extends GetView<LessonPlanGenerationDetailsController> {
  /// Creates an [IncludeVideosCheckboxSection] object.
  const IncludeVideosCheckboxSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        LocaleKeys.includeVideos.tr,
        style: AppTextStyle.lato(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.k141522,
        ),
      ),
      8.verticalSpace,
      Obx(
        () => Row(
          children: <Widget>[
            Radio<bool>(
              value: true,
              groupValue: controller.includeVideos.value,
              onChanged: (bool? val) => controller.includeVideos.value = val!,
              activeColor: AppColors.k46A0F1,
            ),
            Text(
              LocaleKeys.yes.tr,
              style: AppTextStyle.lato(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.k141522,
              ),
            ),
            16.horizontalSpace,
            Radio<bool>(
              value: false,
              groupValue: controller.includeVideos.value,
              onChanged: (bool? val) => controller.includeVideos.value = val!,
              activeColor: AppColors.k46A0F1,
            ),
            Text(
              LocaleKeys.no.tr,
              style: AppTextStyle.lato(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.k141522,
              ),
            ),
          ],
        ),
      ),
      8.verticalSpace,
      SizedBox(
        width: 200.w,
        height: 35.h,
        child: Obx(() {
          final isEnabled =
              controller.isFormValid.value &&
              !controller.isLoadingGenerateLesson.value;
          if (!isEnabled) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  controller.isLoadingGenerateLesson.value
                      ? "Generating"
                      : "Complete all Fields", // Add this key: "Complete all fields"
                  style: AppTextStyle.lato(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ),
            );
          }
          return AppButton(
            buttonText: LocaleKeys.generateLessonPlan.tr,
            loader: controller.isLoadingGenerateLesson.value,
            style: AppTextStyle.lato(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.kFFFFFF,
            ),
            borderRadius: BorderRadius.circular(4),
            onPressed: controller.generateLesson,
          );
        }),
      ),
    ],
  );
}
