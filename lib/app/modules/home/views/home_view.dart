import 'package:shimmer/shimmer.dart';
import 'package:sikshana/app/utils/exports.dart';

/// The main view for the Home screen.
///
/// This widget displays the user's home, including a greeting,
/// lesson plan generation card, recent lesson plans, lesson stats chart,
/// and calendar schedule.
class HomeView extends GetView<HomeController> {
  /// Creates a new instance of [HomeView].
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>()
          ..onReConnect = controller.initController;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : Scaffold(
              key: scaffoldKey,
              body: RefreshIndicator(
                onRefresh: () async {
                  controller.onInit();
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  children: <Widget>[
                    GreetingWidget(
                      userName: UserProvider.currentUser?.name ?? '',
                    ).paddingSymmetric(horizontal: 20.w),
                    const LessonPlanGenerationCard().paddingSymmetric(
                      horizontal: 20.w,
                    ),
                    Obx(() {
                      if (controller.isLoadingLessonPlans()) {
                        return Shimmer.fromColors(
                          baseColor: AppColors.kE0E0E0,
                          highlightColor: AppColors.kF5F5F5,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: SizedBox(
                              width: Get.width,
                              height: 250.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: Get.width,
                                    height: 28.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.kFFFFFF,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ).paddingOnly(right: 18.w),
                                  SizedBox(height: 28.h),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 16.w),
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        color: AppColors.kFFFFFF,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const RecentLessonPlansSection().paddingOnly(
                          left: 20.w,
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
    );
  }
}
