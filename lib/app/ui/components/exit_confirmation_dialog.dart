import 'package:sikshana/app/utils/exports.dart';

/// A dialog widget to confirm exit from the application.
class ExitConfirmationDialog extends StatelessWidget {
  /// Creates an [ExitConfirmationDialog].
  const ExitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(8.r),
    ),
    titlePadding: EdgeInsets.zero,
    title: Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.kEBEBEB)),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            LocaleKeys.leavePage.tr,
            style: AppTextStyle.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.all(6.dg),
              child: const Icon(Icons.close, fontWeight: FontWeight.w700),
            ),
            onTap: () => Get.back(),
          ),
        ],
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          LocaleKeys
              .youHaveUnsavedChangesDoYouWantToSaveEditedContentsBeforeLeaving
              .tr,
          style: AppTextStyle.lato(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.k323232,
          ),
        ),
        10.verticalSpace,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            20.horizontalSpace,
            Flexible(
              flex: 3,
              child: AppButton(
                borderSide: const BorderSide(color: AppColors.k46A0F1),
                borderRadius: BorderRadius.circular(4.r),
                buttonColor: AppColors.kFFFFFF,
                style: AppTextStyle.lato(
                  color: AppColors.k46A0F1,
                  fontSize: 12.sp,
                ),
                height: 35.h,
                buttonText: LocaleKeys.exitWithoutSaving.tr,
                onPressed: () {
                  Get.back(result: true);
                },
              ),
            ),
            6.horizontalSpace,
            Flexible(
              flex: 2,
              child: AppButton(
                borderRadius: BorderRadius.circular(4.r),
                style: AppTextStyle.lato(
                  color: AppColors.kFFFFFF,
                  fontSize: 12.sp,
                ),
                height: 35.h,
                buttonText: LocaleKeys.saveChanges.tr,
                onPressed: () {
                  Get.back(result: false);
                },
              ),
            ),
          ],
        ),
      ],
    ),
    actionsPadding: EdgeInsets.zero,
  );
}
