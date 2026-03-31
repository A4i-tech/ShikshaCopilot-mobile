import 'package:sikshana/app/modules/lesson_resource_generation_details/views/widgets/learning_outcome_resource_editable_section.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the learning outcomes section.
///
/// This widget shows a title and an editable text field for the learning outcomes.
class LearningOutcomeResourceSection
    extends GetView<LessonResourceGenerationDetailsController> {
  /// Creates a [LearningOutcomeResourceSection] widget.
  const LearningOutcomeResourceSection({Key? key}) : super(key: key);

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

      const LearningOutcomeResourceEditableSection(),
      // 12.verticalSpace,
      // const IncludeVideosCheckboxSection(),
    ],
  );
}
