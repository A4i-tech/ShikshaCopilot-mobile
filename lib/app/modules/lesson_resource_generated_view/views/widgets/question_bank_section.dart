import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/option_input_text_field.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/question_input_text_field.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the question bank section of a lesson resource.
///
/// This widget can display the question bank in either an editable or non-editable state.
class QuestionBankWidget
    extends GetView<LessonResourceGeneratedViewController> {
  /// The section data for the question bank.
  final dynamic section;

  /// Creates a [QuestionBankWidget].
  const QuestionBankWidget({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = section?.content as List<dynamic>? ?? [];
    if (content.isEmpty) return const SizedBox.shrink();

    const Map<String, String> difficultyLabels = <String, String>{
      'beginner': LocaleKeys.beginner,
      'intermediate': LocaleKeys.intermediate,
      'advanced': LocaleKeys.advanced,
    };

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kFFFFFF,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.kDEE1E6, width: 1.3),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 18),
        child: Obx(() {
          final isEdit = controller.isQuestionBankEdit.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader(
                section?.title ?? '',
                onEditTap: () {
                  controller.isQuestionBankEdit.value =
                      !controller.isQuestionBankEdit.value;
                },
              ),
              12.verticalSpace,
              isEdit ? _buildEditable(content) : _buildNonEditable(content),
            ],
          );
        }),
      ),
    );
  }

  /// Builds the editable version of the question bank.
  ///
  /// The [content] is a list of dynamic objects representing the question bank content.
  /// Returns a [Widget] displaying the editable question bank.
  Widget _buildEditable(List<dynamic> content) {
    const Map<String, String> difficultyLabels = <String, String>{
      'beginner': LocaleKeys.beginner,
      'intermediate': LocaleKeys.intermediate,
      'advanced': LocaleKeys.advanced,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...content.map((difficulty) {
          final diffValue = difficulty?.difficulty;
          final diffLabel = diffValue != null
              ? (difficultyLabels[diffValue] ?? diffValue)
              : '';
          final List<dynamic>? difficultyContent =
              difficulty?.content as List<dynamic>?;

          final mcqContent = difficultyContent?.firstWhereOrNull(
            (c) => c?.type == 'MCQs',
          );
          final assessmentContent = difficultyContent?.firstWhereOrNull(
            (c) => c?.type == 'assessment',
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                diffLabel.toString().tr,
                style: AppTextStyle.lato(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.k424955,
                ),
              ),
              12.verticalSpace,
              if (mcqContent != null && mcqContent?.questions != null)
                ...((mcqContent.questions as List<dynamic>?)
                        ?.asMap()
                        .entries
                        .map((entry) {
                          final idx = entry.key + 1;
                          final q = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                QuestionInputTextField(
                                  label: '${LocaleKeys.question.tr} $idx',
                                  name: q?.question,
                                  hintText: q?.question,
                                  initialValue: q?.question,
                                  onChanged: (val) => q?.question = val,
                                ),
                                8.verticalSpace,
                                ...(q?.options ?? <String>[])
                                    .asMap()
                                    .entries
                                    .map((optEntry) {
                                      final optIdx = optEntry.key;
                                      final opt = optEntry.value;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: OptionInputTextField(
                                          initialValue: opt,
                                          onChanged: (val) =>
                                              q?.options[optIdx] = val,
                                        ),
                                      );
                                    })
                                    .toList(),
                              ],
                            ),
                          );
                        })
                        .toList() ??
                    []),
              if (assessmentContent != null &&
                  assessmentContent?.questions != null) ...[
                Text(
                  LocaleKeys.assessment.tr,
                  style: AppTextStyle.lato(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.k424955,
                  ),
                ),
                8.verticalSpace,
                ...((assessmentContent.questions as List<dynamic>?)
                        ?.asMap()
                        .entries
                        .map((e) {
                          final idx = e.key + 1;
                          final q = e.value;
                          return QuestionInputTextField(
                            label: '${LocaleKeys.question.tr} $idx',
                            name: q?.question,
                            hintText: q?.question,
                            initialValue: q?.question,
                            onChanged: (val) => q?.question = val,
                          );
                        })
                        .toList() ??
                    []),
                12.verticalSpace,
              ],
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: () {
            controller.saveQuestionBankEdits();
            controller.isQuestionBankEdit.value = false;
          },
          child: Text(LocaleKeys.save.tr),
        ),
      ],
    );
  }

  /// Builds the non-editable version of the question bank.
  ///
  /// The [content] is a list of dynamic objects representing the question bank content.
  /// Returns a [Widget] displaying the non-editable question bank.
  Widget _buildNonEditable(List<dynamic> content) {
    const Map<String, String> difficultyLabels = <String, String>{
      'beginner': LocaleKeys.beginner,
      'intermediate': LocaleKeys.intermediate,
      'advanced': LocaleKeys.advanced,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...content.map((difficulty) {
          final diffValue = difficulty?.difficulty;
          final diffLabel = diffValue != null
              ? (difficultyLabels[diffValue] ?? diffValue)
              : '';
          final List<dynamic>? difficultyContent =
              difficulty?.content as List<dynamic>?;

          final mcqContent = difficultyContent?.firstWhereOrNull(
            (c) => c?.type == 'MCQs',
          );
          final assessmentContent = difficultyContent?.firstWhereOrNull(
            (c) => c?.type == 'assessment',
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                diffLabel.toString().tr,
                style: AppTextStyle.lato(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.k424955,
                ),
              ),
              12.verticalSpace,
              if (mcqContent != null && mcqContent?.questions != null)
                ...((mcqContent.questions as List<dynamic>?)
                        ?.asMap()
                        .entries
                        .map((entry) {
                          final idx = entry.key + 1;
                          final q = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$idx. ${q?.question}',
                                  style: AppTextStyle.lato(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.k141522,
                                  ),
                                ),
                                8.verticalSpace,
                                ...(q?.options ?? <String>[])
                                    .map(
                                      (opt) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          bottom: 3,
                                        ),
                                        child: Text(
                                          '• $opt',
                                          style: AppTextStyle.lato(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.k141522,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          );
                        })
                        .toList() ??
                    []),
              if (assessmentContent != null &&
                  assessmentContent?.questions != null) ...[
                Text(
                  LocaleKeys.assessment.tr,
                  style: AppTextStyle.lato(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.k424955,
                  ),
                ),
                8.verticalSpace,
                ...((assessmentContent.questions as List<dynamic>?)
                        ?.asMap()
                        .entries
                        .map((e) {
                          final idx = e.key + 1;
                          final q = e.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 8),
                            child: Text(
                              '$idx. ${q?.question}',
                              style: AppTextStyle.lato(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.k141522,
                              ),
                            ),
                          );
                        })
                        .toList() ??
                    []),
                12.verticalSpace,
              ],
            ],
          );
        }).toList(),
      ],
    );
  }
}

/// A widget that displays a section header with an optional edit button.
Widget sectionHeader(String title, {VoidCallback? onEditTap}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: <Widget>[
    Flexible(
      // ✅ Prevents overflow, allows multiline
      child: Text(
        title,
        style: AppTextStyle.lato(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.k46A0F1,
        ),
        maxLines: 6, // ✅ Optional: limit to 2 lines
        overflow: TextOverflow.ellipsis, // ✅ Ellipsis if still too long
        textAlign: TextAlign.start,
      ),
    ),
    GestureDetector(
      onTap: onEditTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.kFFFFFF,
          border: Border.all(color: AppColors.kEBEBEB, width: 1.3),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: <Widget>[
            Text(
              LocaleKeys.edit.tr,
              style: AppTextStyle.lato(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.k46A0F1,
              ),
            ),
            4.horizontalSpace,
            SvgPicture.asset(AppImages.icEditBlue, width: 12, height: 12),
          ],
        ),
      ),
    ),
  ],
);
