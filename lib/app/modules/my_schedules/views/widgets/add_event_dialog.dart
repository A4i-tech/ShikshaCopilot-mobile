import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/modules/my_schedules/views/widgets/form_builder_date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:sikshana/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Dialog widget for adding, editing, or viewing schedule events.
///
/// This dialog provides a form interface for managing schedule events
/// with fields for board, medium, class, subject, chapter, subtopic,
/// lesson plan, date, and time selection.
///
/// The dialog supports three modes:
/// - Add: Create a new event
/// - Edit: Modify an existing event
/// - View: Display event details in read-only mode
class AddEventDialog extends GetView<MySchedulesController> {
  /// Creates an [AddEventDialog] widget.
  ///
  /// Parameters:
  /// - [day]: The date for the event (required).
  /// - [event]: Existing event data for edit/view mode (optional).
  /// - [key]: Widget key for identification (optional).
  AddEventDialog({required this.day, this.event, super.key});

  /// The selected date for the event.
  ///
  /// Used as the initial value for the date picker in the form.
  final DateTime day;

  /// The existing event data when editing or viewing.
  ///
  /// Null when creating a new event.
  final Event? event;

  @override
  Widget build(BuildContext context) => AlertDialog(
    titlePadding: EdgeInsets.zero,
    shape: BeveledRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(4.r),
    ),
    actionsPadding: EdgeInsets.zero,
    actionsOverflowButtonSpacing: 0,
    buttonPadding: EdgeInsets.zero,
    contentPadding: EdgeInsets.zero,
    title: Container(
      padding: EdgeInsets.only(
        top: 26.h,
        bottom: 16.h,
        left: 26.w,
        right: 26.w,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.kDEE1E6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            controller.eventDialog() == EventDialog.view
                ? LocaleKeys.viewDetails.tr
                : controller.eventDialog() == EventDialog.edit
                ? LocaleKeys.editDetails.tr
                : LocaleKeys.addDetails.tr,
            style: AppTextStyle.lato(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: CircleAvatar(
              radius: 16.h,
              backgroundColor: AppColors.kF3F4F6,
              child: Icon(Icons.close, size: 18.h, color: AppColors.k303030),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    ),
    content: Container(
      padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 26.w, right: 26.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.kDEE1E6, width: 2)),
      ),
      width: Get.width * 0.9,
      height: Get.height * 0.7,
      child: Obx(() {
        // Show loading indicator when fetching event details
        if (controller.eventDialog() != EventDialog.add &&
            controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final scheduleDetails = controller.scheduleById.value?.data;

        // Show error message if event details couldn't be loaded
        if (controller.eventDialog() != EventDialog.add &&
            scheduleDetails == null) {
          return Center(
            child: Text(
              LocaleKeys.couldntLoadEventDetail.tr,
              style: AppTextStyle.lato(),
            ),
          );
        }

        return FormBuilder(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Board selection dropdown
                ProfileMultiSelectDropdown(
                  label: LocaleKeys.board.tr,
                  name: 'board',
                  enabled: controller.eventDialog() != EventDialog.view,
                  items: controller.boards,
                  hintText: LocaleKeys.selectTheBoard.tr,
                  labelStyle: AppTextStyle.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.k424955,
                  ),
                  onChanged: (List<String>? vals) {
                    controller.onBoardChanged(vals?.firstOrNull);
                  },
                  validator: (List<String>? vals) => (vals?.isEmpty ?? true)
                      ? LocaleKeys.boardIsRequired.tr
                      : null,
                ),
                16.verticalSpace,

                /// Medium selection dropdown
                ProfileMultiSelectDropdown(
                  label: LocaleKeys.medium.tr,
                  name: 'medium',
                  enabled: controller.eventDialog() != EventDialog.view,
                  items: controller.mediums,
                  hintText: LocaleKeys.selectTheMedium.tr,
                  labelStyle: AppTextStyle.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.k424955,
                  ),
                  onChanged: (List<String>? vals) {
                    controller.onMediumChanged(vals?.firstOrNull);
                  },
                  validator: (List<String>? vals) => (vals?.isEmpty ?? true)
                      ? LocaleKeys.mediumIsRequired.tr
                      : null,
                ),
                16.verticalSpace,

                /// Class name selection dropdown
                ProfileMultiSelectDropdown(
                  label: LocaleKeys.className.tr,
                  name: 'class_name',
                  enabled: controller.eventDialog() != EventDialog.view,
                  items: controller.classNames,
                  hintText: LocaleKeys.selectClass.tr,
                  labelStyle: AppTextStyle.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.k424955,
                  ),
                  onChanged: (List<String>? vals) {
                    controller.onClassChanged(vals?.firstOrNull);
                  },
                  validator: (List<String>? vals) => (vals?.isEmpty ?? true)
                      ? LocaleKeys.classIsRequired.tr
                      : null,
                ),
                16.verticalSpace,

                /// Subject selection dropdown
                ProfileMultiSelectDropdown(
                  label: LocaleKeys.subject.tr,
                  name: 'subject',
                  enabled: controller.eventDialog() != EventDialog.view,
                  items: controller.subjects,
                  hintText: LocaleKeys.selectSubject.tr,
                  labelStyle: AppTextStyle.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.k424955,
                  ),
                  onChanged: (List<String>? vals) {
                    controller.onSubjectChanged(vals?.firstOrNull);
                  },
                  validator: (List<String>? vals) => (vals?.isEmpty ?? true)
                      ? LocaleKeys.subjectIsRequired.tr
                      : null,
                ),
                16.verticalSpace,

                /// Chapter selection dropdown
                ProfileMultiSelectDropdown(
                  label: LocaleKeys.chapter.tr,
                  name: 'chapter',
                  enabled: controller.eventDialog() != EventDialog.view,
                  items: controller.chapters(),
                  hintText: LocaleKeys.selectTheChapter.tr,
                  labelStyle: AppTextStyle.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.k424955,
                  ),
                  onChanged: (List<String>? vals) {
                    controller.onChapterChanged(vals?.firstOrNull);
                  },
                  validator: (List<String>? vals) => (vals?.isEmpty ?? true)
                      ? LocaleKeys.chapterIsRequired.tr
                      : null,
                ),
                16.verticalSpace,

                /// Subtopic selection dropdown
                ProfileMultiSelectDropdown(
                  label: LocaleKeys.subTopic.tr,
                  name: 'sub_topic',
                  enabled: controller.eventDialog() != EventDialog.view,
                  items: controller.subTopics(),
                  hintText: LocaleKeys.selectTheSubTopic.tr,
                  labelStyle: AppTextStyle.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.k424955,
                  ),
                  onChanged: (List<String>? vals) {
                    controller.onSubTopicsChanged(vals?.firstOrNull);
                  },
                  validator: (List<String>? vals) => (vals?.isEmpty ?? true)
                      ? LocaleKeys.subtopicIsRequired.tr
                      : null,
                ),
                16.verticalSpace,

                /// Lesson plan selection dropdown
                ProfileMultiSelectDropdown(
                  label: LocaleKeys.lessonPlan.tr,
                  name: 'lesson_plan',
                  enabled: controller.eventDialog() != EventDialog.view,
                  items: controller.lessonPlans,
                  hintText: LocaleKeys.selectTheLessonPlan.tr,
                  labelStyle: AppTextStyle.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.k424955,
                  ),
                  onChanged: (List<String>? vals) {
                    controller.onLessonPlanChanged(vals?.firstOrNull);
                  },
                  validator: (List<String>? vals) => (vals?.isEmpty ?? true)
                      ? LocaleKeys.selectAny1LessonPlanToProceed.tr
                      : null,
                ),

                // Show "Add Lesson Plan" button only in add/edit modes
                if (controller.eventDialog() != EventDialog.view) ...<Widget>[
                  16.verticalSpace,
                  SizedBox(
                    width: Get.width / 3,
                    child: AppButton(
                      buttonText: '${LocaleKeys.addLessonPlan.tr} +',
                      style: AppTextStyle.lato(
                        fontSize: 12.sp,
                        color: AppColors.kFFFFFF,
                      ),
                      height: 36.h,
                      borderRadius: BorderRadius.circular(3).r,
                      onPressed: () {
                        Get.back(closeOverlays: true);
                        if (Get.isRegistered<NavigationScreenController>()) {
                          final NavigationScreenController shellController =
                              Get.find<NavigationScreenController>();
                          if (shellController.isMainTab(
                            Routes.CONTENT_GENERATION,
                          )) {
                            final int index = shellController.routes.indexOf(
                              Routes.CONTENT_GENERATION,
                            );
                            shellController.changeTab(index);
                          }
                        }
                      },
                    ),
                  ),
                ],
                16.verticalSpace,

                /// Date picker field
                FormBuilderDateTimePickerWidget(
                  name: 'date',
                  label: LocaleKeys.date.tr,
                  initialValue: day,
                  enabled: controller.eventDialog() != EventDialog.view,
                  inputType: InputType.date,
                  format: DateFormat('E, MMM d'),
                  suffixIcon: Icons.calendar_today_outlined,
                  validator: (DateTime? val) =>
                      val == null ? LocaleKeys.dateIsRequired.tr : null,
                ),
                16.verticalSpace,

                /// Start time picker field
                FormBuilderDateTimePickerWidget(
                  name: 'start_time',
                  label: LocaleKeys.startTime.tr,
                  enabled: controller.eventDialog() != EventDialog.view,
                  inputType: InputType.time,
                  format: DateFormat('h:mm a'),
                  suffixIcon: CupertinoIcons.clock,
                  onChanged: (DateTime? val) {
                    controller.formKey.currentState?.fields['end_time']
                        ?.validate();
                  },
                  validator: (DateTime? val) {
                    if (val == null) {
                      return LocaleKeys.startTimeRequired.tr;
                    }
                    final DateTime? endTime =
                        controller
                                .formKey
                                .currentState
                                ?.fields['end_time']
                                ?.value
                            as DateTime?;
                    if (endTime != null &&
                        (val.isAfter(endTime) ||
                            val.isAtSameMomentAs(endTime))) {
                      return LocaleKeys.startTimeLessThanEnd.tr;
                    }
                    return null;
                  },
                ),
                16.verticalSpace,

                /// End time picker field
                FormBuilderDateTimePickerWidget(
                  name: 'end_time',
                  label: LocaleKeys.endTime.tr,
                  enabled: controller.eventDialog() != EventDialog.view,
                  inputType: InputType.time,
                  format: DateFormat('h:mm a'),
                  suffixIcon: CupertinoIcons.clock,
                  onChanged: (DateTime? val) {
                    controller.formKey.currentState?.fields['end_time']
                        ?.validate();
                  },
                  validator: (DateTime? val) {
                    if (val == null) {
                      return LocaleKeys.endTimeRequired.tr;
                    }
                    final DateTime? startTime =
                        controller
                                .formKey
                                .currentState
                                ?.fields['start_time']
                                ?.value
                            as DateTime?;
                    if (startTime != null &&
                        (val.isBefore(startTime) ||
                            val.isAtSameMomentAs(startTime))) {
                      return LocaleKeys.endTimeGreaterThanStart.tr;
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
              ],
            ),
          ),
        );
      }),
    ),
    actions: <Widget>[
      // Hide action buttons in view mode
      controller.eventDialog() == EventDialog.view
          ? const SizedBox.shrink()
          : Container(
              padding: EdgeInsets.only(
                bottom: 22.h,
                top: 22.h,
                left: 26.w,
                right: 26.w,
              ),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.kDEE1E6)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /// Cancel button - closes the dialog without saving
                  SizedBox(
                    width: 80.w,
                    child: AppButton(
                      buttonText: LocaleKeys.cancel.tr,
                      onPressed: () {
                        Get.back();
                      },
                      buttonColor: AppColors.k46A0F1.withValues(alpha: 0.6),
                      height: 36.h,
                      borderRadius: BorderRadius.circular(3).r,
                    ),
                  ),
                  7.horizontalSpace,

                  /// Save button - validates and saves the event
                  SizedBox(
                    width: 80.w,
                    child: AppButton(
                      buttonText: LocaleKeys.save.tr,
                      onPressed: controller.saveEvent,
                      height: 36.h,
                      borderRadius: BorderRadius.circular(3).r,
                      icon: Icon(
                        Icons.check_rounded,
                        size: 16.h,
                        color: AppColors.kFFFFFF,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    ],
  );
}
