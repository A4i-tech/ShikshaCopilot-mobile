import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart';
import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A controller class for the Content Generation screen.
///
/// This class manages the state and business logic for the content generation
/// feature, including handling user input, filtering content, and fetching
/// data from the API.
class ContentGenerationController extends GetxController {
  // --- Loading States ---
  /// A reactive boolean that indicates whether lesson plans are currently being loaded.
  final RxBool isLoadingLessonPlans = false.obs;

  // --- Data Holders ---
  /// A reactive variable that holds the current [LessonPlan].
  final Rx<LessonPlan?> lessonPlan = Rx<LessonPlan?>(null);

  final ContentGenerationApiRepo _contentGenerationApiRepo =
      ContentGenerationApiRepo();

  /// A list of [ClassDetail] for the current user.
  List<ClassDetail>? userClasses;

  /// A reactive list of [Plan] objects representing lesson plan resources.
  final RxList<Plan> lessonPlanResourceList = <Plan>[].obs;

  /// A reactive list of [Plan] objects representing lesson plans.
  final RxList<Plan> lessonPlanList = <Plan>[].obs;

  /// A reactive list of [Plan] objects representing lesson resources.
  final RxList<Plan> lessonResourceList = <Plan>[].obs;

  /// A reactive boolean that controls the visibility of the filter widget.
  final RxBool isFilterVisible = false.obs;

  /// A global key for the [FormBuilder] state.
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  Timer? _searchDebounceTimer;

  @override
  void onInit() {
    // final arg = Get.arguments;
    // if (arg?['redirectRoute'] != null) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Get.toNamed(arg?['redirectRoute']);
    //   });
    // }

    // ever<List<String>>(boardList, (List<String> list) {
    //   if (list.isEmpty || !list.contains('KSEEB')) {
    //     // Show a placeholder/hint when KSEEB is not present or no boards exist
    //     if (!list.contains('Select Board')) {
    //       boardList.insert(0, 'Select Board');
    //     }
    //     selectedBoard.value = 'Select Board';
    //   } else {
    //     // If KSEEB is present, select it by default
    //     selectedBoard.value = 'KSEEB';
    //   }
    // });

    // Update mediumList whenever selectedBoard changes
    ever(selectedBoard, (String board) {
      _updateMediumList(board);
    });

    everAll(<RxInterface>[selectedBoard, selectedMedium], (_) {
      _updateClassList(selectedBoard.value, selectedMedium.value);
    });

    everAll(<RxInterface>[selectedBoard, selectedMedium, selectedClass], (_) {
      _updateSubjectList(
        selectedBoard.value,
        selectedMedium.value,
        selectedClass.value,
      );
    });
    initController();

    super.onInit();
  }

  /// Refreshes the content generation screen.
  ///
  /// This method re-initializes the controller to fetch the latest data.
  /// A loader is shown if [showLoader] is true.
  Future<void> refreshContentGenerationScreen({bool showLoader = true}) async {
    // if (showLoader) Loader.show();

    // formKey.currentState?.reset();

    // selectedPlanStatus.value = 'All';
    // selectedPlanType.value = 'All';
    // selectedBoard.value = '';
    // selectedMedium.value = '';
    // selectedClass.value = '';
    // selectedSubject.value = 'Subject';
    // selectedMonth.value = getCurrentMonthName();
    // selectedMonthNumber.value = getMonthNumber(getCurrentMonthName());

    await initController();

    // _searchDebounceTimer?.cancel();

    // lessonPlanList.refresh();
    // lessonPlanResourceList.refresh();
    // lessonResourceList.refresh();
    logD('ContentGenerationController refresh called');

    // if (showLoader) Loader.dismiss();
  }

  /// Searches for lessons with a debounce.
  ///
  /// This method uses a [Timer] to delay the execution of [applyFilters]
  /// to avoid making too many API calls while the user is typing.
  void searchLessonsWithDebounce(String? value) {
    _searchDebounceTimer?.cancel();

    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      applyFilters();
    });
  }

  /// Returns the name of the current month.
  String getCurrentMonthName() {
    final DateTime now = DateTime.now();
    return monthList[now.month - 1];
  }

  /// Toggles the visibility of the filter widget.
  void toggleFilterVisible() {
    isFilterVisible.value = !isFilterVisible.value;
  }

  /// Returns the number of a month given its name.
  ///
  /// For example, `getMonthNumber('January')` returns `'1'`.
  String getMonthNumber(String monthName) {
    final List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final int index = months.indexOf(monthName);
    return (index == -1 ? 1 : index + 1).toString();
  }

  void _updateClassList(String board, String medium) {
    debugPrint('_updateClassList called $board $medium');
    if (userClasses == null) return;

    final List<String> filteredClasses = userClasses!
        .where(
          (ClassDetail e) =>
              e.board.toString() == board && e.medium.toString() == medium,
        )
        .map(
          (ClassDetail e) => e.classClass.toString(),
        ) // adapt this property name
        .toSet()
        .toList();

    classList.assignAll(filteredClasses);

    // Reset selected class if needed
    if (!classList.contains(selectedClass.value)) {
      selectedClass.value = classList.isNotEmpty ? classList.first : '';
      debugPrint('_updateClassList selectedClass ${selectedClass.value}');
    }
  }

  void _updateSubjectList(String board, String medium, String classVal) {
    if (userClasses == null) return;

    final List<String> filteredSubjects = userClasses!
        .where(
          (ClassDetail e) =>
              e.board.toString() == board &&
              e.medium.toString() == medium &&
              e.classClass.toString() == classVal,
        ) // replace 'classClass' if your model uses a different name
        .map((ClassDetail e) => '${e.name} Sem ${e.sem}')
        .toSet()
        .toList();

    subjectList.assignAll(filteredSubjects);

    // Reset selectedSubject if needed
    if (!subjectList.contains(selectedSubject.value)) {
      selectedSubject.value = subjectList.isNotEmpty ? subjectList.first : '';
    }
  }

  /// Initializes the controller.
  ///
  /// This method fetches the user's classes and populates the dropdown lists.
  Future<void> initController() async {
    Loader.show();
    userClasses = UserProvider.currentUser?.classes;

    if (userClasses != null && userClasses!.isNotEmpty) {
      // Populate dropdown lists dynamically from userClasses
      boardList.assignAll(
        userClasses!
            .map((ClassDetail e) => e.board.toString())
            .toSet()
            .toList(),
      );
    }
    selectedMonth.value = getCurrentMonthName(); // initialize to current
    selectedMonthNumber.value = getMonthNumber(getCurrentMonthName());
    applyFilters();
    Loader.dismiss();
  }

  /// A reactive integer that can be used for counting.
  final RxInt count = 0.obs;

  // Observable selected values
  /// The currently selected plan status.
  RxString selectedPlanStatus = 'All'.obs;

  /// The currently selected plan type.
  RxString selectedPlanType = 'All'.obs;

  /// The currently selected board.
  RxString selectedBoard = ''.obs;

  /// The currently selected medium.
  RxString selectedMedium = ''.obs;

  /// The currently selected class.
  RxString selectedClass = ''.obs;

  /// The currently selected subject.
  RxString selectedSubject = 'Subject'.obs;

  /// The currently selected month.
  RxString selectedMonth = ''.obs;

  /// The number of the currently selected month.
  RxString selectedMonthNumber = ''.obs;

  // Dropdown options (you can load dynamic data here too)
  /// The list of available plan statuses.
  final List<String> planStatusList = <String>[
    'All',
    'Drafted Plan',
    'Saved Plan',
  ];

  /// The list of available plan types.
  final List<String> planTypeList = <String>[
    'All',
    'Lesson Plan',
    'Resource Plan',
  ];
  // final List<String> boardList = <String>['KSEEB'];
  // final List<String> mediumList = <String>['English', 'Kannada', 'Hindi'];
  // final List<String> classList = <String>['1', '2 ', '3 ', '4', '5'];
  // final List<String> subjectList = <String>[
  //   'Subject',
  //   'Math',
  //   'Science',
  //   'History',
  //   'Geography',
  // ];

  // Observable dropdown lists with initial empty lists
  /// A reactive list of available boards.
  final RxList<String> boardList = <String>[].obs;

  /// A reactive list of available mediums.
  final RxList<String> mediumList = <String>[].obs;

  /// A reactive list of available classes.
  final RxList<String> classList = <String>[].obs;

  /// A reactive list of available subjects.
  final RxList<String> subjectList = <String>[].obs;
  // final RxList<String> monthList = <String>[
  //   '',
  //   'January',
  //   'February',
  //   'March',
  //   'April',
  //   'May',
  // ].obs;
  /// The list of months.
  final List<String> monthList = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // final RxList<LessonPlanResourceListModel> lessonPlanResourceList =
  //     <LessonPlanResourceListModel>[
  //       LessonPlanResourceListModel(
  //         subject: 'English',
  //         className: 'Class 6',
  //         lessonType: 'Lesson Plan',
  //         chapter: 'Who did patricks Homework',
  //         subTopic: 'Topic 2',
  //         date: 'May 6,2023',
  //         buttonText: 'Continue Editing',
  //         cardColor: const Color(0xFFC084FC),
  //         buttonColor: const Color(0xFFC084FC),
  //       ),
  //       LessonPlanResourceListModel(
  //         subject: 'Science Sem1',
  //         className: 'Class 6',
  //         lessonType: 'Lesson Plan',
  //         chapter: '3.Heat',
  //         subTopic: '3.2 MEASURING TEMPERATURE',
  //         date: 'May 6,2023',
  //         buttonText: 'View Lesson Plan',
  //         cardColor: const Color(0xFFC084FC),
  //         buttonColor: const Color(0xFFC084FC),
  //         showChatbot: true,
  //       ),
  //       LessonPlanResourceListModel(
  //         subject: 'English',
  //         className: 'Class 6',
  //         lessonType: 'Lesson Plan',
  //         chapter: 'Who did patricks Homework',
  //         subTopic: 'Topic 2',
  //         date: 'May 6,2023',
  //         buttonText: 'View Lesson Resources',
  //         cardColor: const Color(0xFF4ADE80),
  //         buttonColor: const Color(0xFF4ADE80),
  //       ),
  //     ].obs;
  // Callbacks to update values from UI
  /// Called when the plan status is changed in the UI.
  void onPlanStatusChanged(String? val) {
    if (val != null) {
      selectedPlanStatus.value = val;
      applyFilters();
    }
  }

  /// Called when the plan type is changed in the UI.
  void onPlanTypeChanged(String? val) {
    if (val != null) {
      selectedPlanType.value = val;
      applyFilters();
    }
  }

  /// Called when the board is changed in the UI.
  void onBoardChanged(String? val) {
    if (val != null) {
      selectedBoard.value = val;
      // Update mediumList based on the selected board
      _updateMediumList(val);
      applyFilters();
    }
  }

  /// Called when the medium is changed in the UI.
  void onMediumChanged(String? val) {
    if (val != null) {
      selectedMedium.value = val;
      applyFilters();
    }
  }

  /// Called when the class is changed in the UI.
  void onClassChanged(String? val) {
    if (val != null) {
      selectedClass.value = val;
      applyFilters();
    }
  }

  /// Called when the subject is changed in the UI.
  void onSubjectChanged(String? val) {
    if (val != null) {
      selectedSubject.value = val;
      applyFilters();
    }
  }

  /// Called when the month is changed in the UI.
  void onMonthChanged(String? val) {
    if (val != null) {
      selectedMonth.value = val;
      selectedMonthNumber.value = getMonthNumber(val);
      logD('month is $val number is ${getMonthNumber(val)}');
      applyFilters();
    }
  }

  /// Called when the month selection is cleared.
  void onMonthClear() {
    selectedMonth.value = '';
    selectedMonthNumber.value = '';
    applyFilters();
  }

  /// Applies the selected filters and fetches the lesson plans.
  void applyFilters() {
    formKey.currentState?.save();
    getLessonPlans('all', search: formKey.currentState?.value['search'] ?? '');
  }

  void _updateMediumList(String board) {
    debugPrint('_updateMediumList called $board');
    if (userClasses == null) return;
    final List<String> filteredMediums = userClasses!
        .where((ClassDetail e) => e.board.toString() == board)
        .map((ClassDetail e) => e.medium.toString())
        .toSet()
        .toList();
    mediumList.assignAll(filteredMediums);

    debugPrint('_updateMediumList called ${mediumList.length}');

    // Reset selectedMedium if needed
    if (!mediumList.contains(selectedMedium.value)) {
      selectedMedium.value = mediumList.isNotEmpty ? mediumList.first : '';
      debugPrint('_updateMediumList selectedMedium ${selectedMedium.value}');
    }
    debugPrint('_updateMediumList selectedMedium ${selectedMedium.value}');
  }

  /// Fetches the lesson plans from the API.
  ///
  /// This method shows a loader, makes an API call to get the lesson plans
  /// with the selected filters, and then prepares the lesson plan list.
  Future<void> getLessonPlans(String filterType, {String search = ''}) async {
    logD('getLessonPlans selected month is ${selectedMonthNumber.value}');
    Loader.show();
    isLoadingLessonPlans(true);
    final LessonPlan? result = await _contentGenerationApiRepo.getLessonPlans(
      planStatus: selectedPlanStatus.value,
      planType: selectedPlanType.value,
      board: selectedBoard.value,
      medium: selectedMedium.value,
      className: selectedClass.value,
      subject: selectedSubject.value,
      createdMonth: selectedMonthNumber.value,
      search: search,
    );
    if (result != null) {
      lessonPlan.value = result;
      _prepareLessonPlanList();
    }
    isLoadingLessonPlans(false);
    Loader.dismiss();
  }

  void _prepareLessonPlanList() {
    lessonPlanList.clear();
    lessonPlanResourceList.clear();
    lessonResourceList.clear();

    if (lessonPlan.value?.data == null) return;

    lessonPlanList.assignAll(
      lessonPlan.value!.data!.where((Plan e) => e.isLesson == true).toList(),
    );
    // lessonPlanResourceList.assignAll(
    //   lessonPlan.value!.data!
    //       .where((Plan e) => e.isLesson != true && (e.isLesson != true))
    //       .toList(),
    // );
    lessonResourceList.assignAll(
      lessonPlan.value!.data!.where((Plan e) => !(e.isLesson == true)).toList(),
    );

    lessonPlanList.refresh();
    //resourcePlanList.refresh();
    lessonResourceList.refresh();
  }
}
