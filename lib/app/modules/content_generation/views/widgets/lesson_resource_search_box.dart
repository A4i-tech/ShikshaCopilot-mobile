import 'package:sikshana/app/utils/exports.dart';

/// A search box widget for lesson resources.
///
/// This widget provides a text field for searching and a filter button.
class LessonResourceSearchBox extends GetView<ContentGenerationController> {
  /// Creates a new [LessonResourceSearchBox].
  const LessonResourceSearchBox({super.key, this.onFilterTap});

  /// An optional callback function that is called when the filter button is tapped.
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) => ProfileTextField(
    name: 'search',
    color: AppColors.kF6F8FA,
    borderColor: AppColors.k000000.withOpacity(0.1),
    onChanged: (String? val) {
      controller.searchLessonsWithDebounce(val);
    },
    suffixIcon: InkWell(
      onTap: onFilterTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50).r,
          border: Border.all(color: AppColors.kEBEBEB),
          color: AppColors.kFFFFFF,
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              LocaleKeys.filters.tr,
              style: AppTextStyle.lato(color: AppColors.k565E6C),
            ),
            6.horizontalSpace,
            SvgPicture.asset(AppImages.filter, height: 16.h, width: 16.w),
          ],
        ),
      ).paddingSymmetric(vertical: 6.h, horizontal: 16.w),
    ),
    hintWidget: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SvgPicture.asset(AppImages.search, height: 20.dg),
        3.horizontalSpace,
        Text(
          LocaleKeys.searchLessonsResource.tr,
          style: AppTextStyle.lato(color: AppColors.k6C7278, fontSize: 14.sp),
        ),
      ],
    ),
  );
}
