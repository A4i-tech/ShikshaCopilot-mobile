import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:sikshana/app/modules/my_schedules/models/lesson_plan_model.dart';
import 'package:sikshana/app/modules/my_schedules/models/schedule_by_id_model.dart';
import 'package:sikshana/app/modules/profile/models/me_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A mixin that provides shared properties and functionalities for the "My Schedules" feature.
///
/// This mixin encapsulates common state variables, repository instances, controllers,
/// and utility getters used by the [MySchedulesController].
mixin MySchedulesMixin on GetxController {
  /// Instance of the repository for making API calls related to schedules.
  final MySchedulesApiRepo apiRepo = MySchedulesApiRepo();

  /// Instance of the repository for making API calls related to the user's profile.
  final ProfileApiRepo profileApiRepo = ProfileApiRepo();

  /// Scroll controller for the horizontal week view.
  late ScrollController weekScrollController = ScrollController();

  /// Holds the current user's profile data.
  final Rx<MeModel?> me = Rx<MeModel?>(null);

  /// A boolean flag to indicate if data is currently being loaded.
  final RxBool isLoading = true.obs;

  /// Holds the details of a schedule when fetched by its ID.
  final Rx<ScheduleById?> scheduleById = Rx<ScheduleById?>(null);

  /// Global key for the form used in the add/edit event dialog.
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// A map of events, keyed by `DateTime`.
  /// It's a `LinkedHashMap` to maintain insertion order.
  final Rx<LinkedHashMap<DateTime, List<Event>>> kEvents =
      LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  ).obs;

  /// The currently focused day in the calendar.
  final Rx<DateTime> focusedDay = DateTime.now().obs;

  /// The currently selected day in the calendar.
  final Rx<DateTime?> selectedDay = DateTime.now().obs;

  /// The current view mode (e.g., viewing one's own schedule or others').
  final Rx<ScheduleView> scheduleView = ScheduleView.my.obs;

  /// The currently selected event, used for viewing or editing.
  final Rx<Event?> selectedEvent = Rx<Event?>(null);

  /// The current mode of the event dialog (add, view, or edit).
  final Rx<EventDialog> eventDialog = EventDialog.add.obs;

  /// Temporary storage for a subtopic.
  Subtopic? tempSubtopic;

  /// A list of hours to be displayed in the schedule view (7 AM to 6 PM).
  final List<int> hours = List.generate(
    12,
    (int index) => index + 7,
  ); // 7 AM to 6 PM

  /// The height of each hour slot in the schedule view.
  final double hourHeight = 70.h;

  /// The width of each day column in the schedule view.
  final double dayWidth = 150.w;

  // TODO(user): Fetch these from an API
  /// A reactive list of available boards.
  final RxList<String> boards = <String>[].obs;
  /// A reactive list of available mediums.
  final RxList<String> mediums = <String>[].obs;
  /// A reactive list of available class names.
  final RxList<String> classNames = <String>[].obs;
  /// A reactive list of available subjects.
  final RxList<String> subjects = <String>[].obs;
  /// A reactive list of available chapters.
  final RxList<String> chapters = <String>[].obs;
  /// A reactive list of available sub-topics.
  final RxList<String> subTopics = <String>[].obs;
  /// A reactive list of available lesson plans.
  final RxList<String> lessonPlans = <String>[].obs;

  /// The currently selected board.
  final RxnString selectedBoard = RxnString();
  /// The currently selected medium.
  final RxnString selectedMedium = RxnString();
  /// The currently selected class.
  final RxnString selectedClass = RxnString();
  /// The currently selected subject.
  final RxnString selectedSubject = RxnString();
  /// The currently selected chapter.
  final RxnString selectedChapter = RxnString();
  /// The currently selected sub-topic.
  final RxnString selectedSubTopics = RxnString();
  /// The currently selected lesson plan.
  final RxnString selectedLessonPlans = RxnString();

  /// Returns the formatted month and year (e.g., "Jan 2023") for the [focusedDay].
  String get formattedMonth => DateFormat('MMM yyyy').format(focusedDay.value);

  /// Calculates the start of the week for the current [focusedDay].
  /// The week is considered to start on Monday.
  DateTime get startOfWeek {
    final int currentWeekday = focusedDay.value.weekday;
    final DateTime startOfWeek = focusedDay.value.subtract(
      Duration(days: currentWeekday - 1),
    );
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  /// Returns a formatted string representing the current week range (e.g., "Jan 1 - Jan 7").
  String get formattedWeekRange {
    final DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    final String startMonth = DateFormat.MMM().format(startOfWeek);
    final String endMonth = DateFormat.MMM().format(endOfWeek);
    return '$startMonth ${startOfWeek.day} - $endMonth ${endOfWeek.day}';
  }

  /// Checks if a given [day] is the same as today's date.
  bool isToday(DateTime day) => isSameDay(day, DateTime.now());
}

/// A custom hash code function for `DateTime` objects, used by the [LinkedHashMap].
/// It generates a hash code based on the day, month, and year.
int getHashCode(DateTime key) =>
    key.day * 1000000 + key.month * 10000 + key.year;
