import 'package:sikshana/app/modules/question_paper/controllers/question_paper_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a stepper for the question paper generation process.
class StepperWidget extends GetView<QuestionPaperController> {
  /// Constructs a [StepperWidget].
  const StepperWidget({super.key});

  @override
  /// Builds the UI for the stepper widget.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Row` widget containing the steps of the process.
  Widget build(BuildContext context) => Obx(
    () => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildStep(context, 1, LocaleKeys.configuration.tr),
        _buildLine(context, 2),
        _buildStep(context, 2, LocaleKeys.template.tr),
        _buildLine(context, 3),
        _buildStep(context, 3, LocaleKeys.bluePrint.tr),
      ],
    ),
  );

  /// Builds a single step of the stepper.
  ///
  /// Parameters:
  /// - `context`: The build context.
  /// - `step`: The step number.
  /// - `title`: The title of the step.
  ///
  /// Returns:
  /// A `Widget` representing a single step.
  Widget _buildStep(BuildContext context, int step, String title) {
    final bool isActive = controller.currentStep.value >= step;
    return GestureDetector(
      onTap: () {
        if (isActive) {
          controller.tabController.animateTo(step - 1);
        }
      },
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundColor: controller.currentStep.value == step
                ? AppColors.kEDF6FE
                : isActive
                ? AppColors.k46A0F1
                : AppColors.kF3F4F6,
            child: Text(
              '$step',
              style: AppTextStyle.lato(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: controller.currentStep.value == step
                    ? AppColors.k46A0F1
                    : isActive
                    ? AppColors.kFFFFFF
                    : AppColors.k171A1F.withOpacity(0.3),
              ),
            ),
          ),
          5.verticalSpace,
          Text(
            title,
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: isActive ? null : AppColors.k171A1F.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a line connecting the steps of the stepper.
  ///
  /// Parameters:
  /// - `context`: The build context.
  /// - `step`: The step number to which the line leads.
  ///
  /// Returns:
  /// A `Widget` representing the connecting line.
  Widget _buildLine(BuildContext context, int step) {
    final bool isActive = controller.currentStep.value >= step;
    return Expanded(
      child: Container(
        height: 2,
        color: isActive
            ? AppColors.k46A0F1
            : AppColors.k171A1F.withOpacity(0.2),
      ),
    );
  }
}
