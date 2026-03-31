import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/activities_section.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/question_bank_section.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/realworld_scenarios_section.dart';
import 'package:sikshana/app/utils/exports.dart';

class LessonResourceTabContent extends StatelessWidget {
  final dynamic section;
  final FromPage fromPage;

  const LessonResourceTabContent({
    Key? key,
    required this.section,
    required this.fromPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final outputFormat = section?.outputFormat;

    switch (outputFormat) {
      case 'json_1':
        return QuestionBankWidget(
          section: section,
        ).paddingSymmetric(horizontal: 24);
      case 'json_2':
        return RealWorldScenariosSection(
          section: section,
        ).paddingSymmetric(horizontal: 24);
      case 'json_3':
        return ActivitiesSection(
          section: section,
          fromPage: fromPage,
        ).paddingSymmetric(horizontal: 24);
      default:
        return Container();
    }
  }
}
