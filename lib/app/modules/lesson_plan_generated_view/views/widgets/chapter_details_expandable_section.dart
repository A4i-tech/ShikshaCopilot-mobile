// ignore_for_file: prefer_expression_function_bodies

import 'package:sikshana/app/utils/exports.dart';

/// A collapsible section that displays chapter-related metadata
/// (topic, board, class, medium, subject, subtopic).
///
/// This widget supports both lesson **view mode** and **generated mode**
/// depending on [FromPage]. It pulls relevant chapter details from the
/// appropriate controller using GetX.
///
/// The UI includes:
/// - A header that toggles expansion
/// - Metadata tags shown when expanded
class ChapterDetailsExpandableSection
    extends GetView<LessonPlanGeneratedViewController> {
  /// Creates the ChapterDetailsExpandableSection.
  ///
  /// This section expands or collapses based on the value of
  /// `controller.isChapterDetailsExpanded`.
  const ChapterDetailsExpandableSection({Key? key}) : super(key: key);

  /// Builds the collapsible UI showing chapter details.
  ///
  /// The widget:
  /// - Determines the current page context (`view` or `generate`)
  /// - Fetches metadata from the respective controllers
  /// - Displays a header row
  /// - Shows tags in an expandable section
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final FromPage fromPage =
          (Get.arguments?['from_page'] as FromPage?) ?? FromPage.view;

      // Fields to be populated based on the source page
      String? topicName;
      String? board;
      String? classString;
      String? medium;
      String? subject;
      String? subtopic;

      // Determine values based on context
      switch (fromPage) {
        case FromPage.view:
          {
            final lesson = controller.lessonPlan.value?.data?.lesson;
            final chapter = lesson?.chapter;
            topicName = chapter?.topics;
            board = chapter?.board;
            classString = lesson?.lessonClass.toString();
            medium = chapter?.medium;
            subject = '${lesson?.subjects?.name} Sem ${lesson?.subjects?.sem}';
            subtopic = lesson?.subTopics?.first?.toString();
          }
          break;

        case FromPage.generate:
          {
            final LessonPlanGenerationDetailsController
            generationDetailsController =
                Get.find<LessonPlanGenerationDetailsController>();

            final data = generationDetailsController
                .generatedLessonResponse
                .value
                ?.data
                ?.first;

            final chapterGenerated = data?.chapter;

            topicName = chapterGenerated?.topics;
            board = data?.board;
            classString = data?.datumClass?.toString();
            medium = data?.medium;
            subject = '${data?.subjects?.name} Sem ${data?.subjects?.sem}';
            subtopic = data?.subTopics?.first;
          }
          break;

        default:
          {
            final lesson = controller.lessonPlan.value?.data?.lesson;
            final chapter = lesson?.chapter;
            topicName = chapter?.topics;
            board = chapter?.board;
            classString = lesson?.lessonClass.toString();
            medium = chapter?.medium;
            subject = '${lesson?.subjects?.name} Sem ${lesson?.subjects?.sem}';
            subtopic = lesson?.subTopics?.first?.toString();
          }
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.kEBEBEB),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Header row that toggles expansion state.
            GestureDetector(
              onTap: () => controller.toggleChapterDetailsExpanded(),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.kFFFFFF,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      LocaleKeys.chapterDetails.tr,
                      style: const TextStyle(
                        color: AppColors.k171A1F,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    /// Arrow rotates on expansion
                    AnimatedRotation(
                      turns: controller.isChapterDetailsExpanded.value
                          ? 0.5
                          : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.k171A1F,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Expanded content showing chapter metadata
            if (controller.isChapterDetailsExpanded.value)
              Column(
                children: [
                  const Divider(
                    height: 1,
                    thickness: 1.2,
                    color: AppColors.kEBEBEB,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 18, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// Topic Name
                        Text(
                          topicName ?? '',
                          style: AppTextStyle.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.k323232,
                          ),
                        ),

                        const SizedBox(height: 14),

                        /// Horizontal wrapping tag list
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          children: <Widget>[
                            _buildTag(
                              board ?? '',
                              const Color(0xFFE5F7EA),
                              AppColors.k3D8248,
                            ),
                            _buildTag(
                              medium ?? '',
                              AppColors.kFFF8F4,
                              AppColors.kED7D2D,
                            ),
                            _buildTag(
                              classString ?? '',
                              AppColors.kFDF2F2,
                              AppColors.kDE3B40,
                            ),
                            _buildTag(
                              subject ?? '',
                              AppColors.kEDF6FE,
                              AppColors.k46A0F1,
                            ),
                            _buildTag(
                              subtopic ?? '',
                              AppColors.kB0B0B0.withValues(alpha: 0.2),
                              AppColors.k6C7278,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }

  /// Builds a single rounded tag widget used for metadata values.
  ///
  /// [text] is the label inside the tag.
  /// [bgColor] is the background color.
  /// [textColor] sets the text color.
  ///
  /// Returns a styled container resembling a capsule tag.
  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: AppTextStyle.lato(
          color: textColor,
          fontWeight: FontWeight.w400,
          fontSize: 11,
        ),
      ),
    );
  }
}
