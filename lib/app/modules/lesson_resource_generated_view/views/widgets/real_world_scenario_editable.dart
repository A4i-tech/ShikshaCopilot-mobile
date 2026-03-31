import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/question_input_text_field.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that provides an editable view of a real-world scenario.
class RealWorldScenarioEditable extends StatelessWidget {

  /// Creates a [RealWorldScenarioEditable] widget.
  const RealWorldScenarioEditable({
    required this.title,
    required this.question,
    required this.description,
    required this.onTitleChanged,
    required this.onQuestionChanged,
    required this.onDescriptionChanged,
    Key? key,
  }) : super(key: key);
  /// The title of the scenario.
  final String title;
  /// The question for the scenario.
  final String question;
  /// The description of the scenario.
  final String description;
  /// A callback function that is called when the title changes.
  final ValueChanged<String> onTitleChanged;
  /// A callback function that is called when the question changes.
  final ValueChanged<String> onQuestionChanged;
  /// A callback function that is called when the description changes.
  final ValueChanged<String> onDescriptionChanged;

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        QuestionInputTextField(
          label: 'Title',
          name: title,
          hintText: 'Scenario Title',
          initialValue: title,
          onChanged: onTitleChanged,
        ),
        const SizedBox(height: 8),
        QuestionInputTextField(
          label: 'Question',
          name: question,
          hintText: 'Scenario Question',
          initialValue: question,
          onChanged: onQuestionChanged,
        ),
        const SizedBox(height: 8),
        QuestionInputTextField(
          label: 'Description',
          name: description,
          hintText: 'Scenario Description',
          initialValue: description,
          onChanged: onDescriptionChanged,
        ),
      ],
    );
}