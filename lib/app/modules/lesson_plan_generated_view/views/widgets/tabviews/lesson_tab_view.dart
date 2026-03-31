import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/lesson_plan_feedback_section.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/lesson_plan_section_tabs.dart';
import 'package:sikshana/app/utils/exports.dart';

class LessonTabView extends GetView<LessonPlanGeneratedViewController> {
  const LessonTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: Obx(
      () => FloatingActionButton.extended(
        onPressed: controller.toggleFeedbackSection,
        icon: Icon(
          controller.showFeedbackSection.value
              ? Icons.feedback_outlined
              : Icons.feedback,
          color: Colors.white,
        ),
        label: Text(
          controller.showFeedbackSection.value
              ? 'Hide Feedback'
              : 'Show Feedback',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: controller.showFeedbackSection.value
            ? Colors.green
            : AppColors.k46A0F1,
      ),
    ),

    // Single scroll for whole page + bottom padding for FAB
    body: Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            24.verticalSpace,
            learningOutcomeSection(),
            24.verticalSpace,

            // Bounded height for tabs; inner widget manages its own scrolling
            SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              child: const LessonPlanSectionTabs(),
            ),

            24.verticalSpace,
            const LessonPlanFeedbackSection(),
            24.verticalSpace,
          ],
        ),
      ),
    ),
  );

  Widget lessonSummarySectionFromChecklist() {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    LessonPlanGenerationDetailsController? generationDetailsController;
    if (fromPage == FromPage.generate) {
      generationDetailsController =
          Get.find<LessonPlanGenerationDetailsController>();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.lessonSummary.tr,
          style: AppTextStyle.lato(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.k46A0F1,
          ),
        ),
        16.verticalSpace,
        Obx(() {
          Map<String, dynamic>? checklist;

          if (fromPage == FromPage.view) {
            final section = controller.lessonPlan.value?.data?.sections
                ?.firstWhereOrNull((s) => s.id == "section_checklist");
            checklist = section?.content as Map<String, dynamic>?;
          } else if (fromPage == FromPage.generate) {
            final generatedData = generationDetailsController
                ?.generatedLessonResponse
                .value
                ?.data
                ?.first;

            final sections = generatedData?.sections;
            if (sections != null) {
              final checklistSection = sections.firstWhereOrNull(
                (s) => s.id == "section_checklist",
              );
              checklist = checklistSection?.content as Map<String, dynamic>?;
            }
          }

          if (checklist == null) {
            return const SizedBox.shrink();
          }

          return _buildChecklistTable(checklist);
        }),
      ],
    );
  }

  Widget _buildChecklistTable(Map<String, dynamic> checklist) {
    final phaseKeys = checklist.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: FixedColumnWidth(280),
          2: FixedColumnWidth(180),
          3: FixedColumnWidth(150),
        },
        border: TableBorder.all(color: AppColors.kDEE1E6),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.kDEE1E6.withOpacity(0.2),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  LocaleKeys.phase.tr,
                  style: AppTextStyle.lato(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  LocaleKeys.classroomProcess.tr,
                  style: AppTextStyle.lato(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  LocaleKeys.tlm.tr,
                  style: AppTextStyle.lato(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  LocaleKeys.cceToolsAndTechniques.tr,
                  style: AppTextStyle.lato(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          ...phaseKeys.where((k) => checklist[k] != null).map((phase) {
            final entry = checklist[phase] as Map<String, dynamic>;

            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(phase.toUpperCase()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(entry["activity"] ?? ''),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(entry["materials"] ?? ''),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Observation."),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget learningOutcomeSection() {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    LessonPlanGenerationDetailsController? generationDetailsController;
    if (fromPage == FromPage.generate) {
      generationDetailsController =
          Get.find<LessonPlanGenerationDetailsController>();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.kFFFFFF,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kDEE1E6, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: controller.toggleLearningOutcomeExpanded,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.kFFFFFF,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    LocaleKeys.learningOutcomes.tr,
                    style: AppTextStyle.lato(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.k171A1F,
                    ),
                  ),
                  Obx(
                    () => AnimatedRotation(
                      turns: controller.isLearningOutcomeExpanded.value
                          ? 0.5
                          : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.k171A1F,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            curve: Curves.easeIn,
            reverseDuration: const Duration(milliseconds: 200),
            child: Obx(
              () => controller.isLearningOutcomeExpanded.value
                  ? Column(
                      children: [
                        const Divider(
                          height: 1,
                          thickness: 1.2,
                          color: AppColors.kEBEBEB,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                          child: _buildOutcomesContent(
                            fromPage,
                            generationDetailsController,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutcomesContent(
    FromPage fromPage,
    LessonPlanGenerationDetailsController? generationDetailsController,
  ) {
    List<String> outcomes = [];

    if (fromPage == FromPage.view) {
      outcomes = controller.learningOutcomes;
    } else if (fromPage == FromPage.generate) {
      outcomes =
          generationDetailsController
              ?.generatedLessonResponse
              .value
              ?.data
              ?.first
              .learningOutcomes ??
          [];
    }

    if (outcomes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: outcomes
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(fontSize: 16.sp, color: AppColors.k141522),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyle.lato(
                        fontSize: 16.sp,
                        color: AppColors.k141522,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Container sectionContent(String sectionId, String title) {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    LessonPlanGenerationDetailsController? generationDetailsController;

    if (fromPage == FromPage.generate) {
      generationDetailsController =
          Get.find<LessonPlanGenerationDetailsController>();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.kFFFFFF,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kDEE1E6, width: 1.3),
      ),
      padding: const EdgeInsets.all(20),
      child: Obx(() {
        String content = '';

        if (fromPage == FromPage.view) {
          final sections = controller.lessonPlan.value?.data?.sections ?? [];
          var section = sections.firstWhereOrNull((s) => s.id == sectionId);
          if (section == null) {
            section = sections.firstWhereOrNull(
              (s) => s.id == "section_$sectionId",
            );
          }
          content = section?.content ?? '';
        } else if (fromPage == FromPage.generate) {
          final generatedData = generationDetailsController
              ?.generatedLessonResponse
              .value
              ?.data
              ?.first;
          final sections = generatedData?.sections ?? [];
          var section = sections.firstWhereOrNull((s) => s.id == sectionId);
          if (section == null) {
            section = sections.firstWhereOrNull(
              (s) => s.id == "section_$sectionId",
            );
          }
          content = section?.content ?? '';
        }

        if (content.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.lato(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.k46A0F1,
              ),
            ),
            16.verticalSpace,
            MarkdownBody(
              data: content,
              styleSheet: MarkdownStyleSheet(
                p: AppTextStyle.lato(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.k141522,
                ),
                strong: AppTextStyle.lato(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget plainTextContents() {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    LessonPlanGenerationDetailsController? generationDetailsController;

    if (fromPage == FromPage.generate) {
      generationDetailsController =
          Get.find<LessonPlanGenerationDetailsController>();
    }

    return Obx(() {
      List sections = [];

      if (fromPage == FromPage.view) {
        sections = controller.lessonPlan.value?.data?.sections ?? [];
      } else if (fromPage == FromPage.generate) {
        sections =
            generationDetailsController
                ?.generatedLessonResponse
                .value
                ?.data
                ?.first
                ?.sections ??
            [];
      }

      final plainTextSections = sections
          .where(
            (section) =>
                section.outputFormat == 'plain_text' &&
                section?.content != null,
          )
          .toList();

      if (plainTextSections.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: plainTextSections
            .map<Widget>(
              (section) => Container(
                key: ValueKey(section?.id),
                decoration: BoxDecoration(
                  color: AppColors.kFFFFFF,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.kDEE1E6, width: 1.3),
                ),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section?.title ?? '',
                      style: AppTextStyle.lato(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.k46A0F1,
                      ),
                    ),
                    16.verticalSpace,
                    Text(
                      section?.content ?? '',
                      style: AppTextStyle.lato(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.k141522,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );
    });
  }
}
