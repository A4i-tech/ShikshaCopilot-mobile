import 'package:sikshana/app/modules/lesson_resource_generation_details/views/widgets/learning_outcome_resource_section.dart';
import 'package:sikshana/app/modules/lesson_resource_generation_details/views/widgets/lesson_resource_dropdown_Section.dart';
import 'package:sikshana/app/utils/exports.dart';

/// The view for the lesson resource generation details screen.
class LessonResourceGenerationDetailsView
    extends GetView<LessonResourceGenerationDetailsController> {
  /// Creates a [LessonResourceGenerationDetailsView] object.
  const LessonResourceGenerationDetailsView({super.key});

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
                        LocaleKeys.lessonResources.tr,
                        style: AppTextStyle.lato(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.k141522,
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                        () => Text(
                          'Info: Lesson Plan Type-5E , Board-${controller.currentBoard.value}',
                          style: AppTextStyle.lato(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.k344767,
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      const LessonResourceDropdownSection(),
                      15.verticalSpace,
                      const StudentComprehensionLevelSection(),
                      15.verticalSpace,
                      const LearningOutcomeResourceSection(),
                      15.verticalSpace,
                      SizedBox(
                        width: 200.w,
                        height: 35.h,
                        child: Obx(() {
                          final isEnabled =
                              controller.isFormValid.value &&
                              !controller.isLoadingGenerateResource.value;
                          if (!isEnabled) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  controller.isLoadingGenerateResource.value
                                      ? "Generating..."
                                      : 'Complete all fields', // Or add LocaleKeys.incompleteForm.tr
                                  style: AppTextStyle.lato(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            );
                          }
                          return AppButton(
                            buttonText: LocaleKeys.generateLessonResource.tr,
                            loader: controller.isLoadingGenerateResource.value,
                            style: AppTextStyle.lato(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kFFFFFF,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            onPressed: controller.generateResource,
                          );
                        }),
                      ),
                      20.verticalSpace, // Extra spacing at bottom
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
