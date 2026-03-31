import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the learning outcome section.
class LearningOutcomeSection
    extends GetView<LessonPlanGenerationDetailsController> {
  /// Creates a [LearningOutcomeSection] object.
  const LearningOutcomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          SvgPicture.asset(
            AppImages.learningOutcomes,
            height: 24.h,
            width: 24.h,
          ),
          12.horizontalSpace,
          Text(
            LocaleKeys.learningOutcomes.tr,
            style: AppTextStyle.lato(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.k141522,
            ),
          ),
        ],
      ),

      12.verticalSpace,

      const LearningOutcomeEditableSection(),
      12.verticalSpace,
      const IncludeVideosCheckboxSection(),
    ],
  );
}
