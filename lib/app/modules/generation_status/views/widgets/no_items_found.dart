import 'package:sikshana/app/utils/exports.dart';

class NoItemsFoundWidget extends StatelessWidget {
  const NoItemsFoundWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 18.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10).r,
      border: Border.all(color: AppColors.k000000.withOpacity(0.1)),
    ),
    height: 200.h,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(14.dg),
            decoration: BoxDecoration(
              color: AppColors.kFFC11E.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(AppImages.noItem, height: 24.dg),
          ),
          24.verticalSpace,
          Text(
            LocaleKeys.noItemsFound.tr,
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
