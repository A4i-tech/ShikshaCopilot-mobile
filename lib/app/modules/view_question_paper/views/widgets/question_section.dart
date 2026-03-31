import 'package:sikshana/app/modules/question_paper/models/question_bank_model.dart';
import 'package:sikshana/app/modules/view_question_paper/controllers/view_question_paper_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the questions of a generated question paper.
class QuestionSection extends GetView<ViewQuestionPaperController> {
  /// Constructs a [QuestionSection].
  const QuestionSection({
    super.key,
    this.board,
    this.questions,
    this.examinationName,
    this.grade,
    this.subject,
    this.totalMarks,
  });

  /// The list of blueprint templates representing the questions.
  final List<BluePrintTemplate>? questions;

  /// The board name for the question paper.
  final String? board;

  /// The examination name.
  final String? examinationName;

  /// The grade/class for which the question paper is generated.
  final int? grade;

  /// The subject of the question paper.
  final String? subject;

  /// The total marks for the question paper.
  final int? totalMarks;

  @override
  /// Builds the UI for the question section.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying the question paper details and questions.
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(22.dg),
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.kDEE1E6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            board ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyle.lato(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        14.verticalSpace,
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            examinationName ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyle.lato(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        14.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${LocaleKeys.subject.tr} : $subject',
              style: AppTextStyle.lato(fontSize: 12.sp),
            ),
            Text(
              '${LocaleKeys.classKey.tr} : $grade',
              style: AppTextStyle.lato(fontSize: 12.sp),
            ),
            Text(
              '${LocaleKeys.marks.tr} : $totalMarks',
              style: AppTextStyle.lato(fontSize: 12.sp),
            ),
          ],
        ),
        14.verticalSpace,
        const Divider(color: AppColors.kDEE1E6),
        14.verticalSpace,
        if (questions != null)
          ...questions!.map(
            (BluePrintTemplate e) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSectionHeader(
                  '${controller.toRoman(questions!.indexOf(e) + 1)}.'
                      ' ${e.type ?? ''}',
                  '${e.numberOfQuestions}*${e.marksPerQuestion}='
                      '${e.numberOfQuestions! * e.marksPerQuestion!}',
                ),
                16.verticalSpace,
                if (e.questions != null)
                  ...e.questions!.map(
                    (Question question) => _buildMcq(
                      question.question ?? '',
                      question.options ?? <String>[],
                      e.questions?.indexOf(question) ?? 0,
                    ),
                  ),
              ],
            ),
          ),
      ],
    ),
  );

  /// Builds the header for a question section.
  ///
  /// Parameters:
  /// - `title`: The title of the section (e.g., "I. Multiple Choice Questions").
  /// - `marks`: The marks allocated for the section (e.g., "5*2=10").
  ///
  /// Returns:
  /// A `Widget` displaying the section header.
  Widget _buildSectionHeader(String title, String marks) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(
        child: Text(
          title,
          style: AppTextStyle.lato(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      8.horizontalSpace,
      Text(marks, style: AppTextStyle.lato(fontSize: 12.sp)),
    ],
  );

  /// Builds a single MCQ (Multiple Choice Question) widget.
  ///
  /// Parameters:
  /// - `question`: The question text.
  /// - `options`: A list of answer options for the question.
  /// - `index`: The 0-based index of the question within its section.
  ///
  /// Returns:
  /// A `Widget` displaying the MCQ and its options.
  Widget _buildMcq(String question, List<String> options, int index) => Padding(
    padding: EdgeInsets.only(bottom: 16.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${index + 1}. $question',
          style: AppTextStyle.lato(fontSize: 12.sp),
        ),
        ...options
            .map(
              (String option) => Padding(
                padding: EdgeInsets.only(left: 16.w, top: 12.h),
                child: Text(
                  '${String.fromCharCode(65 + options.indexOf(option))}. $option',
                  style: AppTextStyle.lato(fontSize: 12.sp),
                ),
              ),
            )
            .toList(),
      ],
    ),
  );
}
