import 'package:sikshana/app/utils/exports.dart';

/// A view class for the lesson plan generation details screen.
class LessonPlanGenerationDetailsView
    extends GetView<LessonPlanGenerationDetailsController> {
  /// Creates a [LessonPlanGenerationDetailsView] object.
  const LessonPlanGenerationDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : Scaffold(
              key: scaffoldKey,
              appBar: CommonAppBar(
                scaffoldKey: scaffoldKey,
                leading: Leading.drawer,
              ),
              drawer: const AppDrawer(currentRoute: Routes.CONTENT_GENERATION),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 26.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        LocaleKeys.lessonPlanDetails.tr,
                        style: AppTextStyle.lato(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.k141522,
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        'Info: Lesson Plan Type-5E , Board-${controller.currentBoard.value}',
                        style: AppTextStyle.lato(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.k344767,
                        ),
                      ),
                      15.verticalSpace,
                      const LessonDetailsDropdownSection(),
                      15.verticalSpace,
                      // const StudentComprehensionLevelSection(),
                      // 15.verticalSpace,
                      const LearningOutcomeSection(),
                      15.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
