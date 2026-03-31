import 'package:shimmer/shimmer.dart';
import 'package:sikshana/app/modules/content_generation/views/widgets/lesson_plan_resource_list_card.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Tab content with infinite scrollable lists.
class ContentGenerationTabSection extends GetView<ContentGenerationController> {
  const ContentGenerationTabSection({super.key});

  @override
  Widget build(BuildContext context) => TabBarView(
    children: <Widget>[
      // Lesson Plan Tab
      Obx(() {
        if (controller.isLoadingLessonPlans.value) {
          return Shimmer.fromColors(
            baseColor: AppColors.kE0E0E0,
            highlightColor: AppColors.kF5F5F5,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 3, // Number of shimmer items
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Container(
                  height: 240.h,
                  decoration: BoxDecoration(
                    color: AppColors.kFFFFFF,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          );
        } else if (controller.lessonPlanList.isEmpty) {
          return const Center(child: Text('No lesson plans found'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: controller.lessonPlanList.length,
            itemBuilder: (BuildContext context, int index) =>
                LessonPlanResourceListCard(
                  model: controller.lessonPlanList[index],
                ),
          );
        }
      }),
      // Lesson Resources Tab
      Obx(() {
        if (controller.isLoadingLessonPlans.value) {
          return Shimmer.fromColors(
            baseColor: AppColors.kE0E0E0,
            highlightColor: AppColors.kF5F5F5,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 3, // Number of shimmer items
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: AppColors.kFFFFFF,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          );
        } else if (controller.lessonResourceList.isEmpty) {
          return const Center(child: Text('No resources found'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: controller.lessonResourceList.length,
            itemBuilder: (BuildContext context, int index) =>
                LessonPlanResourceListCard(
                  model: controller.lessonResourceList[index],
                ),
          );
        }
      }),
    ],
  );
}
