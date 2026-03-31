import 'package:sikshana/app/utils/exports.dart';

class LessonSummaryTabView extends GetView<LessonPlanGeneratedViewController> {
  const LessonSummaryTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: lessonSummarySectionFromChecklist(),
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

        /// Reactively rebuild when underlying data changes.
        Obx(() {
          Map<String, dynamic>? checklist;

          // VIEW MODE: Extract saved checklist
          if (fromPage == FromPage.view) {
            final section = controller.lessonPlan.value?.data?.sections
                ?.firstWhereOrNull((s) => s.id == "section_checklist");
            checklist = section?.content as Map<String, dynamic>?;
          }
          // GENERATE MODE: Extract generated checklist
          else if (fromPage == FromPage.generate) {
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

          // No checklist available → hide section
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
          /// Header Row
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

          /// Row for each 5E phase
          ...phaseKeys.where((k) => checklist[k] != null).map((phase) {
            final entry = checklist[phase] as Map<String, dynamic>;

            return TableRow(
              children: [
                /// Phase Name
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(phase.toUpperCase()),
                ),

                /// Classroom Process
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(entry["activity"] ?? ''),
                ),

                /// TLM
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(entry["materials"] ?? ''),
                ),

                /// Techniques
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

  Widget _buildChecklistItem(String title, bool isCompleted) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 2, right: 12),
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.k46A0F1 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : null,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.k323232,
                ),
              ),
              if (!isCompleted)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'This section needs attention',
                    style: AppTextStyle.lato(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
