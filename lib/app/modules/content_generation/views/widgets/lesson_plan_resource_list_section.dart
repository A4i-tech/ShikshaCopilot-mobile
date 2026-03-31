import 'package:sikshana/app/modules/content_generation/views/widgets/lesson_plan_resource_list_card.dart';
import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a list of lesson plans and resources.
///
/// This widget uses a [ListView.builder] to create a list of
/// [LessonPlanResourceListCard] widgets from the data in the
/// [ContentGenerationController].
class LessonPlanResourceListSection
    extends GetView<ContentGenerationController> {
  /// Creates a new [LessonPlanResourceListSection].
  const LessonPlanResourceListSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Obx(
        () => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.lessonPlanResourceList.length,
          itemBuilder: (BuildContext context, int index) {
            final Plan model = controller.lessonPlanResourceList[index];
            return LessonPlanResourceListCard(model: model);
          },
        ),
      ),
    ],
  );
}
