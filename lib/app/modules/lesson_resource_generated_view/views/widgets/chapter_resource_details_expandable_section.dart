// ignore_for_file: prefer_expression_function_bodies

import 'package:sikshana/app/modules/lesson_plan_generated_view/models/view_lesson_plan_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/utils/from_page.dart';

import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays expandable chapter resource details.
class ChapterResourceDetailsExpandableSection
    extends GetView<LessonResourceGeneratedViewController> {
  /// Creates a [ChapterResourceDetailsExpandableSection].
  const ChapterResourceDetailsExpandableSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller should have an RxBool to track expanded state

    return Obx(() {
      final FromPage fromPage =
          Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

      // Define variables to hold values, initializing as nullable
      String? topicName;
      String? board;
      String? classString;
      String? medium;
      String? subject;
      String? subtopic;

      switch (fromPage) {
        case FromPage.view:
          {
            final resource = controller.lessonResource.value?.data?.resource;
            final chapter = resource?.chapter;
            topicName = chapter?.topics;
            board = chapter?.board;
            classString = resource?.resourceClass.toString();
            medium = chapter?.medium;
            subject =
                '${resource?.subjects?.name} Sem ${resource?.subjects?.sem}';
            subtopic = resource?.subTopics?.first?.toString();
          }
          break;

        case FromPage.generate:
          {
            final LessonResourceGenerationDetailsController
            generationDetailsController =
                Get.find<LessonResourceGenerationDetailsController>();
            final data = generationDetailsController
                .generatedResourceResponse
                .value
                ?.data
                ?.first;
            final chapterGenerated = data?.chapter;
            topicName = chapterGenerated?.topics;
            board = data?.board;
            classString = data?.datumClass?.toString();
            medium = data?.medium;
            subject = '${data?.subjects?.name} Sem ${data?.subjects?.sem}';
            subtopic = data?.subTopics?.first?.toString();
          }
          break;

        // Handle additional cases if needed
        default:
          {
            // Fallback or default behavior same as view
            final resource = controller.lessonResource.value?.data?.resource;
            final chapter = resource?.chapter;
            topicName = chapter?.topics;
            board = chapter?.board;
            classString = resource?.resourceClass.toString();
            medium = chapter?.medium;
            subject =
                '${resource?.subjects?.name} Sem ${resource?.subjects?.sem}';
            subtopic = resource?.subTopics?.first?.toString();
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
            // Header
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
            if (controller.isChapterDetailsExpanded.value)
              Column(
                children: [
                  const Divider(
                    height: 1,
                    thickness: 1.2,
                    color: AppColors.kEBEBEB, // or any light grey color
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 18, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          topicName ?? '',
                          style: AppTextStyle.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.k323232,
                          ),
                        ),
                        const SizedBox(height: 14),
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

  /// Builds a colored tag widget.
  ///
  /// The [text] is the content of the tag.
  /// The [bgColor] is the background color of the tag.
  /// The [textColor] is the text color of the tag.
  ///
  /// Returns a [Widget] representing the tag.
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
