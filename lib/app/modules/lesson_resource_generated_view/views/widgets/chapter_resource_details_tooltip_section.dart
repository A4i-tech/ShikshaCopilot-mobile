import 'package:sikshana/app/modules/lesson_plan_generated_view/models/view_lesson_plan_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/utils/from_page.dart';
import 'package:sikshana/app/utils/exports.dart';

class ChapterResourceDetailsTooltipSection
    extends GetView<LessonResourceGeneratedViewController> {
  const ChapterResourceDetailsTooltipSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(() {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    String? topicName;
    String? board;
    String? classString;
    String? medium;
    String? subject;
    String? subtopic;

    switch (fromPage) {
      case FromPage.view:
        final resource = controller.lessonResource.value?.data?.resource;
        final chapter = resource?.chapter;

        print('🔍 CHAPTER JSON (view): ${chapter?.toJson()}');
        print('🔍 FULL RESOURCE: ${resource?.toJson()}');
        topicName = chapter?.topics;
        board = chapter?.board;
        classString = resource?.resourceClass.toString();
        medium = chapter?.medium;
        final subjectsView = resource?.subjects;
        final int semView =
            (subjectsView?.sem ?? 0); // ?? 0 hides sem if null/0

        final String subjectName = subjectsView?.name ?? '';
        subject = semView > 0 ? '$subjectName Sem $semView' : subjectName;

        subtopic = resource?.subTopics?.firstOrNull?.toString() ?? '';
        break;
      case FromPage.generate:
        final generationDetailsController =
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
        final subjectsGen = data?.subjects;
        final int semGen = (subjectsGen?.sem ?? 0); // ?? 0 hides if null/0

        final String subjectName = subjectsGen?.name ?? '';
        subject = semGen > 0 ? '$subjectName Sem $semGen' : subjectName;

        subtopic =
            data?.subTopics?.firstOrNull?.toString() ??
            ''; // Needs collection package or extension

        break;
      default:
        final resource = controller.lessonResource.value?.data?.resource;
        final chapter = resource?.chapter;
        topicName = chapter?.topics;
        board = chapter?.board;
        classString = resource?.resourceClass.toString();
        medium = chapter?.medium;
        final subjectsView = resource?.subjects;
        final int semView =
            (subjectsView?.sem ?? 0); // ?? 0 hides sem if null/0

        final String subjectName = subjectsView?.name ?? '';
        subject = semView > 0 ? '$subjectName Sem $semView' : subjectName;
        subtopic = resource?.subTopics?.first?.toString();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kEBEBEB),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.chapterDetails.tr,
                  style: const TextStyle(
                    color: AppColors.k171A1F,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.showChapterDetailsTooltip.value =
                        !controller.showChapterDetailsTooltip.value;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: AppColors.k171A1F,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (controller.showChapterDetailsTooltip.value)
            Positioned(
              right: 12,
              top: 44,
              child: _ResourceBubbleTooltip(
                topicName: topicName ?? '',
                board: board ?? '',
                classString: classString ?? '',
                medium: medium ?? '',
                subject: subject ?? '',
                subtopic: subtopic ?? '',
                onClose: () =>
                    controller.showChapterDetailsTooltip.value = false,
              ),
            ),
        ],
      ),
    );
  });
}

class _ResourceBubbleTooltip extends StatelessWidget {
  final String topicName;
  final String board;
  final String classString;
  final String medium;
  final String subject;
  final String subtopic;
  final VoidCallback onClose;

  const _ResourceBubbleTooltip({
    required this.topicName,
    required this.board,
    required this.classString,
    required this.medium,
    required this.subject,
    required this.subtopic,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) => Material(
    elevation: 14,
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  topicName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.k323232,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.k6C7278,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(board, const Color(0xFFE5F7EA), AppColors.k3D8248),
              _buildTag(medium, AppColors.kFFF8F4, AppColors.kED7D2D),
              _buildTag(classString, AppColors.kFDF2F2, AppColors.kDE3B40),
              _buildTag(subject, AppColors.kEDF6FE, AppColors.k46A0F1),
              _buildTag(
                subtopic,
                AppColors.kB0B0B0.withValues(alpha: 0.2),
                AppColors.k6C7278,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyle.lato(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }
}
