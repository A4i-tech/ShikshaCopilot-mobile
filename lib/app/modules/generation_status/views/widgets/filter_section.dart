import 'package:sikshana/app/utils/exports.dart';

class FilterSection extends GetView<GenerationStatusController> {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 18.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8).r,
      border: Border.all(color: AppColors.k000000.withOpacity(0.1)),
    ),
    child: FormBuilder(
      key: controller.formKey,
      child: Column(
        children: <Widget>[
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
                            child: Text(e, style: AppTextStyle.lato()),
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
                            child: Text(e, style: AppTextStyle.lato()),
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
                            child: Text(e, style: AppTextStyle.lato()),
                          ),
                        )
                        .toList(),
                    onChanged: controller.onClassChanged,
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
                            child: Text(e, style: AppTextStyle.lato()),
                          ),
                        )
                        .toList(),
                    onChanged: controller.onSubjectChanged,
                    value: controller.selectedSubject.value,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
