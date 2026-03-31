import 'package:sikshana/app/modules/question_paper/controllers/question_paper_controller.dart';
import 'package:sikshana/app/modules/question_paper/models/template_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a pie chart representing the blueprint of a question paper.
class BlueprintChart extends StatefulWidget {
  /// Constructs a [BlueprintChart].
  const BlueprintChart({super.key});

  @override
  State<BlueprintChart> createState() => _BlueprintChartState();
}

class _BlueprintChartState extends State<BlueprintChart> {
  int? touchedIndex;

  @override
  /// Builds the UI for the blueprint chart.
  ///
  /// This method calculates the distribution of marks across different objectives
  /// and renders a pie chart with corresponding indicators.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying the pie chart and indicators.
  Widget build(BuildContext context) {
    final QuestionPaperController controller =
        Get.find<QuestionPaperController>();

    return Center(
      child: Obx(() {
        final Map<String, double> objectiveMarks = <String, double>{};
        double totalMarks = 0;

        for (final TemplateData blueprint in controller.questionBluePrint) {
          final int marksPerQuestion = blueprint.marksPerQuestion ?? 0;
          if (blueprint.questionDistribution != null) {
            for (final distribution in blueprint.questionDistribution!) {
              final String objective = distribution.objective ?? 'Skill';
              final double marks = marksPerQuestion.toDouble();
              objectiveMarks[objective] =
                  (objectiveMarks[objective] ?? 0) + marks;
              totalMarks += marks;
            }
          }
        }

        if (totalMarks == 0) {
          return Text(
            LocaleKeys.noDataAvailable.tr,
            style: AppTextStyle.lato(),
          );
        }

        final List<Color> colors = <Color>[
          AppColors.kF17C7C,
          AppColors.k29B4FF,
          AppColors.kFFC700,
          AppColors.kE0E0E0,
        ];

        final List<PieChartSectionData> sections = <PieChartSectionData>[];
        final List<Widget> indicators = <Widget>[];
        int i = 0;

        objectiveMarks.forEach((String objective, double marks) {
          final double percentage = (marks / totalMarks) * 100;
          final Color color = colors[i % colors.length];
          final bool isTouched = touchedIndex == i;

          sections.add(
            PieChartSectionData(
              color: color,
              value: percentage,
              title: '${percentage.toStringAsFixed(1)}%',
              titleStyle: AppTextStyle.lato(
                color: isTouched ? Colors.white : Colors.transparent,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
              radius: isTouched ? 48 : 40,
            ),
          );

          indicators.add(
            _Indicator(color: color, text: objective, isSquare: false),
          );
          i++;
        });

        return Column(
          children: <Widget>[
            GestureDetector(
              onTapUp: (TapUpDetails details) {
                setState(() => touchedIndex = null);
              },
              child: Material(
                elevation: 4,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: 195,
                  width: 195,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      PieChart(
                        PieChartData(
                          sections: sections,
                          centerSpaceRadius: 55,
                          sectionsSpace: 1,
                          borderData: FlBorderData(show: false),
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (
                                  FlTouchEvent event,
                                  PieTouchResponse? response,
                                ) {
                                  if (!event.isInterestedForInteractions ||
                                      response == null ||
                                      response.touchedSection == null) {
                                    setState(() => touchedIndex = null);
                                    return;
                                  }
                                  setState(
                                    () => touchedIndex = response
                                        .touchedSection!
                                        .touchedSectionIndex,
                                  );
                                },
                          ),
                        ),
                      ),
                      if (touchedIndex != null)
                        if (touchedIndex! >= 0)
                          Positioned(
                            top: 80,
                            child: AnimatedOpacity(
                              opacity: 1,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${objectiveMarks.keys.elementAt(touchedIndex!)}\n${((objectiveMarks.values.elementAt(touchedIndex!) / totalMarks) * 100).toStringAsFixed(1)}%',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.lato(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
            16.verticalSpace,
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: indicators,
            ).paddingSymmetric(horizontal: 40.w),
          ],
        );
      }),
    );
  }
}

/// A widget that displays a color indicator with a text label.
class _Indicator extends StatelessWidget {
  /// Constructs an [_Indicator].
  const _Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
  });

  /// The color of the indicator.
  final Color color;

  /// The text label for the indicator.
  final String text;

  /// Whether the indicator should be a square or a circle.
  final bool isSquare;

  @override
  /// Builds the UI for the indicator.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Row` widget containing the color indicator and text.
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        width: 14.w,
        height: 14.h,
        decoration: BoxDecoration(
          shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
          color: color,
        ),
      ),
      6.horizontalSpace,
      Text(
        text,
        style: AppTextStyle.lato(fontSize: 12, color: AppColors.k515052),
      ),
    ],
  );
}
