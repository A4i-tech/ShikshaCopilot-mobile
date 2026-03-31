import 'package:sikshana/app/modules/question_paper/views/widgets/blueprint_view.dart';
import 'package:sikshana/app/modules/question_paper/views/widgets/configuration_view.dart';
import 'package:sikshana/app/modules/question_paper/views/widgets/stepper_widget.dart';
import 'package:sikshana/app/modules/question_paper/views/widgets/template_view.dart';
import 'package:sikshana/app/utils/exports.dart';
import '../controllers/question_paper_controller.dart';

/// A view for generating a question paper, guiding the user through multiple steps.
class QuestionPaperView extends GetView<QuestionPaperController> {
  /// Constructs a [QuestionPaperView].
  const QuestionPaperView({super.key});

  @override
  /// Builds the UI for the question paper generation screen.
  ///
  /// This includes a stepper, tabbed views for configuration, template, and
  /// blueprint, and navigation buttons.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the question paper generation UI.
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>()..onReConnect = controller.onInit;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : Scaffold(
              key: scaffoldKey,
              appBar: CommonAppBar(
                scaffoldKey: scaffoldKey,
                title: LocaleKeys.questionPaperGeneration.tr,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  controller.onInit();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      24.verticalSpace,
                      const StepperWidget(),
                      24.verticalSpace,
                      Expanded(
                        child: TabBarView(
                          controller: controller.tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: const <Widget>[
                            ConfigurationView(),
                            TemplateView(),
                            BlueprintView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                child: Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (controller.currentStep > 1) ...<Widget>[
                        Flexible(
                          child: AppButton(
                            buttonColor: AppColors.kFFFFFF,
                            borderSide: const BorderSide(
                              color: AppColors.k46A0F1,
                            ),
                            buttonText: LocaleKeys.previous.tr,
                            buttonTextColor: AppColors.k46A0F1,
                            onPressed: controller.onPreviousPressed,
                            borderRadius: BorderRadius.circular(4).r,
                            height: 40.h,
                          ),
                        ),
                        10.horizontalSpace,
                      ],
                      Flexible(
                        flex: controller.currentStep > 2 ? 2 : 1,
                        child: AppButton(
                          buttonText: controller.currentStep > 2
                              ? LocaleKeys.generateQuestionPaper.tr
                              : LocaleKeys.next.tr,
                          onPressed: controller.currentStep > 2
                              ? controller.onGenerateQuestionPaper
                              : controller.onNextPressed,
                          borderRadius: BorderRadius.circular(4).r,
                          height: 40.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
