import 'package:sikshana/app/modules/lesson_plan_generation_details/views/widgets/lesson_details_dropdown.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a section of dropdowns for lesson resource generation.
///
/// This widget includes dropdowns for selecting the board, medium, class,
/// subject, chapter, and subtopic. It also displays an informational text
/// based on the selected lesson resource template.
class LessonResourceDropdownSection
    extends GetView<LessonResourceGenerationDetailsController> {
  /// Creates a [LessonResourceDropdownSection] widget.
  const LessonResourceDropdownSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(() {
    String? infoText;

    final lessonResource = controller.lessonResourceTemplate.value;
    if (lessonResource != null && lessonResource.data.isNotEmpty) {
      infoText = lessonResource.data[0].description;
    } else {
      infoText = null; // or a default fallback string
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        23.verticalSpace,
        LessonDetailsDropdown(
          label: LocaleKeys.board.tr,
          hintText: LocaleKeys.board.tr,
          items: controller.boardList,
          selectedValue: controller.selectedBoard.value,
          onChanged: controller.onBoardChanged,
          onClear: controller.clearBoardSelection,
        ),
        24.verticalSpace,
        LessonDetailsDropdown(
          label: LocaleKeys.medium.tr,
          hintText: LocaleKeys.medium.tr,
          items: controller.mediumList,
          selectedValue: controller.selectedMedium.value,
          onChanged: controller.onMediumChange,
          onClear: controller.clearMediumSelection,
        ),
        24.verticalSpace,
        LessonDetailsDropdown(
          label: LocaleKeys.class_.tr,
          hintText: LocaleKeys.class_.tr,
          items: controller.classList,
          selectedValue: controller.selectedClass.value,
          onChanged: controller.onClassChange,
          onClear: controller.clearClassSelection,
        ),
        24.verticalSpace,
        LessonDetailsDropdown(
          label: LocaleKeys.subject.tr,
          hintText: LocaleKeys.subject.tr,
          items: controller.subjectList,
          selectedValue: controller.selectedSubject.value,
          onChanged: controller.onSubjectChange,
          onClear: controller.clearSubjectSelection,
        ),
        24.verticalSpace,
        if (controller.chapterList.isEmpty &&
            controller.selectedBoard.value.isNotEmpty &&
            controller.isLoadingChapters.value == false &&
            controller.selectedSubject.value.isNotEmpty) ...<Widget>[
          emptyStateWidget(message: LocaleKeys.no_chapters_available.tr),
        ],
        LessonDetailsDropdown(
          label: LocaleKeys.chapter.tr,
          hintText: LocaleKeys.chapter.tr,
          items: controller.chapterList,
          selectedValue: controller.selectedChapter.value,
          onChanged: controller.onChapterChange,
          onClear: controller.clearChapterSelection,
        ),
        24.verticalSpace,
        Visibility(
          visible: infoText != null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.kEDF6FE,
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
              // borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  AppImages.icBlueWarning,
                  height: 14.h,
                  width: 14.h,
                ),
                16.horizontalSpace,
                Flexible(
                  child: Text(
                    infoText ?? '',
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: AppTextStyle.lato(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.k344767,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        14.verticalSpace,
        LessonDetailsDropdown(
          label: LocaleKeys.subTopic.tr,
          hintText: LocaleKeys.subTopic.tr,
          items: controller.subTopicList,
          selectedValue: controller.selectedSubTopic.value,
          onChanged: controller.onSubTopicChange,
          onClear: controller.clearSubTopicSelection,
        ),
        24.verticalSpace,
      ],
    );
  });
}

/// Reusable empty/error state widget
Widget emptyStateWidget({
  required String message,
  IconData? icon,
  Color? iconColor,
  Color? bgColor,
  Color? textColor,
  EdgeInsets? padding,
  double iconSize = 18.0,
}) => Container(
  padding: padding ?? EdgeInsets.all(16.r),
  margin: EdgeInsets.only(bottom: 8.h),
  decoration: BoxDecoration(
    color: bgColor ?? AppColors.kFFF3CD,
    borderRadius: BorderRadius.circular(8.r),
    border: Border.all(
      color: bgColor == AppColors.kFFF3CD
          ? AppColors.kFFEAA7
          : Colors.red.withAlpha(50),
    ),
  ),
  child: Row(
    children: <Widget>[
      Icon(
        icon ?? Icons.info_outline,
        color: iconColor ?? AppColors.k856408,
        size: iconSize,
      ),
      12.horizontalSpace,
      Expanded(
        child: Text(
          message,
          style: AppTextStyle.lato(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: textColor ?? AppColors.k856408,
          ),
        ),
      ),
    ],
  ),
);
