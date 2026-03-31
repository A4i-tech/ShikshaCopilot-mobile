import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the student comprehension level section.
///
/// This widget includes a title, a note section, and checkboxes for
/// selecting the comprehension levels (beginner, intermediate, advanced).
class StudentComprehensionLevelSection
    extends GetView<LessonResourceGenerationDetailsController> {
  /// Creates a [StudentComprehensionLevelSection] widget.
  const StudentComprehensionLevelSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          SvgPicture.asset(
            AppImages.studentComprehensionLevel,
            height: 24.h,
            width: 24.h,
          ),
          12.horizontalSpace,
          Text(
            LocaleKeys.studentComprehensionLevel.tr,
            style: AppTextStyle.lato(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.k141522,
            ),
          ),
        ],
      ),

      12.verticalSpace,
      noteSection(),
      12.verticalSpace,
      checkboxesSection(),
    ],
  );

  /// Builds the note section with an informational message.
  Container noteSection() => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.kFEF6F1, // Subtle light background as shown in the image
      borderRadius: BorderRadius.circular(12.r),
    ),
    padding: EdgeInsets.only(top: 16.h, left: 16.h, right: 16.h, bottom: 16.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            CupertinoIcons.info,
            color: AppColors
                .kED7D2D, // Orange shade for the icon, similar to your screenshot
            size: 16.w,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: '${LocaleKeys.note.tr} : \n',
                      style: AppTextStyle.lato(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: AppColors.k141522,
                      ),
                    ),
                    TextSpan(
                      text: LocaleKeys
                          .studentComprehensionLevelNote
                          .tr, // Or the message string
                      style: AppTextStyle.lato(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: AppColors.k344767,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _customCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String title,
  }) => InkWell(
    onTap: () => onChanged(!value),
    child: Row(
      children: <Widget>[
        Transform.scale(
          scale: 1, // Adjust size if needed
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.k46A0F1,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(width: 0.w), // Gap of 8 between checkbox and text
        Text(
          title,
          style: AppTextStyle.lato(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.k141522,
          ),
        ),
      ],
    ),
  );

  /// Builds the section with checkboxes for comprehension levels.
  Widget checkboxesSection() => Row(
    children: <Widget>[
      Expanded(
        child: Obx(
          () => _customCheckbox(
            value: controller.beginnerSelected.value,
            onChanged: controller.toggleBeginner,
            title: LocaleKeys.beginner.tr,
          ),
        ),
      ),
      SizedBox(width: 8.w),
      Expanded(
        child: Obx(
          () => _customCheckbox(
            value: controller.intermediateSelected.value,
            onChanged: controller.toggleIntermediate,
            title: LocaleKeys.intermediate.tr,
          ),
        ),
      ),
      SizedBox(width: 16.w),
      Expanded(
        child: Obx(
          () => _customCheckbox(
            value: controller.advancedSelected.value,
            onChanged: controller.toggleAdvanced,
            title: LocaleKeys.advanced.tr,
          ),
        ),
      ),
    ],
  );
}
