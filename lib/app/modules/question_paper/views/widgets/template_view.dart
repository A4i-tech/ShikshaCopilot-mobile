import 'package:sikshana/app/modules/question_paper/controllers/question_paper_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

import 'package:sikshana/app/modules/question_paper/controllers/question_paper_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A view that allows users to customize the question paper template.
class TemplateView extends StatefulWidget {
  /// Constructs a [TemplateView].
  const TemplateView({super.key});

  @override
  State<TemplateView> createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView>
    with AutomaticKeepAliveClientMixin<TemplateView> {
  @override
  bool get wantKeepAlive => true;

  /// The controller for the question paper generation.
  QuestionPaperController get controller => Get.find<QuestionPaperController>();
  @override
  /// Builds the UI for the template view.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` that allows customization of the question paper template.
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Step 2/3: ${LocaleKeys.questionPaperKey.tr} ${LocaleKeys.template.tr}',
            style: AppTextStyle.lato(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          12.verticalSpace,
          Text(
            LocaleKeys.customizeTheQuestionPaperTemplate.tr,
            style: AppTextStyle.lato(
              fontSize: 12.sp,
              color: AppColors.k141522.withOpacity(0.45),
            ),
          ),
          20.verticalSpace,
          Row(
            children: <Widget>[
              Text(
                LocaleKeys.template.tr,
                style: AppTextStyle.lato(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${LocaleKeys.totalMarks.tr}:${controller.totalMarks.value}',
                style: AppTextStyle.lato(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          20.verticalSpace,
          FormBuilder(
            key: controller.templateFormKey,
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.questionTemplates.length,
                itemBuilder: (BuildContext context, int index) => Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          controller.templateDistributedMarks.value
                                  .toString() ==
                              controller.totalMarks.value
                          ? AppColors.k000000.withOpacity(0.1)
                          : AppColors.kFFC11E,
                    ),
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ProfileMultiSelectDropdown(
                          label:
                              '${LocaleKeys.question.tr} ${LocaleKeys.type.tr}',
                          name: 'question_type_$index',
                          labelStyle: AppTextStyle.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            color: AppColors.k424955,
                          ),
                          validator: (List<String>? value) =>
                              value?.isEmpty ?? true
                              ? '${LocaleKeys.question.tr} '
                                    '${LocaleKeys.type.tr} '
                                    '${LocaleKeys.required.tr}'
                              : null,
                          items: questionTypes.keys.toList(),
                          hintText:
                              '${LocaleKeys.question.tr} ${LocaleKeys.type.tr}',
                          onChanged: (List<String>? value) {
                            if (value?.isEmpty ?? true) {
                              controller.questionTemplates[index] = controller
                                  .questionTemplates[index]
                                  .copyWith();
                            } else {
                              controller.questionTemplates[index] = controller
                                  .questionTemplates[index]
                                  .copyWith(type: value!.first);
                            }
                          },
                        ),
                        16.verticalSpace,
                        ProfileTextField(
                          label: LocaleKeys.numberOfQuestions.tr,
                          name: 'number_of_questions_$index',
                          validator: (String? value) => value?.isEmpty ?? true
                              ? '${LocaleKeys.numberOfQuestions.tr} '
                                    '${LocaleKeys.required.tr}'
                              : null,
                          onChanged: (String? value) {
                            if (value?.isEmpty ?? true) {
                              controller.questionTemplates[index] = controller
                                  .questionTemplates[index]
                                  .copyWith();
                            } else {
                              controller.questionTemplates[index] = controller
                                  .questionTemplates[index]
                                  .copyWith(
                                    numberOfQuestions: int.tryParse(value!),
                                  );
                            }
                          },
                        ),
                        16.verticalSpace,
                        ProfileTextField(
                          label: LocaleKeys.marksPerQuestion.tr,
                          name: 'marks_per_question_$index',
                          validator: (String? value) => value?.isEmpty ?? true
                              ? '${LocaleKeys.marksPerQuestion.tr} '
                                    '${LocaleKeys.required.tr}'
                              : null,
                          onChanged: (String? value) {
                            if (value?.isEmpty ?? true) {
                              controller.questionTemplates[index] = controller
                                  .questionTemplates[index]
                                  .copyWith();
                            } else {
                              controller.questionTemplates[index] = controller
                                  .questionTemplates[index]
                                  .copyWith(
                                    marksPerQuestion: int.tryParse(value!),
                                  );
                            }
                          },
                        ),
                        16.verticalSpace,
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Flexible(flex: 2, child: SizedBox.shrink()),
                              Flexible(
                                child: AppButton(
                                  buttonText: LocaleKeys.delete.tr,
                                  style: AppTextStyle.lato(
                                    fontSize: 14.sp,
                                    color: AppColors.kFFFFFF,
                                  ),
                                  buttonColor: AppColors.kDE1A1A,
                                  borderRadius: BorderRadius.circular(4),
                                  onPressed: () =>
                                      controller.removeQuestionTemplate(index),
                                  height: 36.h,
                                ),
                              ),
                              Flexible(
                                child:
                                    index + 1 ==
                                        controller.questionTemplates.length
                                    ? AppButton(
                                        buttonText: LocaleKeys.add.tr,
                                        style: AppTextStyle.lato(
                                          fontSize: 14.sp,
                                          color: AppColors.kFFFFFF,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                        onPressed:
                                            controller.addQuestionTemplate,
                                        height: 36.h,
                                      ).paddingOnly(left: 6.w)
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '[ ${LocaleKeys.totalMarksDistributed.tr}/${LocaleKeys.totalMarks.tr} ] : [ ${controller.templateDistributedMarks.value}/${controller.totalMarks.value} ]',
                  style: AppTextStyle.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!(controller.templateDistributedMarks.value.toString() ==
                    controller.totalMarks.value)) ...<Widget>[
                  6.verticalSpace,
                  Text(
                    LocaleKeys.theTotalMarksDistributedInTheTemplate.tr,
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.bold,
                      color: AppColors.kFFC11E,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
