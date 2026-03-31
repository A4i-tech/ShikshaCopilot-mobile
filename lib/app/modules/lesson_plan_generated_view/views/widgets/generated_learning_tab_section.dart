import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/tabviews/documents_tab_view.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/tabviews/lesson_summary_tab_view.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/tabviews/lesson_tab_view.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/tabviews/videos_tab_view.dart';
import 'package:sikshana/app/utils/exports.dart';

class GeneratedLearningTabSection extends StatefulWidget {
  const GeneratedLearningTabSection({Key? key}) : super(key: key);

  @override
  State<GeneratedLearningTabSection> createState() =>
      _GeneratedLearningTabSectionState();
}

class _GeneratedLearningTabSectionState
    extends State<GeneratedLearningTabSection> {
  int _selectedIndex = 0;

  final List<String> tabs = <String>[
    LocaleKeys.lessonPlan.tr,
    LocaleKeys.lessonSummary.tr,
    LocaleKeys.videos.tr,
    LocaleKeys.documents.tr,
  ];

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Row(
        children: List.generate(tabs.length, (int index) {
          final bool selected = _selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 40,
                decoration: BoxDecoration(
                  color: selected ? AppColors.k46A0F1 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: selected ? AppColors.kFFFFFF : AppColors.k6C7278,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),

      const SizedBox(height: 10),

      Expanded(
        child: IndexedStack(
          index: _selectedIndex,
          children: const <Widget>[
            LessonTabView(),
            LessonSummaryTabView(),
            VideosTabView(),
            DocumentsTabView(),
          ],
        ),
      ),
    ],
  );
}
