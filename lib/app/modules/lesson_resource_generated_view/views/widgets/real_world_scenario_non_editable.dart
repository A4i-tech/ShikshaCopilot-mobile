import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a non-editable view of a real-world scenario.
class RealWorldScenarioNonEditable extends StatelessWidget {

  /// Creates a [RealWorldScenarioNonEditable] widget.
  const RealWorldScenarioNonEditable({
    required this.title,
    required this.question,
    required this.description,
    Key? key,
  }) : super(key: key);
  /// The title of the scenario.
  final String title;
  /// The question for the scenario.
  final String question;
  /// The description of the scenario.
  final String description;

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              style: AppTextStyle.lato(
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
                color: AppColors.k424955,
              ),
            ),
          ),
        if (question.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              'Question: $question',
              style: AppTextStyle.lato(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: AppColors.k141522,
              ),
            ),
          ),
        if (description.isNotEmpty)
          Text(
            'Description: $description',
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              color: AppColors.k141522,
            ),
          ),
      ],
    );
}