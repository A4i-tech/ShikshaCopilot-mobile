import 'package:flutter/material.dart';
import 'package:sikshana/app/utils/exports.dart';

class LearningOutcomeResourceEditableSection
    extends GetView<LessonResourceGenerationDetailsController> {
  const LearningOutcomeResourceEditableSection({Key? key}) : super(key: key);

  String _numberedText(String value) {
    final List<String> lines = value
        .split('\n')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    return List.generate(
      lines.length,
      (index) => '${index + 1}. ${lines[index]}',
    ).join('\n');
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // ✅ Fixed height + empty state
      Container(
        constraints: const BoxConstraints(
          minHeight: 200, // Prevents shrinking
          maxHeight: 300,
        ),
        child: Obx(() {
          // ✅ Primary empty state check
          if (controller.currentLearningOutcomes == null ||
              controller.currentLearningOutcomes!.isEmpty) {
            return _emptyState();
          }

          return controller.isEditing.value
              ? _editableField()
              : ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller.learningOutcomeControllers,
                  builder: (context, value, child) {
                    final displayText = _numberedText(value.text);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kFFFFFF,
                        border: Border.all(color: AppColors.kDEE1E6),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: SelectableText(
                        displayText,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.k84828A,
                        ),
                        maxLines: null,
                      ),
                    );
                  },
                );
        }),
      ),
      const SizedBox(height: 16),

      // ✅ Hide buttons when empty
      Obx(
        () =>
            (controller.currentLearningOutcomes == null ||
                controller.currentLearningOutcomes!.isEmpty)
            ? const SizedBox.shrink()
            : Row(
                children: <Widget>[
                  if (!controller.isEditing.value)
                    Expanded(
                      child: AppButton(
                        buttonText: LocaleKeys.edit.tr,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kFFFFFF,
                        ),
                        onPressed: () {
                          controller.learningOutcomeControllers.text =
                              controller.currentLearningOutcomes?.join('\n') ??
                              '';
                          controller.isEditing.value = true;
                        },
                        buttonColor: AppColors.k46A0F1,
                        borderRadius: BorderRadius.circular(4.r),
                        height: 40.h,
                      ),
                    )
                  else ...<Widget>[
                    Expanded(
                      child: AppButton(
                        buttonText: LocaleKeys.update.tr,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kFFFFFF,
                        ),
                        onPressed: _onUpdate,
                        buttonColor: AppColors.k46A0F1,
                        borderRadius: BorderRadius.circular(4.r),
                        height: 40.h,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        buttonText: LocaleKeys.reset.tr,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.k46A0F1,
                        ),
                        onPressed: _onReset,
                        buttonColor: AppColors.kFFFFFF,
                        borderSide: const BorderSide(color: AppColors.k46A0F1),
                        borderRadius: BorderRadius.circular(4.r),
                        height: 40.h,
                      ),
                    ),
                  ],
                ],
              ),
      ),
      const SizedBox(height: 16),
    ],
  );

  // ✅ Empty state widget
  Widget _emptyState() => Container(
    height: 200, // Match container constraints
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      border: Border.all(color: AppColors.kDEE1E6),
      borderRadius: BorderRadius.circular(4.r),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu_book_outlined, size: 48.sp, color: AppColors.k84828A),
        const SizedBox(height: 12),
        Text(
          'No learning outcomes available.',
          style: AppTextStyle.lato(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.k84828A,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _editableField() => TextField(
    controller: controller.learningOutcomeControllers,
    minLines: 10,
    maxLines: 20,
    keyboardType: TextInputType.multiline,
    style: AppTextStyle.lato(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.k84828A,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      hintText: 'Enter learning outcomes, one per line...',
      hintStyle: AppTextStyle.lato(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.grey[400],
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: AppColors.kDEE1E6),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: AppColors.kDEE1E6),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: AppColors.k46A0F1, width: 2),
      ),
    ),
  );

  void _onUpdate() {
    final cleanText = controller.learningOutcomeControllers.text;
    final lines = cleanText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
    controller.currentLearningOutcomes?.assignAll(lines);
    controller.isEditing.value = false;
  }

  void _onReset() {
    controller.learningOutcomeControllers.text =
        controller.currentLearningOutcomes?.join('\n') ?? '';
    controller.isEditing.value = false;
  }
}
