import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/real_world_scenario_editable.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/real_world_scenario_non_editable.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the real-world scenarios section of a lesson resource.
class RealWorldScenariosSection
    extends GetView<LessonResourceGeneratedViewController> {
  /// The section data for the real-world scenarios.
  final dynamic
  section; // Should be the resource section with outputFormat 'json_2'

  /// Creates a [RealWorldScenariosSection].
  const RealWorldScenariosSection({Key? key, required this.section})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = section?.content as List<dynamic>? ?? [];
    const Map<String, String> difficultyLabels = <String, String>{
      'beginner': LocaleKeys.beginner,
      'intermediate': LocaleKeys.intermediate,
      'advanced': LocaleKeys.advanced,
    };

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kFFFFFF,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.kDEE1E6, width: 1.3),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 18),
        child: Obx(() {
          final bool isEditable = controller.isRealWorldEdit.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader(
                LocaleKeys.realWorldScenarios.tr,
                onEditTap: () => controller.isRealWorldEdit.value =
                    !controller.isRealWorldEdit.value,
              ),
              18.verticalSpace,
              ...content.map((difficulty) {
                final diffValue = difficulty?.difficulty;
                final label = diffValue != null
                    ? (difficultyLabels[diffValue] ?? diffValue)
                    : '';
                final List<dynamic>? scenarios =
                    difficulty?.content as List<dynamic>?;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label.toString().tr,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.k424955,
                        ),
                      ),
                      6.verticalSpace,
                      if (scenarios == null || scenarios.isEmpty)
                        Text(
                          LocaleKeys.noDataAvailable.tr,
                          style: AppTextStyle.lato(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.k424955,
                          ),
                        )
                      else
                        ...scenarios.asMap().entries.map((entry) {
                          final scenario = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 9),
                            child: isEditable
                                ? RealWorldScenarioEditable(
                                    title: scenario?.title ?? '',
                                    question: scenario?.question ?? '',
                                    description: scenario?.description ?? '',
                                    onTitleChanged: (val) =>
                                        scenario?.title = val,
                                    onQuestionChanged: (val) =>
                                        scenario?.question = val,
                                    onDescriptionChanged: (val) =>
                                        scenario?.description = val,
                                  )
                                : RealWorldScenarioNonEditable(
                                    title: scenario?.title ?? '',
                                    question: scenario?.question ?? '',
                                    description: scenario?.description ?? '',
                                  ),
                          );
                        }).toList(),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        }),
      ),
    );
  }

  /// A widget that displays a section header with an optional edit button.
  Widget sectionHeader(String title, {VoidCallback? onEditTap}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Flexible(
        // ✅ Prevents overflow, allows multiline
        child: Text(
          title,
          style: AppTextStyle.lato(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.k46A0F1,
          ),
          maxLines: 6, // ✅ Optional: limit to 2 lines
          overflow: TextOverflow.ellipsis, // ✅ Ellipsis if still too long
          textAlign: TextAlign.start,
        ),
      ),
      GestureDetector(
        onTap: onEditTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.kFFFFFF,
            border: Border.all(color: AppColors.kEBEBEB, width: 1.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: <Widget>[
              Text(
                LocaleKeys.edit.tr,
                style: AppTextStyle.lato(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.k46A0F1,
                ),
              ),
              4.horizontalSpace,
              SvgPicture.asset(AppImages.icEditBlue, width: 12, height: 12),
            ],
          ),
        ),
      ),
    ],
  );
}
