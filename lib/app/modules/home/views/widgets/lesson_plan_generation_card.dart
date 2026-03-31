import 'package:sikshana/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A card widget that prompts the user to generate a lesson plan.
class LessonPlanGenerationCard extends StatelessWidget {
  /// Creates a new instance of [LessonPlanGenerationCard].
  const LessonPlanGenerationCard({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        LocaleKeys.lessonPlanGeneration.tr,
        style: AppTextStyle.lato(fontSize: 20.sp, fontWeight: FontWeight.w700),
      ),
      8.verticalSpace,
      Text(
        LocaleKeys
            // ignore: lines_longer_than_80_chars
            .generatingComprehensiveLessonPlansStrategiesForCreatingEngagingAndEffectiveLearningExperiencesInTheClassroom
            .tr,
        style: AppTextStyle.lato(
          fontSize: 14.sp,
          color: AppColors.k171A1F.withValues(alpha: 0.84),
        ),
      ),
      4.verticalSpace,
      SizedBox(
        width: 180.w,
        child: AppButton(
          borderRadius: BorderRadius.circular(8.r),
          buttonText: LocaleKeys.generateLessonPlan.tr,
          height: 32.h,
          style: AppTextStyle.lato(fontSize: 14.sp, color: AppColors.kFFFFFF),
          onPressed: () {
            // Get.toNamed(
            //   Routes.CONTENT_GENERATION,
            //   arguments: <String, String>{
            //     'redirectRoute': Routes.LESSON_PLAN_GENERATION_DETAILS,
            //   },
            // );
            if (Get.isRegistered<NavigationScreenController>()) {
              final NavigationScreenController shellController =
                  Get.find<NavigationScreenController>();
              if (shellController.isMainTab(Routes.CONTENT_GENERATION)) {
                final int index = shellController.routes.indexOf(
                  Routes.CONTENT_GENERATION,
                );
                shellController.changeTab(
                  index,
                  redirectionRoute: Routes.LESSON_PLAN_GENERATION_DETAILS,
                );
              }
            }
          },
        ),
      ),
    ],
  );
}
