import 'package:sikshana/app/modules/question_paper_generation/controllers/question_paper_generation_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that provides filters and search functionality for question paper generation.
class GenerationFiltersWidget
    extends GetView<QuestionPaperGenerationController> {
  @override
  /// Builds the UI for the generation filters widget.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying search input and expandable filter options.
  Widget build(BuildContext context) => FormBuilder(
    key: controller.formKey,
    child: Column(
      children: <Widget>[
        ProfileTextField(
          name: 'search',
          color: AppColors.kF6F8FA,
          borderColor: AppColors.k000000.withOpacity(0.1),
          onChanged: (String? val) {
            controller.searchQuestionBanksWithDebounce(val);
          },
          suffixIcon: InkWell(
            onTap: () {
              controller.showFilters.value = !controller.showFilters.value;
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50).r,
                border: Border.all(color: AppColors.kEBEBEB),
                color: AppColors.kFFFFFF,
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    LocaleKeys.filters.tr,
                    style: AppTextStyle.lato(color: AppColors.k565E6C),
                  ),
                  6.horizontalSpace,
                  SvgPicture.asset(AppImages.filter, height: 16.h, width: 16.w),
                ],
              ),
            ).paddingSymmetric(vertical: 6.h, horizontal: 16.w),
          ),
          hintWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(AppImages.search, height: 20.dg),
              3.horizontalSpace,
              Text(
                LocaleKeys.searchQuestionPaper.tr,
                style: AppTextStyle.lato(
                  color: AppColors.k6C7278,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
        14.verticalSpace,
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.topCenter,
          curve: Curves.easeIn,
          reverseDuration: const Duration(milliseconds: 250),
          child: Obx(
            () => !controller.showFilters.value
                ? const SizedBox.shrink()
                : Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 18.h,
                      horizontal: 18.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8).r,
                      border: Border.all(
                        color: AppColors.k000000.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        10.verticalSpace,
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            LocaleKeys.filters.tr,
                            style: AppTextStyle.lato(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        16.verticalSpace,
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Obx(
                                () => AppDropdown(
                                  label: LocaleKeys.board.tr,
                                  name: 'board',
                                  hintText: LocaleKeys.selectBoard.tr,
                                  items: controller.boards
                                      .map(
                                        (String e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: AppTextStyle.lato(),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: controller.onBoardChanged,
                                  value: controller.selectedBoard.value,
                                ),
                              ),
                            ),
                            6.horizontalSpace,
                            Expanded(
                              child: Obx(
                                () => AppDropdown(
                                  label: LocaleKeys.medium.tr,
                                  name: 'medium',
                                  hintText: LocaleKeys.selectMedium.tr,
                                  items: controller.mediums
                                      .map(
                                        (String e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: AppTextStyle.lato(),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: controller.onMediumChanged,
                                  value: controller.selectedMedium.value,
                                ),
                              ),
                            ),
                          ],
                        ),
                        12.verticalSpace,
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Obx(
                                () => AppDropdown(
                                  label: LocaleKeys.classKey.tr,
                                  name: 'class',
                                  hintText: LocaleKeys.selectClass.tr,
                                  items: controller.classes
                                      .map(
                                        (String e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: AppTextStyle.lato(),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: controller.onClassChanged,
                                  onClear: controller.selectedClass() == null
                                      ? null
                                      : () {
                                          controller.formKey.currentState
                                              ?.patchValue(<String, dynamic>{
                                                'class': null,
                                              });
                                          controller.onClassChanged(null);
                                        },
                                  value: controller.selectedClass.value,
                                ),
                              ),
                            ),
                            6.horizontalSpace,
                            Expanded(
                              child: Obx(
                                () => AppDropdown(
                                  label: LocaleKeys.subject.tr,
                                  name: 'subject',
                                  hintText: LocaleKeys.selectSubject.tr,
                                  items: controller.subjects
                                      .map(
                                        (String e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: AppTextStyle.lato(),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: controller.onSubjectChanged,
                                  onClear: controller.selectedSubject() == null
                                      ? null
                                      : () {
                                          controller.formKey.currentState
                                              ?.patchValue(<String, dynamic>{
                                                'subject': null,
                                              });
                                          controller.onSubjectChanged(null);
                                        },
                                  value: controller.selectedSubject.value,
                                ),
                              ),
                            ),
                          ],
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
