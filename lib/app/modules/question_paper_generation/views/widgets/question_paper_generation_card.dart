import 'package:sikshana/app/utils/exports.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// A card widget that displays information about question paper generation.
class QuestionPaperGenerationCard extends StatelessWidget {
  /// Creates new [QuestionPaperGenerationCard]
  const QuestionPaperGenerationCard({super.key});

  @override
  /// Builds the UI for the question paper generation info card.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying informational text and a link.
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
          child: RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: LocaleKeys
                      .generateCustomizedQuestionPaperThatAssessStudentsLearning
                      .tr,
                  style: AppTextStyle.lato(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.k344767,
                    height: 1.9,
                  ),
                ),
                // TextSpan(
                //   text:
                //       '\nNote: If you want Lesson-Based Assessment '
                //       'Questions, please refer to the ',
                //   style: AppTextStyle.lato(
                //     fontSize: 12.sp,
                //     fontWeight: FontWeight.w400,
                //     color: AppColors.k344767,
                //     height: 1.9,
                //   ),
                // ),
                // WidgetSpan(
                //   alignment: PlaceholderAlignment.middle,
                //   child: GestureDetector(
                //     onTap: () {
                //       LaunchUrl.launch(
                //         'https://dsert.karnataka.gov.in/50/Lesson%20Based%20Assesment'
                //         '%20material/${UserProvider.currentUser?.preferredLanguage ?? 'en'}',
                //         mode: LaunchMode.inAppBrowserView,
                //       );
                //     },
                //     child: Text(
                //       'DSERT link',
                //       style: AppTextStyle.lato(
                //         fontSize: 12.sp,
                //         fontWeight: FontWeight.w400,
                //         color: AppColors.k46A0F1,
                //         height: 1.9,
                //         decoration: TextDecoration.underline,
                //         decorationColor: AppColors.k46A0F1,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
