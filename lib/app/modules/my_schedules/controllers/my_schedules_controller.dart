import 'dart:math';

import 'package:intl/intl.dart';
import 'package:sikshana/app/modules/my_schedules/models/my_schedules_model.dart'
    hide MySchedules, Class;
import 'package:sikshana/app/modules/my_schedules/controllers/my_schedules_mixin.dart';
import 'package:sikshana/app/modules/my_schedules/models/chapter_filter_model.dart'
    hide Data;
import 'package:sikshana/app/modules/my_schedules/models/create_schedule_model.dart'
    hide Data;
import 'package:sikshana/app/modules/my_schedules/models/lesson_plan_model.dart'
    as lp;
import 'package:sikshana/app/modules/my_schedules/models/myschedules_model.dart'
    hide Lesson;
import 'package:sikshana/app/modules/my_schedules/models/schedule_by_id_model.dart';
import 'package:sikshana/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';
import 'package:sikshana/app/modules/profile/models/me_model.dart' hide Data;
import 'package:sikshana/app/utils/exports.dart' hide Data;

/// Enum to differentiate between the user's own schedule and others' schedules.
enum ScheduleView {
  /// Represents the current user's schedule.
  my,

  /// Represents other users' schedules.
  others,
}

/// Enum to define the mode of the event dialog.
enum EventDialog {
  /// The dialog is for adding a new event.
  add,

  /// The dialog is for viewing an existing event's details.
  view,

  /// The dialog is for editing an existing event.
  edit,
}

/// Controller for the "My Schedules" feature.
///
/// This controller manages the state and logic for displaying, creating,
/// editing, and deleting schedules. It handles fetching data from the API,
/// managing the calendar view, and interacting with the event dialogs.
class MySchedulesController extends GetxController
    with MySchedulesMixin, GetSingleTickerProviderStateMixin {
  late TabController tabController;

  /// A reactive list of subtopic data used for populating dropdowns.
  final RxList<lp.Subtopic> subtopicData = <lp.Subtopic>[].obs;

  /// A reactive list of lesson data used for populating dropdowns.
  final RxList<lp.Lesson> lessonData = <lp.Lesson>[].obs;

  /// Called when the controller is initialized.
  ///
  /// Sets up the initial state, fetches necessary data, and sets up listeners.
  @override
  void onInit() {
    super.onInit();
    selectedDay.value = focusedDay.value;
    tabController = TabController(length: 2, vsync: this);
    initController();
    ever(scheduleView, (_) => fetchSchedules());
  }

  /// Called when the controller is closed.
  ///
  /// Disposes of resources, like the [weekScrollController], to prevent memory leaks.
  @override
  void onClose() {
    weekScrollController.dispose();
    tabController.dispose();
    super.onClose();
  }

  /// Initializes the controller by fetching initial data.
  ///
  /// Shows a loader, then fetches user data and schedules concurrently.
  Future<void> initController() async {
    Loader.show();
    await Future.wait(<Future<void>>[getMe(), fetchSchedules()]);
    scrollToSelectedDay();
    Loader.dismiss();
  }

  /// Fetches the current user's profile information.
  ///
  /// On success, it populates the user's board information and pre-selects
  /// it if there's only one. On failure, it shows an error snackbar.
  Future<void> getMe() async {
    isLoading(true);
    try {
      final MeModel? result = await profileApiRepo.getMe();
      if (result != null && result.data != null) {
        me(result);
        final List<String> board = result.data!.classes!
            .map((Class d) => d.board ?? '')
            .whereType<String>()
            .where((String e) => e.isNotEmpty)
            .toList();
        boards.assignAll(board.toSet().toList());
        if (boards.length == 1) {
          onBoardChanged(boards.first);
        }
      } else {
        appSnackBar(
          message: result?.message ?? 'Failed to load data.',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  /// Handles the change event when a new board is selected.
  ///
  /// Resets dependent dropdowns (medium, class, subject, etc.) and populates
  /// the mediums dropdown based on the selected board.
  ///
  /// [value] is the selected board name.
  void onBoardChanged(String? value) {
    if (eventDialog.value == EventDialog.view) {
      return;
    }
    selectedBoard.value = value;
    selectedMedium.value = null;
    selectedClass.value = null;
    selectedSubject.value = null;
    selectedChapter.value = null;
    selectedSubTopics.value = null;
    selectedLessonPlans.value = null;
    mediums.clear();
    classNames.clear();
    subjects.clear();
    chapters.clear();
    subTopics.clear();
    lessonPlans.clear();
    formKey.currentState?.patchValue(<String, dynamic>{
      'medium': null,
      'class_name': null,
      'subject': null,
      'chapter': null,
      'sub_topic': null,
      'lesson_plan': null,
    });
    if (value != null) {
      final List<Class>? userClasses = me.value?.data?.classes;
      if (userClasses != null && userClasses.isNotEmpty) {
        mediums.value = userClasses
            .where((Class e) => e.board == value)
            .map((Class e) => e.medium!)
            .toSet()
            .toList();
        if (mediums.length == 1) {
          onMediumChanged(mediums.first);
          return;
        }
      }
    }
  }

  /// Handles the change event when a new medium is selected.
  ///
  /// Resets dependent dropdowns and populates the class names dropdown.
  /// [value] is the selected medium name.
  void onMediumChanged(String? value) {
    if (eventDialog.value == EventDialog.view) {
      return;
    }
    selectedMedium.value = value;
    selectedClass.value = null;
    selectedSubject.value = null;
    selectedChapter.value = null;
    selectedSubTopics.value = null;
    selectedLessonPlans.value = null;
    classNames.clear();
    subjects.clear();
    chapters.clear();
    subTopics.clear();
    lessonPlans.clear();
    formKey.currentState?.patchValue(<String, dynamic>{
      'class_name': null,
      'subject': null,
      'chapter': null,
      'sub_topic': null,
      'lesson_plan': null,
    });
    if (value != null) {
      final List<Class>? userClasses = me.value?.data?.classes;
      if (userClasses != null && userClasses.isNotEmpty) {
        classNames.value = userClasses
            .where(
              (Class e) => e.board == selectedBoard.value && e.medium == value,
            )
            .map((Class e) => e.classClass.toString())
            .toSet()
            .toList();
        if (classNames.length == 1) {
          onClassChanged(classNames.first);
          return;
        }
      }
    }
  }

  /// Handles the change event when a new class is selected.
  ///
  /// Resets dependent dropdowns and populates the subjects dropdown.
  /// [value] is the selected class name.
  void onClassChanged(String? value) {
    if (eventDialog.value == EventDialog.view) {
      return;
    }
    selectedClass.value = value;
    selectedSubject.value = null;
    selectedChapter.value = null;
    selectedSubTopics.value = null;
    selectedLessonPlans.value = null;
    subjects.clear();
    chapters.clear();
    subTopics.clear();
    lessonPlans.clear();
    formKey.currentState?.patchValue(<String, dynamic>{
      'subject': null,
      'chapter': null,
      'sub_topic': null,
      'lesson_plan': null,
    });
    if (value != null) {
      final List<Class>? userClasses = me.value?.data?.classes;
      if (userClasses != null && userClasses.isNotEmpty) {
        subjects.value = userClasses
            .where(
              (Class e) =>
                  e.board == selectedBoard.value &&
                  e.medium == selectedMedium.value &&
                  e.classClass!.toString() == value,
            )
            .map((Class e) => e.subject!)
            .toSet()
            .toList();
        if (subjects.length == 1) {
          onSubjectChanged(subjects.first);
          return;
        }
      }
    }
  }

  /// Handles the change event when a new subject is selected.
  ///
  /// Resets dependent dropdowns and fetches the list of chapters.
  /// [value] is the selected subject name.
  void onSubjectChanged(String? value) {
    if (eventDialog.value == EventDialog.view) {
      return;
    }
    selectedSubject.value = value;
    selectedChapter.value = null;
    selectedSubTopics.value = null;
    selectedLessonPlans.value = null;
    chapters.clear();
    subTopics.clear();
    lessonPlans.clear();
    formKey.currentState?.patchValue(<String, dynamic>{
      'chapter': null,
      'sub_topic': null,
      'lesson_plan': null,
    });
    if (value != null) {
      getChapters();
    }
  }

  /// Fetches the list of chapters based on the selected board, medium, class, and subject.
  ///
  /// If [isEditing] is true, it won't auto-select the first item if there's only one.
  Future<void> getChapters({bool isEditing = false}) async {
    if (eventDialog.value == EventDialog.view) {
      return;
    }
    Loader.show();
    try {
      final ChapterFilterModel? result = await apiRepo.getChapters(
        board: selectedBoard.value!,
        medium: selectedMedium.value!,
        standard: selectedClass.value!,
        subject: selectedSubject.value!,
      );
      if (result != null && result.data != null) {
        chapters.value = result.data!.results!
            .map((Result e) => e.topics!)
            .toSet()
            .toList();
        if (chapters.length == 1 && !isEditing) {
          onChapterChanged(chapters.first);
          return;
        }
      }
    } finally {
      Loader.dismiss();
    }
  }

  /// Handles the change event when a new chapter is selected.
  ///
  /// Resets dependent dropdowns and fetches the lesson plans.
  /// [value] is the selected chapter name.
  void onChapterChanged(String? value) {
    if (eventDialog.value == EventDialog.view) {
      return;
    }
    selectedChapter.value = value;
    selectedSubTopics.value = null;
    selectedLessonPlans.value = null;
    subTopics.clear();
    lessonPlans.clear();
    formKey.currentState?.patchValue(<String, dynamic>{
      'sub_topic': null,
      'lesson_plan': null,
    });
    if (value != null) {
      getLessonPlans();
    }
  }

  /// Fetches lesson plans and associated sub-topics based on the selected filters.
  ///
  /// If [isEditing] is true, it won't auto-select the first item.
  Future<void> getLessonPlans({bool isEditing = false}) async {
    if (eventDialog.value == EventDialog.view) {
      return;
    }
    Loader.show();
    try {
      final lp.LessonPlanModel? result = await apiRepo.getLessonPlans(
        board: selectedBoard.value!,
        medium: selectedMedium.value!,
        className: selectedClass.value!,
        subject: selectedSubject.value!,
        topics: selectedChapter.value!,
      );
      if (result?.data?.isNotEmpty ?? false) {
        subtopicData.clear();
        final List<String> uiSubTopics = <String>[];
        for (final lp.Datum data in result!.data!) {
          if (data.subtopics != null) {
            for (final lp.Subtopic subtopic in data.subtopics!) {
              if (subtopic.subtopic?.isNotEmpty ?? false) {
                subtopicData.add(subtopic);
                uiSubTopics.add(
                  subtopic.isAll ?? false
                      ? 'All Sub-Topics'
                      : subtopic.subtopic!.join(' | '),
                );
              }
            }
          }
        }
        subTopics.value = uiSubTopics;
        if (subTopics.length == 1 && !isEditing) {
          onSubTopicsChanged(subTopics.first);
          return;
        }
      }
    } finally {
      Loader.dismiss();
    }
  }

  /// Handles the change event when a new sub-topic is selected.
  ///
  /// Resets the lesson plan dropdown and populates it with lessons
  /// corresponding to the selected sub-topic.
  /// [value] is the selected sub-topic name.
  void onSubTopicsChanged(String? value) {
    if (eventDialog.value == EventDialog.view) {
      return;
    }
    selectedSubTopics.value = value;
    selectedLessonPlans.value = null;
    lessonPlans.clear();
    lessonData.clear();
    formKey.currentState?.patchValue(<String, dynamic>{
      'sub_topic': value == null ? null : <String>[value],
      'lesson_plan': null,
    });
    if (value != null) {
      final int index = subTopics.indexOf(value);
      if (index != -1 && index < subtopicData.length) {
        final lp.Subtopic selectedSubtopic = subtopicData[index];
        if (selectedSubtopic.lessons?.isNotEmpty ?? false) {
          lessonData.value = selectedSubtopic.lessons!;
          lessonPlans.value = selectedSubtopic.lessons!
              .map((lp.Lesson e) => e.name!)
              .toList();
          if (lessonPlans.length == 1) {
            onLessonPlanChanged(lessonPlans.first);
          }
        }
      }
    }
  }

  /// Handles the change event when a new lesson plan is selected.
  ///
  /// Updates the form state with the selected lesson plan.
  /// [value] is the selected lesson plan name.
  void onLessonPlanChanged(String? value) {
    if (eventDialog.value == EventDialog.view) {
      return;
    }
    formKey.currentState?.patchValue(<String, dynamic>{
      'lesson_plan': value == null ? null : <String>[value],
    });
    selectedLessonPlans
      ..value = value
      ..refresh();
  }

  /// Fetches schedules for the currently focused week.
  ///
  /// It determines whether to fetch the user's own schedule or others'
  /// based on the [scheduleView] state. The fetched events are processed
  /// and added to the [kEvents] map.
  Future<void> fetchSchedules() async {
    isLoading.value = true;
    try {
      final DateTime firstDayOfWeek = startOfWeek;
      final DateTime lastDayOfWeek = startOfWeek.add(const Duration(days: 6));

      final String fromDate = DateFormat('yyyy-MM-dd').format(firstDayOfWeek);
      final String toDate = DateFormat('yyyy-MM-dd').format(lastDayOfWeek);

      final MySchedules? result = await apiRepo.getSchedules(
        fromDate: fromDate,
        toDate: toDate,
        teacherSchedule: scheduleView.value == ScheduleView.my,
      );

      if (result != null && result.data != null) {
        kEvents.value.clear();
        final List<Color> colorCollection = <Color>[
          AppColors.kED7D2D,
          AppColors.k3B6BE7,
          AppColors.k7035BA,
          AppColors.k3D8248,
        ];
        final Random random = Random();
        for (final Schedules schedule in result.data!) {
          if (schedule.scheduleDateTime != null) {
            for (final ScheduleDateTime scheduleDateTime
                in schedule.scheduleDateTime!) {
              if (scheduleDateTime.date != null &&
                  scheduleDateTime.fromTime != null) {
                final DateTime datePart = scheduleDateTime.date!;
                final List<String> fromTimeParts = scheduleDateTime.fromTime!
                    .split(':');
                final DateTime startDateTime = DateTime(
                  datePart.year,
                  datePart.month,
                  datePart.day,
                  int.parse(fromTimeParts[0]),
                  int.parse(fromTimeParts[1]),
                ).toLocal();

                final TimeOfDay endTime;
                if (scheduleDateTime.toTime != null) {
                  final List<String> toTimeParts = scheduleDateTime.toTime!
                      .split(':');
                  final DateTime endDateTime = DateTime(
                    datePart.year,
                    datePart.month,
                    datePart.day,
                    int.parse(toTimeParts[0]),
                    int.parse(toTimeParts[1]),
                  ).toLocal();
                  endTime = TimeOfDay.fromDateTime(endDateTime);
                } else {
                  endTime = TimeOfDay.fromDateTime(
                    startDateTime.add(const Duration(hours: 1)),
                  );
                }

                final String className =
                    '${LocaleKeys.classKey.tr}: '
                    '${schedule.datumClass?.toString() ?? ''} '
                    // '${LocaleKeys.semester.tr}: '
                    // '${schedule.lesson?.subjects?.sem?.toString() ?? ''}'
                    '${schedule.lesson?.subjects?.name ?? ''} ';

                final Event event = Event(
                  teacher: schedule.teacher?.name ?? '',
                  className: className,
                  topic: schedule.topic ?? '',
                  startTime: TimeOfDay.fromDateTime(startDateTime),
                  endTime: endTime,
                  scheduleId: schedule.id!,
                  scheduleDateTimeId: scheduleDateTime.id!,
                  lessonId: schedule.lessonId ?? '',
                  color:
                      colorCollection[random.nextInt(colorCollection.length)],
                );
                final DateTime day = DateTime(
                  startDateTime.year,
                  startDateTime.month,
                  startDateTime.day,
                );
                if (kEvents.value[day] == null) {
                  kEvents.value[day] = <Event>[];
                }
                kEvents.value[day]!.add(event);
              }
            }
          }
        }
      } else {
        appSnackBar(
          message: result?.message ?? 'Failed to fetch Schedules.',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    } finally {
      isLoading.value = false;
      kEvents.refresh();
      update();
    }
  }

  /// Handles the selection of a day in the calendar.
  ///
  /// Updates [selectedDay] and [focusedDay] and scrolls the week view to the selected day.
  ///
  /// [selected] is the day that was tapped.
  /// [focused] is the day that should be focused (usually the same as selected).
  void onDaySelected(DateTime selected, DateTime focused) {
    if (!isSameDay(selectedDay.value, selected)) {
      selectedDay.value = selected;
      focusedDay.value = focused;
      scrollToSelectedDay();
    }
  }

  /// Scrolls the horizontal week view to center the currently selected day.
  void scrollToSelectedDay() {
    if (selectedDay.value == null) {
      return;
    }

    final int dayIndex = selectedDay.value!.weekday - 1;
    const double dayWidth = 80;
    final double screenWidth = Get.width;
    const int twoIconButtonWidth = 96;
    final double viewportWidth =
        screenWidth - (24.w * 2) - (16.dg * 2) - twoIconButtonWidth;

    double scrollPosition =
        (dayIndex * dayWidth) - (viewportWidth / 2) + (dayWidth / 2);

    scrollPosition = scrollPosition.clamp(
      0.0,
      weekScrollController.position.maxScrollExtent,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(
        const Duration(milliseconds: 100),
        () => weekScrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      );
    });
  }

  /// Called when the calendar page (week) is changed.
  ///
  /// Updates the [focusedDay], scrolls to the selected day, and fetches schedules
  /// for the new week.
  /// [focused] is the new focused day from the calendar widget.
  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
    scrollToSelectedDay();
    fetchSchedules();
  }

  /// Creates a new schedule by making an API call.
  ///
  /// On success, it fetches the updated schedules and shows a success message.
  /// On failure, it shows an error message.
  /// [body] is a map containing the schedule data.
  Future<void> createSchedule(Map<String, dynamic> body) async {
    isLoading.value = true;
    try {
      final CreateSchedule? result = await apiRepo.createSchedule(body);
      if (result != null) {
        await fetchSchedules();
        appSnackBar(
          message: result.message ?? 'Schedule created successfully',
          state: SnackBarState.success,
          type: SnackBarType.top,
        );
      } else {
        appSnackBar(
          message: 'Failed to create Schedule',
          state: SnackBarState.danger,
          type: SnackBarType.top,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates an existing schedule by making an API call.
  ///
  /// On success, it fetches the updated schedules and shows a success message.
  /// On failure, it shows an error message.
  /// [body] is a map containing the schedule data to be updated.
  Future<void> updateSchedule(Map<String, dynamic> body) async {
    isLoading.value = true;
    try {
      final CreateSchedule? result = await apiRepo.updateSchedule(body);
      if (result != null) {
        await fetchSchedules();
        appSnackBar(
          message: result.message ?? 'Schedule updated successfully',
          state: SnackBarState.success,
          type: SnackBarType.top,
        );
      } else {
        appSnackBar(
          message: 'Failed to update Schedule',
          state: SnackBarState.danger,
          type: SnackBarType.top,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Deletes a specific schedule instance.
  ///
  /// [scheduleId] is the ID of the main schedule entry.
  /// [scheduleDateTimeId] is the ID of the specific date/time instance to delete.
  Future<void> deleteSchedule({
    required String scheduleId,
    required String scheduleDateTimeId,
  }) async {
    isLoading.value = true;
    try {
      final CreateSchedule? result = await apiRepo.deleteSchedule(
        scheduleId: scheduleId,
        scheduleDateTimeId: scheduleDateTimeId,
      );
      if (result != null) {
        await fetchSchedules();
      } else {
        // Can show a snackbar for error
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches the details of a single schedule by its ID.
  ///
  /// [scheduleId] is the ID of the schedule to fetch.
  Future<void> getScheduleById({required String scheduleId}) async {
    isLoading.value = true;
    try {
      final ScheduleById? result = await apiRepo.getScheduleById(
        scheduleId: scheduleId,
      );
      if (result != null) {
        scheduleById.value = result;
      } else {
        // Can show a snackbar for error
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigates to the lesson plan view for a given event.
  ///
  /// [event] is the event for which to view the lesson plan.
  /// [context] is the build context from which to navigate.
  void viewLessonPlan(Event event, BuildContext context) {
    Navigator.of(context).pop();
    if (Get.isRegistered<NavigationScreenController>()) {
      final NavigationScreenController shellController =
          Get.find<NavigationScreenController>();
      shellController.changeTab(
        shellController.currentIndex.value,
        redirectionRoute: Routes.LESSON_PLAN_GENERATED_VIEW,
        args: <String, dynamic>{
          'lessonId': event.lessonId,
          'from_page': FromPage.view,
        },
      );
    }
  }

  /// Shows the "Add Event" dialog.
  ///
  /// Resets form fields and opens the [AddEventDialog].
  /// [day] is the day for which to add the event.
  void onAddEvent(DateTime day) {
    eventDialog(EventDialog.add);
    selectedClass.value = null;
    selectedSubject.value = null;
    selectedChapter.value = null;
    selectedSubTopics.value = null;
    selectedLessonPlans.value = null;
    classNames.clear();
    subjects.clear();
    chapters.clear();
    subTopics.clear();
    lessonPlans.clear();
    subtopicData.clear();
    lessonData.clear();
    Get.dialog(
      AddEventDialog(day: day),
      barrierColor: AppColors.k000000.withValues(alpha: 0.2),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      formKey.currentState!.patchValue(<String, dynamic>{
        'board': selectedBoard.value == null
            ? null
            : <String>[selectedBoard.value!],
        'medium': selectedMedium.value == null
            ? null
            : <String>[selectedMedium.value!],
        'class_name': selectedClass.value == null
            ? null
            : <String>[selectedClass.value!],
        'subject': selectedSubject.value == null
            ? null
            : <String>[selectedSubject.value!],
        'chapter': selectedChapter.value == null
            ? null
            : <String>[selectedChapter.value!],
        'sub_topic': selectedSubTopics.value == null
            ? null
            : <String>[selectedSubTopics.value!],
        'lesson_plan': selectedLessonPlans.value == null
            ? null
            : <String>[selectedLessonPlans.value!],
        'date': day,
      });
    });
  }

  /// Shows the "View Event" dialog with details of the selected event.
  ///
  /// Fetches the schedule details by ID and populates the form fields.
  /// [event] is the event to be viewed.
  void viewEvent(Event event) {
    eventDialog(EventDialog.view);

    selectedEvent.value = event;
    getScheduleById(scheduleId: event.scheduleId).then((_) {
      final DateTime day = DateTime(
        selectedDay.value!.year,
        selectedDay.value!.month,
        selectedDay.value!.day,
      );
      Get.dialog(AddEventDialog(day: day, event: event));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final Data? scheduleDetails = scheduleById.value?.data;
        if (formKey.currentState != null && scheduleDetails != null) {
          final DateTime startTime = DateTime(
            scheduleDetails.scheduleDateTime?.first.date?.year ?? day.year,
            scheduleDetails.scheduleDateTime?.first.date?.month ?? day.month,
            scheduleDetails.scheduleDateTime?.first.date?.day ?? day.day,
            event.startTime.hour,
            event.startTime.minute,
          );
          final DateTime endTime = DateTime(
            scheduleDetails.scheduleDateTime?.first.date?.year ?? day.year,
            scheduleDetails.scheduleDateTime?.first.date?.month ?? day.month,
            scheduleDetails.scheduleDateTime?.first.date?.day ?? day.day,
            event.endTime.hour,
            event.endTime.minute,
          );
          formKey.currentState!.patchValue(<String, dynamic>{
            'board': scheduleDetails.board != null
                ? <String>[scheduleDetails.board!]
                : null,
            'medium': scheduleDetails.medium != null
                ? <String>[scheduleDetails.medium!]
                : null,
            'class_name': scheduleDetails.dataClass != null
                ? <String>[scheduleDetails.dataClass!.toString()]
                : null,
            'subject': scheduleDetails.subject != null
                ? <String>[scheduleDetails.subject!]
                : null,
            'chapter': scheduleDetails.topic != null
                ? <String>[scheduleDetails.topic!]
                : null,
            'sub_topic': scheduleDetails.subTopic != null
                ? <String>[scheduleDetails.subTopic!]
                : null,
            'lesson_plan': scheduleDetails.lesson?.name != null
                ? <String>[scheduleDetails.lesson!.name!]
                : null,
            'date': scheduleDetails.scheduleDateTime?.first.date ?? day,
            'start_time': startTime,
            'end_time': endTime,
          });
        }
      });
    });
  }

  /// Shows the "Edit Event" dialog, pre-filled with the event's data.
  ///
  /// Fetches schedule details, loads all dropdown options, and populates the form.
  /// [event] is the event to be edited.
  void editEvent(Event event) {
    eventDialog(EventDialog.edit);
    selectedEvent.value = event;
    getScheduleById(scheduleId: event.scheduleId).then((_) {
      final DateTime day = DateTime(
        selectedDay.value!.year,
        selectedDay.value!.month,
        selectedDay.value!.day,
      );
      Get.dialog(AddEventDialog(day: day, event: event));
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final Data? scheduleDetails = scheduleById.value?.data;
        if (formKey.currentState != null && scheduleDetails != null) {
          selectedBoard.value = scheduleDetails.board;
          selectedMedium.value = scheduleDetails.medium;
          selectedClass.value = scheduleDetails.dataClass?.toString();
          selectedSubject.value = scheduleDetails.subject;
          selectedChapter.value = scheduleDetails.topic;
          selectedSubTopics.value = scheduleDetails.subTopic;
          selectedLessonPlans.value = scheduleDetails.lesson?.name;
          await onEditLoadFieldOptions();
          final DateTime startTime = DateTime(
            scheduleDetails.scheduleDateTime?.first.date?.year ?? day.year,
            scheduleDetails.scheduleDateTime?.first.date?.month ?? day.month,
            scheduleDetails.scheduleDateTime?.first.date?.day ?? day.day,
            event.startTime.hour,
            event.startTime.minute,
          );
          final DateTime endTime = DateTime(
            scheduleDetails.scheduleDateTime?.first.date?.year ?? day.year,
            scheduleDetails.scheduleDateTime?.first.date?.month ?? day.month,
            scheduleDetails.scheduleDateTime?.first.date?.day ?? day.day,
            event.endTime.hour,
            event.endTime.minute,
          );
          formKey.currentState!.patchValue(<String, dynamic>{
            'board': scheduleDetails.board != null
                ? <String>[scheduleDetails.board!]
                : null,
            'medium': scheduleDetails.medium != null
                ? <String>[scheduleDetails.medium!]
                : null,
            'class_name': scheduleDetails.dataClass != null
                ? <String>[scheduleDetails.dataClass!.toString()]
                : null,
            'subject': scheduleDetails.subject != null
                ? <String>[scheduleDetails.subject!]
                : null,
            'chapter': scheduleDetails.topic != null
                ? <String>[scheduleDetails.topic!]
                : null,
            'sub_topic': scheduleDetails.subTopic != null
                ? <String>[scheduleDetails.subTopic!]
                : null,
            'lesson_plan': scheduleDetails.lesson?.name != null
                ? <String>[scheduleDetails.lesson!.name!]
                : null,
            'date': scheduleDetails.scheduleDateTime?.first.date ?? day,
            'start_time': startTime,
            'end_time': endTime,
          });
        }
      });
    });
  }

  /// Loads all the necessary dropdown options when editing an event.
  ///
  /// This ensures that when the edit dialog opens, all dropdowns (board,
  /// medium, class, etc.) are populated with the correct available options,
  /// not just the selected one.
  Future<void> onEditLoadFieldOptions() async {
    final List<String> board = me.value!.data!.classes!
        .map((Class d) => d.board ?? '')
        .whereType<String>()
        .where((String e) => e.isNotEmpty)
        .toList();
    boards.assignAll(board.toSet().toList());
    final List<Class>? userClasses = me.value?.data?.classes;
    if (userClasses != null && userClasses.isNotEmpty) {
      mediums.value = userClasses
          .where((Class e) => e.board == selectedBoard.value)
          .map((Class e) => e.medium!)
          .toSet()
          .toList();
      classNames.value = userClasses
          .where(
            (Class e) =>
                e.board == selectedBoard.value &&
                e.medium == selectedMedium.value,
          )
          .map((Class e) => e.classClass.toString())
          .toSet()
          .toList();
      subjects.value = userClasses
          .where(
            (Class e) =>
                e.board == selectedBoard.value &&
                e.medium == selectedMedium.value &&
                e.classClass!.toString() == selectedClass.value,
          )
          .map((Class e) => e.subject!)
          .toSet()
          .toList();
      await Future.wait(<Future<void>>[
        getChapters(isEditing: true),
        getLessonPlans(isEditing: true),
      ]);
      final int index = subTopics.indexOf(selectedSubTopics.value);
      if (index != -1 && index < subtopicData.length) {
        final lp.Subtopic selectedSubtopic = subtopicData[index];
        if (selectedSubtopic.lessons?.isNotEmpty ?? false) {
          lessonData.value = selectedSubtopic.lessons!;
          lessonPlans.value = selectedSubtopic.lessons!
              .map((lp.Lesson e) => e.name!)
              .toList();
        }
      }
    }
  }

  /// Saves the event data from the form.
  ///
  /// Validates the form, constructs the request body, and calls either
  /// [createSchedule] or [updateSchedule] based on the dialog mode.
  void saveEvent() {
    if (formKey.currentState!.saveAndValidate()) {
      final dynamic values = formKey.currentState!.value;
      final DateTime startTime = values['start_time'] as DateTime;
      final DateTime endTime = values['end_time'] as DateTime;
      final DateTime date = values['date'] as DateTime;

      final DateTime startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      );
      final DateTime endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        endTime.hour,
        endTime.minute,
      );

      final String? lessonPlanName =
          (values['lesson_plan'] as List<String>?)?.first;
      String? lessonId;
      if (lessonPlanName != null) {
        lessonId = lessonData
            .firstWhereOrNull((lp.Lesson e) => e.name == lessonPlanName)
            ?.lessonId;
      }

      Data scheduleData;
      if (eventDialog.value == EventDialog.edit) {
        scheduleData = scheduleById.value!.data!;
      } else {
        scheduleData = Data(teacherId: me.value?.data?.id);
      }

      scheduleData = scheduleData.copyWith(
        board: (values['board'] as List<String>?)?.first,
        medium: (values['medium'] as List<String>?)?.first,
        subject: (values['subject'] as List<String>?)?.first,
        topic: (values['chapter'] as List<String>?)?.first,
        subTopic: (values['sub_topic'] as List<String>?)?.first,
        scheduleType: 'regular',
        dataClass: int.tryParse(
          (values['class_name'] as List<String>?)?.first ?? '',
        ),
        otherClass: '',
        scheduleDateTime: <ScheduleDateTime>[
          ScheduleDateTime(
            date: date,
            fromTime: DateFormat('HH:mm').format(startDateTime),
            toTime: DateFormat('HH:mm').format(endDateTime),
          ),
        ],
        lesson: lessonId != null ? Lesson(id: lessonId) : null,
      );

      final Map<String, dynamic> body = scheduleData.toJson();
      body['schoolId'] = me.value?.data?.school?.id;

      if (body['lesson'] != null && body['lesson']['_id'] != null) {
        body['lessonId'] = body['lesson']['_id'];
      }
      body
        ..remove('lesson')
        ..remove('createdAt')
        ..remove('updatedAt')
        ..remove('__v')
        ..removeWhere((_, dynamic value) => value == null);

      if (eventDialog.value == EventDialog.edit) {
        updateSchedule(body);
      } else {
        createSchedule(body);
      }
      Get.back();
    }
  }
}
