import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a non-editable view of an activity.
class ActivityNonEditable extends StatelessWidget {
  /// The title of the activity.
  final String title;
  /// The preparation steps for the activity.
  final String preparation;
  /// The materials required for the activity.
  final String requiredMaterials;
  /// Instructions on how to obtain the materials.
  final String obtainingMaterials;
  /// A recap of the activity.
  final String recap;

  /// Creates an [ActivityNonEditable] widget.
  const ActivityNonEditable({
    Key? key,
    required this.title,
    required this.preparation,
    required this.requiredMaterials,
    required this.obtainingMaterials,
    required this.recap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title.isNotEmpty)
        Text(
          title,
          style: AppTextStyle.lato(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.k000000,
          ),
        ),
      7.verticalSpace,
      if (preparation.isNotEmpty)
        Text(
          '${LocaleKeys.preparation.tr}: $preparation',
          style: AppTextStyle.lato(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.k000000,
          ),
        ),
      4.verticalSpace,
      if (requiredMaterials.isNotEmpty)
        Text(
          '${LocaleKeys.requiredMaterials.tr}: $requiredMaterials',
          style: AppTextStyle.lato(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.k000000,
          ),
        ),
      4.verticalSpace,
      if (obtainingMaterials.isNotEmpty)
        Text(
          '${LocaleKeys.obtainingMaterials.tr}: $obtainingMaterials',
          style: AppTextStyle.lato(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.k000000,
          ),
        ),
      4.verticalSpace,
      if (recap.isNotEmpty)
        Text(
          '${LocaleKeys.recap.tr}: $recap',
          style: AppTextStyle.lato(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.k000000,
          ),
        ),
    ],
  );
}

/// A widget that displays a section header with an optional edit button.
Widget sectionHeader(String title, {VoidCallback? onEditTap}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: <Widget>[
    Text(
      title,
      style: AppTextStyle.lato(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.k46A0F1,
      ),
    ),
    GestureDetector(
      onTap: onEditTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.k379AE6.withAlpha(10),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(AppImages.icEditBlue, width: 12, height: 12),
            4.horizontalSpace,
            Text(
              LocaleKeys.edit.tr,
              style: AppTextStyle.lato(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.k46A0F1,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
);