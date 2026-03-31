import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart';
import 'package:sikshana/app/modules/home/views/widgets/recent_lesson_plan_card.dart';
import 'package:sikshana/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a section for recent lesson plans.
class RecentLessonPlansSection extends GetView<HomeController> {
  /// Creates a new instance of [RecentLessonPlansSection].
  const RecentLessonPlansSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> maxCardHeight = ValueNotifier<double>(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                LocaleKeys.recentLessonPlans.tr,
                style: AppTextStyle.lato(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (Get.isRegistered<NavigationScreenController>()) {
                  final NavigationScreenController shellController =
                      Get.find<NavigationScreenController>();
                  if (shellController.isMainTab(Routes.CONTENT_GENERATION)) {
                    final int index = shellController.routes.indexOf(
                      Routes.CONTENT_GENERATION,
                    );
                    shellController.changeTab(index);
                  }
                }
              },
              child: Text(
                LocaleKeys.viewAll.tr,
                style: AppTextStyle.lato(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.k46A0F1,
                ),
              ),
            ),
            14.horizontalSpace,
          ],
        ),
        10.verticalSpace,
        Obx(() {
          final RxList<Plan> plans = controller.recentLessonPlans;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(
                plans.length,
                (int index) => Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 8.w,
                    right: plans.length - 1 == index ? 20.w : 0,
                  ),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          // Measure card after first frame
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final RenderBox? renderBox =
                                context.findRenderObject() as RenderBox?;

                            if (renderBox != null) {
                              final double height = renderBox.size.height;
                              if (height > maxCardHeight.value) {
                                maxCardHeight.value = height;
                              }
                            }
                          });

                          return ValueListenableBuilder<double>(
                            valueListenable: maxCardHeight,
                            builder: (_, double maxHeight, __) =>
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: Get.width - 40.w,
                                    minHeight: maxHeight == 0 ? 0 : maxHeight,
                                    maxHeight: maxHeight == 0
                                        ? double.infinity
                                        : maxHeight,
                                  ),
                                  child: RecentLessonPlanCard(
                                    plan: plans[index],
                                    lessonPlanCount: controller.lessonPlanCount,
                                    lessonResourceCount:
                                        controller.lessonResourceCount,
                                  ),
                                ),
                          );
                        },
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
