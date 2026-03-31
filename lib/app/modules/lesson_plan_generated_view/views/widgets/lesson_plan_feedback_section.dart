import 'package:sikshana/app/utils/exports.dart';

class LessonPlanFeedbackSection
    extends GetView<LessonPlanGeneratedViewController> {
  const LessonPlanFeedbackSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;
    final bool isFeedbackPresent =
        controller.lessonPlan.value?.data.feedback != null;
    return Obx(
      () => Column(
        children: [
          if (!controller.showFeedbackSection.value)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.kFFFFFF,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.kDEE1E6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' Lesson Feedback',
                    style: AppTextStyle.lato(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.k000000,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.k000000,
                    ),
                    onPressed: controller.toggleFeedbackSection,
                  ),
                ],
              ),
            ),

          if (controller.showFeedbackSection.value) ...[
            16.verticalSpace,

            // Feedback Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.kFFFFFF,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.kDEE1E6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Collapse Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.lessonPlanFeedback.tr,
                        style: AppTextStyle.lato(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.k344767,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_up,
                          color: AppColors.k6C7278,
                        ),
                        onPressed: controller.toggleFeedbackSection,
                      ),
                    ],
                  ),

                  24.verticalSpace,

                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          value: LocaleKeys.notMeet.tr,
                          groupValue: controller.feedbackRadioValue.value,
                          onChanged: isFeedbackPresent
                              ? null
                              : (String? v) =>
                                    controller.feedbackRadioValue.value = v!,
                          enabled: !isFeedbackPresent,
                          title: Text(
                            LocaleKeys.notMeet.tr,
                            style: AppTextStyle.lato(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.k171A1F,
                            ),
                          ),
                        ),
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          value: LocaleKeys.improvementNeeded.tr,
                          groupValue: controller.feedbackRadioValue.value,
                          onChanged: isFeedbackPresent
                              ? null
                              : (String? v) =>
                                    controller.feedbackRadioValue.value = v!,
                          enabled: !isFeedbackPresent,
                          title: Text(
                            LocaleKeys.improvementNeeded.tr,
                            style: AppTextStyle.lato(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.k171A1F,
                            ),
                          ),
                        ),
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          value: LocaleKeys.veryGood.tr,
                          groupValue: controller.feedbackRadioValue.value,
                          onChanged: isFeedbackPresent
                              ? null
                              : (String? v) =>
                                    controller.feedbackRadioValue.value = v!,
                          enabled: !isFeedbackPresent,
                          title: Text(
                            LocaleKeys.veryGood.tr,
                            style: AppTextStyle.lato(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.k171A1F,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  24.verticalSpace,

                  TextFormField(
                    controller: controller.feedbackCommentController,
                    minLines: 2,
                    maxLines: 5,
                    enabled: !isFeedbackPresent,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.leaveCommentsHint.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.kDEE1E6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                    style: AppTextStyle.lato(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ],
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.feedbackRadioValue.value.isNotEmpty
                        ? controller.saveLessonPlan
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.feedbackRadioValue.value.isNotEmpty
                          ? AppColors.k46A0F1
                          : AppColors.k46A0F1.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.saveLessonPlan.tr,
                      style: AppTextStyle.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.kFFFFFF,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Visibility(
                visible: fromPage == FromPage.generate,
                child: Expanded(
                  child: OutlinedButton(
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const RegeneratePlanDialog(),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.k46A0F1,
                      side: const BorderSide(
                        color: AppColors.k46A0F1,
                        width: 1.7,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.regenerate.tr,
                      style: AppTextStyle.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.k46A0F1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          24.verticalSpace,

          Obx(
            () => Visibility(
              visible:
                  controller
                      .regenerateLimitResponse
                      .value
                      ?.data
                      ?.regenerationLimitReached ??
                  false,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kFEF6F1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.icWarningOrange,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You have reached the daily limit of 3 attempts to regenerating the lesson plan. Please try tomorrow',
                        maxLines: 4,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.k141522,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegeneratePlanDialog extends StatefulWidget {
  /// Constructs a dialog prompting user feedback before regenerating a plan.
  const RegeneratePlanDialog({Key? key}) : super(key: key);

  @override
  _RegeneratePlanDialogState createState() => _RegeneratePlanDialogState();
}

/// Internal state for [RegeneratePlanDialog].
///
/// Maintains whether the regenerate button should be enabled based on whether
/// any feedback field has been filled.
class _RegeneratePlanDialogState extends State<RegeneratePlanDialog> {
  /// The controller handling lesson plan generation & regeneration.
  final LessonPlanGeneratedViewController controller =
      Get.find<LessonPlanGeneratedViewController>();

  /// Whether the "Regenerate" button should be enabled.
  bool canRegenerate = false;

  /// Updates the `canRegenerate` flag based on feedback field inputs.
  void _updateCanRegenerate() {
    setState(() {
      canRegenerate =
          controller.engageFeedbackController.text.trim().isNotEmpty ||
          controller.exploreFeedbackController.text.trim().isNotEmpty ||
          controller.explainFeedbackController.text.trim().isNotEmpty ||
          controller.elaborateFeedbackController.text.trim().isNotEmpty ||
          controller.evaluateFeedbackController.text.trim().isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    /// Attach listeners to all feedback controllers.
    controller.engageFeedbackController.addListener(_updateCanRegenerate);
    controller.exploreFeedbackController.addListener(_updateCanRegenerate);
    controller.explainFeedbackController.addListener(_updateCanRegenerate);
    controller.elaborateFeedbackController.addListener(_updateCanRegenerate);
    controller.evaluateFeedbackController.addListener(_updateCanRegenerate);
  }

  @override
  void dispose() {
    /// Remove listeners only (controllers are owned externally).
    controller.engageFeedbackController.removeListener(_updateCanRegenerate);
    controller.exploreFeedbackController.removeListener(_updateCanRegenerate);
    controller.explainFeedbackController.removeListener(_updateCanRegenerate);
    controller.elaborateFeedbackController.removeListener(_updateCanRegenerate);
    controller.evaluateFeedbackController.removeListener(_updateCanRegenerate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Header row
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    LocaleKeys.regeneratePlan.tr,
                    style: AppTextStyle.lato(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(AppImages.icRemoveBlack),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Warning box
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.kFEF6F1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        AppImages.icWarningOrange,
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ' ${LocaleKeys.note.tr} :',
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.k141522,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    LocaleKeys.regeneratePlanNote.tr,
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp,
                      color: AppColors.k344767,
                    ),
                  ),
                ],
              ),
            ),

            /// Feedback fields for all 5 phases
            _FeedbackPhaseField(
              label: LocaleKeys.engage.tr,
              controller: controller.engageFeedbackController,
            ),
            _FeedbackPhaseField(
              label: LocaleKeys.explore.tr,
              controller: controller.exploreFeedbackController,
            ),
            _FeedbackPhaseField(
              label: LocaleKeys.explain.tr,
              controller: controller.explainFeedbackController,
            ),
            _FeedbackPhaseField(
              label: LocaleKeys.elaborate.tr,
              controller: controller.elaborateFeedbackController,
            ),
            _FeedbackPhaseField(
              label: LocaleKeys.evaluate.tr,
              controller: controller.evaluateFeedbackController,
            ),

            const SizedBox(height: 18),

            /// Footer buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                /// Cancel
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.k46A0F1,
                    side: const BorderSide(
                      color: AppColors.k46A0F1,
                      width: 1.7,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.cancel.tr,
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.k46A0F1,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// Regenerate button
                ElevatedButton.icon(
                  onPressed: canRegenerate
                      ? () async {
                          await controller.regenerateLessonPlanFromDialog();
                          Navigator.of(context).pop();
                        }
                      : null,
                  icon: SvgPicture.asset(AppImages.icRegenerate),
                  label: Text(
                    LocaleKeys.regeneratePlanButton.tr,
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.kFFFFFF,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.k46A0F1.withOpacity(
                      canRegenerate ? 1.0 : 0.3,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// A reusable widget for showing a text field for a specific lesson phase.
///
/// Parameters:
/// - [label]: The phase name (Engage, Explore, Explain, etc.)
/// - [controller]: The text controller for that phase input
class _FeedbackPhaseField extends StatelessWidget {
  /// Constructs a field block for a single phase of feedback.
  const _FeedbackPhaseField({
    required this.label,
    required this.controller,
    Key? key,
  }) : super(key: key);

  /// Label of the phase (e.g., "Engage").
  final String label;

  /// Text controller for user input for the given phase.
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      /// Phase label
      Text(
        label,
        style: AppTextStyle.lato(
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
          color: AppColors.k565E6C,
        ),
      ),

      const SizedBox(height: 4),

      /// Input field
      TextFormField(
        controller: controller,
        style: AppTextStyle.lato(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.k424955,
        ),
        decoration: InputDecoration(
          hintText: LocaleKeys.enterFeedback.tr,
          isDense: true,
          filled: true,
          fillColor: AppColors.kF3F4F6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 14,
          ),
        ),
      ),

      const SizedBox(height: 12),
    ],
  );
}
