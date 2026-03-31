import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/question_input_text_field.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that provides an editable view of an activity.
class ActivityEditable extends StatelessWidget {

  /// Creates an [ActivityEditable] widget.
  const ActivityEditable({
    required this.title,
    required this.preparation,
    required this.requiredMaterials,
    required this.obtainingMaterials,
    required this.recap,
    required this.onTitleChanged,
    required this.onPreparationChanged,
    required this.onRequiredMaterialsChanged,
    required this.onObtainingMaterialsChanged,
    required this.onRecapChanged,
    Key? key,
  }) : super(key: key);
  /// The title of the activity.
  final String title;
  /// The preparation steps for the activity.
  final String preparation;
  /// The materials required for the activity.
  final String requiredMaterials;
  /// Instructions on how to obtain the materials.
  final String obtainingMaterials;
  /// A recap of the activity.
  final String recap;
  /// A callback function that is called when the title changes.
  final ValueChanged<String> onTitleChanged;
  /// A callback function that is called when the preparation steps change.
  final ValueChanged<String> onPreparationChanged;
  /// A callback function that is called when the required materials change.
  final ValueChanged<String> onRequiredMaterialsChanged;
  /// A callback function that is called when the obtaining materials instructions change.
  final ValueChanged<String> onObtainingMaterialsChanged;
  /// A callback function that is called when the recap changes.
  final ValueChanged<String> onRecapChanged;

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        QuestionInputTextField(
          label: 'Title',
          name: title,
          hintText: 'Activity Title',
          initialValue: title,
          onChanged: onTitleChanged,
        ),
        8.verticalSpace,
        QuestionInputTextField(
          label: 'Preparation',
          name: preparation,
          hintText: 'Preparation steps',
          initialValue: preparation,
          onChanged: onPreparationChanged,
        ),
        8.verticalSpace,
        QuestionInputTextField(
          label: 'Required Materials',
          name: requiredMaterials,
          hintText: 'Materials required',
          initialValue: requiredMaterials,
          onChanged: onRequiredMaterialsChanged,
        ),
        8.verticalSpace,
        QuestionInputTextField(
          label: 'Obtaining Materials',
          name: obtainingMaterials,
          hintText: 'How to obtain materials',
          initialValue: obtainingMaterials,
          onChanged: onObtainingMaterialsChanged,
        ),
        8.verticalSpace,
        QuestionInputTextField(
          label: 'Recap',
          name: recap,
          hintText: 'Recap or summary',
          initialValue: recap,
          onChanged: onRecapChanged,
        ),
      ],
    );
}