import 'package:sikshana/app/utils/exports.dart';

///Generation Status card
class GenerateStatusCard extends StatelessWidget {
  ///Creates new [GenerateStatusCard]
  const GenerateStatusCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
    decoration: BoxDecoration(
      color: AppColors.kEDF6FE, // light blue
      borderRadius: BorderRadius.circular(8).r,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SvgPicture.asset(
          AppImages.lessonContentInfo,
          width: 36.w,
          height: 36.h,
        ),
        12.horizontalSpace,
        Expanded(
          child: Text(
            LocaleKeys
                .pleaseNoteThatThisPageIncludesRegeneratedContentTheRegenerationProcessMayTakeSomeTimeAndWeWillUpdateTheStatusOnTheCardsAccordinglyOnceTheContentIsFullyGeneratedYouCanEditAndFinalizeThePlan
                .tr,
            style: AppTextStyle.lato(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.k344767,
              height: 1.9,
            ),
          ),
        ),
      ],
    ),
  );
}
