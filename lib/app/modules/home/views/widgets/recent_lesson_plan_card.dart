import 'package:intl/intl.dart';
import 'package:sikshana/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';
import 'package:sikshana/app/utils/exports.dart';
import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart';

/// A card widget that displays a recent lesson plan.
class RecentLessonPlanCard extends StatelessWidget {
  /// Creates a new instance of [RecentLessonPlanCard].
  ///
  /// Requires a [plan], [lessonPlanCount], and [lessonResourceCount].
  const RecentLessonPlanCard({
    required this.plan,
    required this.lessonPlanCount,
    required this.lessonResourceCount,
    super.key,
  });

  /// The lesson plan data to display.
  final Plan plan;

  /// The total count of lesson plans.
  final int lessonPlanCount;

  /// The total count of lesson resources.
  final int lessonResourceCount;

  @override
  Widget build(BuildContext context) {
    final bool isLesson = plan.isLesson ?? true;
    final String subject = isLesson
        ? plan.lesson?.subjects?.name ?? ''
        : plan.resource?.subjects?.name ?? '';
    final String topic = isLesson
        ? plan.lesson?.chapter?.topics ?? ''
        : plan.resource?.chapter?.topics ?? '';
    final int sem = isLesson
        ? plan.lesson?.subjects?.sem ?? 0
        : plan.resource?.subjects?.sem ?? 0;
    final Color cardColor = isLesson ? AppColors.kA062F7 : AppColors.k70CF97;
    final int count = isLesson ? lessonPlanCount : lessonResourceCount;
    final String buttonName = isLesson
        ? LocaleKeys.viewLessonPlan.tr
        : LocaleKeys.viewResourcePlan.tr;
    final String generatedAt = DateFormat(
      'MMM d, yyyy',
    ).format(plan.createdAt ?? DateTime.now());
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.description_outlined, color: cardColor),
                    ),
                    Text(
                      '${LocaleKeys.generatedOn.tr}: '
                      '$generatedAt',
                      style: AppTextStyle.lato(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  // '${LocaleKeys.subject.tr}: $subject '
                  // '${Get.locale?.languageCode == 'en' ? "Sem" : LocaleKeys.semester.tr} $sem',
                  '${LocaleKeys.subject.tr}: $subject '
                  '${sem > 0 ? "${Get.locale?.languageCode == 'en' ? "Sem" : LocaleKeys.semester.tr} $sem" : ""}',
                  style: AppTextStyle.lato(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        '${LocaleKeys.topic.tr}: $topic',
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    18.horizontalSpace,
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(AppImages.lessonPlanIcon, height: 16.sp),
                          10.horizontalSpace,
                          Flexible(
                            child: Text(
                              '${isLesson ? LocaleKeys.lessonPlans.tr : LocaleKeys.lessonResources.tr}:$count',
                              style: AppTextStyle.lato(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            AppButton(
              buttonText: buttonName,
              onPressed: () {
                if (Get.isRegistered<NavigationScreenController>()) {
                  final NavigationScreenController shellController =
                      Get.find<NavigationScreenController>();
                  shellController.changeTab(
                    shellController.currentIndex.value,
                    redirectionRoute: plan.lesson?.id == null
                        ? Routes.LESSON_RESOURCE_GENERATED_VIEW
                        : Routes.LESSON_PLAN_GENERATED_VIEW,
                    args: <String, dynamic>{
                      'lessonId': plan.lesson?.id ?? plan.resource?.id,
                      'from_page': FromPage.view,
                    },
                  );
                }
              },
              buttonColor: cardColor,
              height: 45.h,
            ),
          ],
        ),
      ),
    );
  }
}
