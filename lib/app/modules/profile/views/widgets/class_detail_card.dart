import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A card widget that displays and allows editing of class details.
class ClassDetailCard extends GetView<ProfileController> {
  /// Constructs a [ClassDetailCard].
  const ClassDetailCard({
    required this.classDetail,
    required this.index,
    super.key,
  });

  /// The class detail model.
  final ClassDetail classDetail;

  /// The index of this card in the list.
  final int index;

  @override
  /// Builds the UI for the class detail card.
  ///
  /// This method uses dropdowns and text fields to display and edit class
  /// information such as board, medium, class, subject, and student strength.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the class detail card.
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(vertical: 8.h),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.kEBEBEB),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Padding(
      padding: EdgeInsets.only(
        left: 27.w,
        right: 27.w,
        top: 33.h,
        bottom: index > 0 ? 17.h : 33.h,
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppDropdown(
              value: classDetail.board.value,
              onChanged: (String? val) {
                classDetail.board.value = val;
                classDetail.medium.value = null;
                classDetail.classClass.value = null;
                classDetail.subject.value = null;
                controller.formKey.currentState?.patchValue(<String, dynamic>{
                  'medium_$index': null,
                  'class_$index': null,
                  'subject_$index': null,
                });
              },
              label: LocaleKeys.board.tr,
              name: 'board_$index',
              items: controller.boardOptions.toList(),
              hintText: LocaleKeys.selectBoard.tr,
            ),
            16.verticalSpace,
            AppDropdown(
              value: classDetail.medium.value,
              onChanged: (String? val) {
                classDetail.medium.value = val;
                classDetail.classClass.value = null;
                classDetail.subject.value = null;
                controller.formKey.currentState?.patchValue(<String, dynamic>{
                  'class_$index': null,
                  'subject_$index': null,
                });
              },
              label: LocaleKeys.medium.tr,
              name: 'medium_$index',
              items: controller.getMediumOptionsForBoard(
                classDetail.board.value,
              ),
              hintText: LocaleKeys.selectMedium.tr,
            ),
            16.verticalSpace,
            AppDropdown(
              value: classDetail.classClass.value?.toString(),
              onChanged: (String? val) {
                classDetail.classClass.value = int.tryParse(val ?? '');
                classDetail.subject.value = null;
                controller.formKey.currentState?.patchValue(<String, dynamic>{
                  'subject_$index': null,
                });
              },
              label: LocaleKeys.classKey.tr,
              name: 'class_$index',
              items: controller.getClassOptionsForMedium(
                classDetail.board.value,
                classDetail.medium.value,
              ),
              hintText: LocaleKeys.selectClass.tr,
            ),
            16.verticalSpace,
            AppDropdown(
              value: classDetail.subject.value,
              onChanged: (String? val) {
                classDetail.subject.value = val;
                if (classDetail.subjectDetails?.isEmpty ?? true) {
                  classDetail.subjectDetails = controller.setSubjectDetail(
                    classDetail,
                  );
                }
              },
              label: LocaleKeys.subject.tr,
              name: 'subject_$index',
              items: controller.getSubjectOptionsForClass(
                classDetail.board.value,
                classDetail.medium.value,
                classDetail.classClass.value?.toString(),
                index,
              ),
              hintText: LocaleKeys.selectSubject.tr,
            ),
            16.verticalSpace,
            Row(
              children: <Widget>[
                Expanded(
                  child: ProfileTextField(
                    label: LocaleKeys.boysStrength.tr,
                    name: 'boys_$index',
                    enabled: false,
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: ProfileTextField(
                    label: LocaleKeys.girlsStrength.tr,
                    name: 'girls_$index',
                    enabled: false,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (index == controller.classDetails.length - 1)
                    SizedBox(
                      width: 80.w,
                      child: AppButton(
                        buttonText: LocaleKeys.add.tr,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          color: AppColors.kFFFFFF,
                        ),
                        onPressed: controller.addClassDetail,
                        buttonColor: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(4.r),
                        height: 40.h,
                      ),
                    ),
                  if (controller.classDetails.length != 1) ...<Widget>[
                    16.horizontalSpace,
                    SizedBox(
                      width: 80.w,
                      child: AppButton(
                        buttonText: LocaleKeys.delete.tr,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          color: AppColors.kFFFFFF,
                        ),
                        onPressed: () => controller.removeClassDetail(index),
                        buttonColor: AppColors.kDE3B40,
                        borderRadius: BorderRadius.circular(4.r),
                        height: 40.h,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
