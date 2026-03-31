import 'package:sikshana/app/modules/question_paper/controllers/question_paper_controller.dart';
import 'package:sikshana/app/modules/question_paper/models/question_bank_model.dart';
import 'package:sikshana/app/modules/view_question_paper/controllers/view_question_paper_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the blueprint of a question paper within an expandable tile.
class BlueprintSection extends GetView<ViewQuestionPaperController> {
  /// Constructs a [BlueprintSection].
  const BlueprintSection({super.key});

  @override
  /// Builds the UI for the blueprint section.
  ///
  /// Returns:
  /// A `Widget` displaying the blueprint table within an expandable tile.
  Widget build(BuildContext context) => Obx(() {
    final List<TableRow> rows = <TableRow>[];
    final List<BluePrintTemplate>? bluePrintTemplate =
        controller.questionBankModel.value?.data?.bluePrintTemplate;

    if (bluePrintTemplate != null) {
      for (final BluePrintTemplate template in bluePrintTemplate) {
        if (template.questionDistribution != null) {
          for (final dist in template.questionDistribution!) {
            rows.add(
              TableRow(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      dist.unitName ?? '',
                      style: AppTextStyle.lato(
                        color: AppColors.k303030,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      questionTypes.keys.toList().firstWhereOrNull(
                            (String element) =>
                                questionTypes[element] == template.type,
                          ) ??
                          template.type ??
                          '',
                      style: AppTextStyle.lato(
                        color: AppColors.k303030,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      dist.objective ?? '',
                      style: AppTextStyle.lato(
                        color: AppColors.k303030,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      template.marksPerQuestion.toString(),
                      style: AppTextStyle.lato(
                        color: AppColors.k303030,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      }
    }

    return controller.questionBankModel.value == null
        ? const SizedBox.shrink()
        : ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  scrollbarTheme: const ScrollbarThemeData(
                    thumbColor: WidgetStatePropertyAll<Color>(
                      AppColors.k46A0F1,
                    ),
                  ),
                  expansionTileTheme: ExpansionTileThemeData(
                    backgroundColor: AppColors.kFFFFFF,
                    iconColor: AppColors.k000000,
                    collapsedIconColor: AppColors.k000000,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: const BorderSide(color: AppColors.kEBEBEB),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: const BorderSide(color: AppColors.kEBEBEB),
                    ),
                  ),
                ),
                child: ExpansionTile(
                  title: Text(
                    LocaleKeys.clickHereToViewQuestionPaperBluePrint.tr,
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10.h),
                      decoration: const BoxDecoration(
                        color: AppColors.kFFFFFF,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Scrollbar(
                            thumbVisibility: true,
                            radius: Radius.circular(10.r),
                            controller: controller.bluePrintScrollController,
                            child: SingleChildScrollView(
                              controller: controller.bluePrintScrollController,
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: 600,
                                child: Table(
                                  border: TableBorder.all(
                                    color: AppColors.kEBEBEB,
                                  ),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: const <int, TableColumnWidth>{
                                    0: IntrinsicColumnWidth(),
                                    1: IntrinsicColumnWidth(),
                                    2: IntrinsicColumnWidth(),
                                    3: IntrinsicColumnWidth(),
                                  },
                                  children: <TableRow>[
                                    TableRow(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            LocaleKeys.topic.tr,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.lato(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            '${LocaleKeys.question.tr} ${LocaleKeys.type.tr}',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.lato(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            LocaleKeys.objectives.tr,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.lato(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            LocaleKeys.marks.tr,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.lato(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...rows,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  });
}
