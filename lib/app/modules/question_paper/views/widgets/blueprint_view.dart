import 'package:sikshana/app/modules/question_paper/controllers/question_paper_controller.dart';
import 'package:sikshana/app/modules/question_paper/views/widgets/blueprint_chart.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A view that displays the blueprint for a question paper.
class BlueprintView extends GetView<QuestionPaperController> {
  /// Constructs a [BlueprintView].
  const BlueprintView({super.key});

  @override
  /// Builds the UI for the blueprint view.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the blueprint UI, including a chart and a
  /// detailed breakdown of the question distribution.
  Widget build(BuildContext context) => Scrollbar(
    controller: controller.blueprintScrollController,
    thickness: 10,
    interactive: true,
    radius: Radius.circular(10.r),
    child: SingleChildScrollView(
      controller: controller.blueprintScrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Step 3/3: ${LocaleKeys.bluePrint.tr}',
            style: AppTextStyle.lato(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          12.verticalSpace,
          Text(
            LocaleKeys.reviewBluePrint.tr,
            style: AppTextStyle.lato(
              fontSize: 12.sp,
              color: AppColors.k141522.withOpacity(0.45),
            ),
          ),
          10.verticalSpace,
          const BlueprintChart(),
          30.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: AppColors.kFEF6F1,
              borderRadius: BorderRadius.circular(8).r,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.info_outline_rounded,
                  size: 24.h,
                  color: AppColors.kED7D2D,
                ),
                6.horizontalSpace,
                Expanded(
                  child: Text(
                    LocaleKeys.copilotHasGeneratedTheOptimalDistribution.tr,
                    style: AppTextStyle.lato(fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),
          FormBuilder(
            key: controller.blueprintFormKey,
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.questionBluePrint.length,
                itemBuilder: (BuildContext context, int index) {
                  final String type =
                      questionTypes.keys.toList().firstWhereOrNull(
                        (String element) =>
                            questionTypes[element] ==
                            controller.questionBluePrint[index].type,
                      ) ??
                      controller.questionBluePrint[index].type ??
                      '';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              '${index + 1}. $type',
                              style: AppTextStyle.lato(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${controller.questionBluePrint[index].numberOfQuestions}'
                              'x${controller.questionBluePrint[index].marksPerQuestion}'
                              '=${(controller.questionBluePrint[index].numberOfQuestions ?? 1) * (controller.questionBluePrint[index].marksPerQuestion ?? 1)}',
                              style: AppTextStyle.lato(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            controller
                                .questionBluePrint[index]
                                .questionDistribution
                                ?.length ??
                            0,
                        itemBuilder: (BuildContext context, int i) => Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 28.h,
                            horizontal: 24.w,
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.k000000.withOpacity(0.1),
                            ),
                            borderRadius: BorderRadius.circular(10).r,
                          ),
                          child: Column(
                            children: <Widget>[
                              ProfileMultiSelectDropdown(
                                label: '${LocaleKeys.topic.tr}',
                                name: 'topic_${index}_$i',
                                labelStyle: AppTextStyle.lato(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  color: AppColors.k424955,
                                ),
                                validator: (List<String>? value) =>
                                    value?.isEmpty ?? true
                                    ? '${LocaleKeys.topic.tr} '
                                          '${LocaleKeys.required.tr}'
                                    : null,
                                items: controller.blueprintUnitNames,
                                hintText: '${LocaleKeys.topic.tr}',
                                onChanged: (List<String>? value) {
                                  if (!(value?.isEmpty ?? true)) {
                                    controller
                                        .questionBluePrint[index]
                                        .questionDistribution![i] = controller
                                        .questionBluePrint[index]
                                        .questionDistribution![i]
                                        .copyWith(unitName: value!.first);
                                    controller.questionBluePrint.refresh();
                                  }
                                },
                              ),
                              16.verticalSpace,
                              ProfileMultiSelectDropdown(
                                label: '${LocaleKeys.objectives.tr}',
                                name: 'objective_${index}_$i',
                                labelStyle: AppTextStyle.lato(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  color: AppColors.k424955,
                                ),
                                validator: (List<String>? value) =>
                                    value?.isEmpty ?? true
                                    ? '${LocaleKeys.objectives.tr} '
                                          '${LocaleKeys.required.tr}'
                                    : null,
                                items: controller.blueprintObjectives,
                                hintText: '${LocaleKeys.objectives.tr}',
                                onChanged: (List<String>? value) {
                                  if (!(value?.isEmpty ?? true)) {
                                    controller
                                        .questionBluePrint[index]
                                        .questionDistribution![i] = controller
                                        .questionBluePrint[index]
                                        .questionDistribution![i]
                                        .copyWith(objective: value!.first);
                                    controller.questionBluePrint.refresh();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
