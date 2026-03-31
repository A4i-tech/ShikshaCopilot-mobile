import 'package:sikshana/app/modules/content_generation/views/widgets/filter_drop_down.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a set of filters for content generation.
///
/// This widget provides dropdown menus for filtering by plan status, plan type,
/// board, medium, class, subject, and month.
class ContentFilterWidget extends GetView<ContentGenerationController> {
  /// Creates a new [ContentFilterWidget].
  const ContentFilterWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 4.w),
    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 22.w),
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      border: Border.all(color: AppColors.kEBEBEB),
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          LocaleKeys.filters.tr,
          style: AppTextStyle.lato(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.k141522,
          ),
        ),
        SizedBox(height: 22.h),
        Row(
          children: <Widget>[
            Expanded(
              child: Obx(
                () => FilterDropdown(
                  label: LocaleKeys.planStatus.tr,
                  hintText: LocaleKeys.planStatus.tr,
                  items: controller.planStatusList,
                  selectedValue: controller.selectedPlanStatus.value,
                  onChanged: controller.onPlanStatusChanged,
                ),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              child: Obx(
                () => FilterDropdown(
                  label: LocaleKeys.planType.tr,
                  hintText: LocaleKeys.planType.tr,
                  items: controller.planTypeList,
                  selectedValue: controller.selectedPlanType.value,
                  onChanged: controller.onPlanTypeChanged,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 22.h),
        Row(
          children: <Widget>[
            Expanded(
              child: Obx(
                () => FilterDropdown(
                  label: LocaleKeys.board.tr,
                  hintText: LocaleKeys.board.tr,
                  items: controller.boardList,
                  selectedValue: controller.selectedBoard.value,
                  onChanged: controller.onBoardChanged,
                ),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              child: Obx(
                () => FilterDropdown(
                  label: LocaleKeys.medium.tr,
                  hintText: LocaleKeys.medium.tr,
                  items: controller.mediumList,
                  selectedValue: controller.selectedMedium.value,
                  onChanged: controller.onMediumChanged,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 22.h),
        Row(
          children: <Widget>[
            Expanded(
              child: Obx(
                () => FilterDropdown(
                  label: LocaleKeys.className.tr,
                  hintText: LocaleKeys.className.tr,
                  items: controller.classList,
                  selectedValue: controller.selectedClass.value,
                  onChanged: controller.onClassChanged,
                ),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              child: Obx(
                () => FilterDropdown(
                  label: LocaleKeys.subject.tr,
                  hintText: LocaleKeys.subject.tr,
                  items: controller.subjectList,
                  selectedValue: controller.selectedSubject.value,
                  onChanged: controller.onSubjectChanged,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 22.h),
        Obx(
          () => FilterDropdown(
            label: LocaleKeys.month.tr,
            hintText: LocaleKeys.month.tr,
            items: controller.monthList,
            selectedValue: controller.selectedMonth.value,
            onChanged: controller.onMonthChanged,
            onClear: controller.onMonthClear,
          ),
        ),
      ],
    ),
  );
}
