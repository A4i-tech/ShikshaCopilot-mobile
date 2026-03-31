import 'package:sikshana/app/modules/lesson_plan_generated_view/utils/from_page.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/generate_lesson_response_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/learning_outcomes_model.dart'
    as learningDatum;
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/lesson_chapter_list_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/lesson_plan_template_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/repository/lesson_plan_generation_details_repo.dart';
import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Controller for the lesson plan generation details screen.
///
/// This controller manages the state and logic for creating a lesson plan,
/// including fetching data for dropdowns, handling user selections, and
/// generating the final lesson plan.
class LessonPlanGenerationDetailsController extends GetxController {
  final LessonPlanGenerationDetailsRepo _lessonPlanGenerationDetailsRepo =
      LessonPlanGenerationDetailsRepo();

  /// The classes assigned to the current user.
  List<ClassDetail>? userClasses;

  /// The response from the lesson generation API.
  final Rx<GenerateLessonResponseModel?> generatedLessonResponse =
      Rx<GenerateLessonResponseModel?>(null);

  /// The ID of the currently selected chapter.
  String selectedChapterId = '';

  /// A list of template IDs to be used for lesson generation.
  final RxList<String> templateIds = <String>[].obs;

  /// The ID of the currently selected subtopic.
  String selectedSubtopicId = '';

  RxString currentBoard = ''.obs;

  final RxBool isFormValid = false.obs;

  /// Updates form validity based on mandatory selections.
  void updateFormValidity() {
    // Print all values with keys for debugging
    print('=== FORM VALIDITY CHECK ===');
    print('FORM VALIDITY selectedBoard: "${selectedBoard.value}"');
    print('FORM VALIDITY selectedMedium: "${selectedMedium.value}"');
    print('FORM VALIDITY selectedClass: "${selectedClass.value}"');
    print('FORM VALIDITY selectedSubject: "${selectedSubject.value}"');
    print('FORM VALIDITY selectedChapter: "${selectedChapter.value}"');
    print('FORM VALIDITY selectedSubTopic: "${selectedSubTopic.value}"');
    print('FORM VALIDITY selectedChapterId: "$selectedChapterId"');
    print('FORM VALIDITY selectedSubtopicId: "$selectedSubtopicId"');

    final boardValid = selectedBoard.isNotEmpty;
    final mediumValid = selectedMedium.isNotEmpty;
    final classValid = selectedClass.isNotEmpty;
    final subjectValid = selectedSubject.isNotEmpty;
    final chapterValid = selectedChapter.isNotEmpty;
    final subtopicValid = selectedSubTopic.isNotEmpty;

    print('FORM VALIDITY boardValid: $boardValid');
    print('FORM VALIDITY mediumValid: $mediumValid');
    print('FORM VALIDITY classValid: $classValid');
    print('FORM VALIDITY subjectValid: $subjectValid');
    print('FORM VALIDITY chapterValid: $chapterValid');
    print('FORM VALIDITY subtopicValid: $subtopicValid');

    isFormValid.value =
        boardValid &&
        mediumValid &&
        classValid &&
        subjectValid &&
        chapterValid &&
        subtopicValid;

    print('isFormValid: ${isFormValid.value}');
    print('==========================\n');
  }

  /// Initializes the controller.
  ///
  /// This method fetches the user's classes and populates the board list.
  Future<void> initController() async {
    //  Loader.show();
    userClasses = UserProvider.currentUser?.classes;

    if (userClasses != null && userClasses!.isNotEmpty) {
      // Populate dropdown lists dynamically from userClasses
      boardList.assignAll(
        userClasses!.map((e) => e.board.toString()).toSet().toList(),
      );
      currentBoard.value = userClasses!.first.board.value!;
    }

    if (boardList.length == 1) {
      selectedBoard.value = boardList.first;
    }

    //   await Future.wait(<Future<void>>[getLessonPlans("all")]);
    Loader.dismiss();
  }

  @override
  void onInit() {
    // ever<List<String>>(boardList, (list) {
    //   if (list.isEmpty || !list.contains('KSEEB')) {
    //     if (!list.contains('Select Board')) {
    //       boardList.insert(0, 'Select Board');
    //     }
    //   }
    // });

    ever(selectedBoard, (board) {
      _updateMediumList(board);
      updateFormValidity();
    });

    everAll([selectedBoard, selectedMedium], (_) {
      _updateClassList(selectedBoard.value, selectedMedium.value);
      updateFormValidity();
    });

    everAll([selectedBoard, selectedMedium, selectedClass], (_) {
      _updateSubjectList(
        selectedBoard.value,
        selectedMedium.value,
        selectedClass.value,
      );
      updateFormValidity();
    });

    initController();
    super.onInit();
  }

  /// Clears the board selection and all dependent dropdowns.
  void clearBoardSelection() {
    selectedBoard.value = '';
    mediumList.clear();
    selectedMedium.value = '';
    classList.clear();
    selectedClass.value = '';
    subjectList.clear();
    selectedSubject.value = '';
    selectedSubjectCode.value = '';
    chapterList.clear();
    selectedChapter.value = '';
    subTopicList.clear();
    selectedSubTopic.value = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears the medium selection and all dependent dropdowns.
  void clearMediumSelection() {
    selectedMedium.value = '';
    classList.clear();
    selectedClass.value = '';
    subjectList.clear();
    selectedSubject.value = '';
    selectedSubjectCode.value = '';
    chapterList.clear();
    selectedChapter.value = '';
    subTopicList.clear();
    selectedSubTopic.value = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears the class selection and all dependent dropdowns.
  void clearClassSelection() {
    selectedClass.value = '';
    subjectList.clear();
    selectedSubject.value = '';
    selectedSubjectCode.value = '';
    chapterList.clear();
    selectedChapter.value = '';
    subTopicList.clear();
    selectedSubTopic.value = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears the subject selection and all dependent dropdowns.
  void clearSubjectSelection() {
    selectedSubject.value = '';
    selectedSubjectCode.value = '';
    chapterList.clear();
    selectedChapter.value = '';
    subTopicList.clear();
    selectedSubTopic.value = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears the chapter selection and all dependent dropdowns.
  void clearChapterSelection() {
    selectedChapter.value = '';
    subTopicList.clear();
    selectedSubTopic.value = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears the sub-topic selection.
  void clearSubTopicSelection() {
    selectedSubTopic.value = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  void _updateMediumList(String board) {
    if (userClasses == null) return;
    final filteredMediums = userClasses!
        .where((e) => e.board.toString() == board)
        .map((e) => e.medium.toString())
        .toSet()
        .toList();
    mediumList.assignAll(filteredMediums);
    if (mediumList.length == 1) {
      selectedMedium.value = mediumList.first;
    }
  }

  void _updateClassList(String board, String medium) {
    if (userClasses == null) return;

    final filteredClasses =
        userClasses!
            .where(
              (e) =>
                  e.board.toString() == board && e.medium.toString() == medium,
            )
            .map((e) => e.classClass.toString())
            .toSet()
            .toList()
          ..sort(
            (a, b) => int.parse(a).compareTo(int.parse(b)),
          ); // ✅ Numeric sort

    classList.assignAll(filteredClasses);
    if (classList.length == 1) {
      selectedClass.value = classList.first;
    }
  }

  void _updateSubjectList(String board, String medium, String classVal) {
    if (userClasses == null) return;

    final filteredSubjects = userClasses!
        .where(
          (e) =>
              e.board.toString() == board &&
              e.medium.toString() == medium &&
              e.classClass.toString() == classVal,
        )
        .map((e) {
          // Fix Sem 0 → Show actual semester (1, 2, etc.)
          final sem = e.sem.value ?? 0; // Null-safe sem (0 hides)
          return sem > 0 ? '${e.name} Sem $sem' : '${e.name}';
        })
        .toSet()
        .toList();

    subjectList.assignAll(filteredSubjects);

    final filteredSubjectsSelection = userClasses!
        .where(
          (e) =>
              e.board.toString() == board &&
              e.medium.toString() == medium &&
              e.classClass.toString() == classVal,
        )
        .map((e) => '${e.subject}')
        .toSet()
        .toList();

    subjectSelectionList.assignAll(filteredSubjectsSelection);
  }

  // --- Loading States ---
  /// Whether the lesson plan templates are currently being loaded.
  final RxBool isLoadingLessonPlansTemplate = false.obs;

  // --- Data Holders ---
  /// The lesson plan template data.
  final Rx<LessonPlanTemplateModel?> lessonPlanTemplate =
      Rx<LessonPlanTemplateModel?>(null);

  /// Fetches the lesson plan template list from the repository.
  Future<void> getLessonPlanTemplateList() async {
    isLoadingLessonPlansTemplate(true);
    final LessonPlanTemplateModel? result =
        await _lessonPlanGenerationDetailsRepo.getLessonPlanTemplateList(
          boards: selectedBoard.value,
          mediums: selectedMedium.value,
          classes: selectedClass.value,
          subjects: selectedSubjectCode.value,
        );
    if (result != null) {
      lessonPlanTemplate.value = result;
      templateIds.assignAll(result.data.map((item) => item.id).toList());
      //  _prepareLessonPlanList();
    }
    isLoadingLessonPlansTemplate(false);
  }

  /// Whether the chapters are currently being loaded.
  final RxBool isLoadingChapters = false.obs;

  /// The list of chapters for the selected subject.
  final RxList<String> chapterList = <String>[].obs;

  /// The currently selected chapter.
  RxString selectedChapter = ''.obs;

  /// The last fetched chapter list response.
  LessonChapterListModel? lastChaptersResponse;

  /// Fetches the chapter list from the repository.
  Future<void> getChapterList() async {
    isLoadingChapters(true);

    final LessonChapterListModel? chaptersResponse =
        await _lessonPlanGenerationDetailsRepo.getChapterList(
          board: selectedBoard.value,
          subject: selectedSubjectCode.value,
          medium: selectedMedium.value,
          standard: selectedClass.value,
        );

    _prepareChapterListFromResponse(chaptersResponse);
    isLoadingChapters(false);
  }

  /// Whether the learning outcomes are currently being loaded.
  final RxBool isLoadingLearningOutcomes = false.obs;

  /// Fetches the learning outcomes from the repository.
  Future<void> getLearningOutcomes() async {
    isLoadingLearningOutcomes(true);
    Loader.show();

    final learningDatum.LearningOutcomesModel? learningOutcomeResponse =
        await _lessonPlanGenerationDetailsRepo.getLearningOutcomes(
          chapterId: selectedChapterId,
          templateIds: templateIds.value,
        );

    _prepareLearningOutcomeListFromResponse(learningOutcomeResponse);
    isLoadingLearningOutcomes(false);
    Loader.dismiss();
  }

  /// Whether the lesson is currently being generated.
  final RxBool isLoadingGenerateLesson = false.obs;

  /// Generates the lesson plan.
  Future<void> generateLesson() async {
    isLoadingLearningOutcomes(true);

    if (selectedSubtopicId.isEmpty) {
      return;
    }
    Loader.show();
    final generateLessonResponseModel = await _lessonPlanGenerationDetailsRepo
        .generateLesson(
          subTopicId: selectedSubtopicId,
          includeVideos: includeVideos.value,
        );

    if (generateLessonResponseModel is String) {
      appSnackBar(
        message: generateLessonResponseModel,
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    } else if (generateLessonResponseModel?.success == true) {
      final String? lessonId = generateLessonResponseModel?.data?.first?.id;
      generatedLessonResponse.value = generateLessonResponseModel;
      if (lessonId != null) {
        Get.toNamed(
          Routes.LESSON_PLAN_GENERATED_VIEW,
          arguments: {
            'lessonId': lessonId,
            'from_page': FromPage.generate, // passes "view"
          },
        );
      }
    } else {
      appSnackBar(
        message: generateLessonResponseModel?.message ?? 'Something went wrong',
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    }

    //  _prepareLearningOutcomeListFromResponse(learningOutcomeResponse);
    isLoadingGenerateLesson(false);
    Loader.dismiss();
  }

  /// The list of available boards.
  final RxList<String> boardList = <String>[].obs;

  /// The list of available mediums.
  final RxList<String> mediumList = <String>[].obs;

  /// The list of available classes.
  final RxList<String> classList = <String>[].obs;

  /// The list of available subjects.
  final RxList<String> subjectList = <String>[].obs;

  /// The list of available subjects for selection.
  final RxList<String> subjectSelectionList = <String>[].obs;

  /// The currently selected board.
  RxString selectedBoard = ''.obs;

  /// Called when the board selection changes.
  ///
  /// [val] is the new board value.
  void onBoardChanged(String? val) {
    if (val != null) {
      clearBoardSelection();
      selectedBoard.value = val;
      updateFormValidity();
    }
  }

  /// The currently selected medium.
  RxString selectedMedium = ''.obs;

  /// Called when the medium selection changes.
  ///
  /// [val] is the new medium value.
  void onMediumChange(String? val) {
    if (val != null) {
      clearMediumSelection();
      selectedMedium.value = val;
      updateFormValidity();
    }
  }

  /// Whether to include videos in the generated lesson plan.
  RxBool includeVideos = true.obs;

  /// Generates the lesson plan.
  void generateLessonPlan() {
    // Use includeVideos.value as needed for generation logic
    // Show a loader, navigate, or call your API/service here.
    print('Generate lesson plan with videos: ${includeVideos.value}');
  }

  /// The currently selected class.
  RxString selectedClass = ''.obs;

  /// Called when the class selection changes.
  ///
  /// [val] is the new class value.
  void onClassChange(String? val) {
    if (val != null) {
      clearClassSelection();
      selectedClass.value = val;
      updateFormValidity();
    }
  }

  /// The currently selected subject.
  RxString selectedSubject = ''.obs;

  /// The code for the currently selected subject.
  RxString selectedSubjectCode = ''.obs;

  /// Called when the subject selection changes.
  ///
  /// [val] is the new subject value.
  Future<void> onSubjectChange(String? val) async {
    if (val != null) {
      clearSubjectSelection();
      selectedSubject.value = val;

      final selectedIdx = subjectList.indexOf(selectedSubject.value);

      selectedSubjectCode.value = selectedIdx >= 0
          ? subjectSelectionList[selectedIdx]
          : '';

      // If selectedSubject.value is not in subjectList, reset to '' or first item
      if (!subjectList.contains(selectedSubject.value)) {
        if (subjectList.isNotEmpty) {
          selectedSubject.value = subjectList.first;
          selectedSubjectCode.value = subjectSelectionList.first;
        } else {
          selectedSubject.value = '';
          selectedSubjectCode.value = '';
        }
        updateFormValidity();
      }
    }

    logD('onSubjectChange called api');
    Loader.show();
    await Future.wait(<Future<void>>[
      getLessonPlanTemplateList(),
      getChapterList(),
    ]);
    Loader.dismiss();
  }

  /// Called when the chapter selection changes.
  ///
  /// [val] is the new chapter value.
  void onChapterChange(String? val) {
    if (val != null) {
      clearChapterSelection();
      selectedChapter.value = val;

      // Load subtopics based on the selected chapter
      if (lastChaptersResponse != null) {
        _prepareSubTopicListFromChapter(lastChaptersResponse, val);
      } else {
        // In case chapters are not loaded yet, clear subtopics
        subTopicList.clear();
        selectedSubTopic.value = '';
      }

      getLearningOutcomes();
      updateFormValidity();
    }
  }

  void _prepareSubTopicListFromChapter(
    LessonChapterListModel? chaptersResponse,
    String selectedTopic,
  ) {
    if (chaptersResponse == null || chaptersResponse.data?.results == null) {
      subTopicList.clear();
      selectedSubTopic.value = '';
      return;
    }

    final chapter = chaptersResponse.data?.results?.firstWhere(
      (item) => (item.topics ?? '') == selectedTopic,
    );

    if (chapter == null) {
      subTopicList.clear();
      selectedSubTopic.value = '';
      selectedChapterId = '';
      return;
    }
    selectedChapterId = chapter!.id.toString();

    // subTopicList.assignAll(chapter.subTopics!);
    // selectedSubTopic.value = subTopicList.isNotEmpty ? subTopicList.first : '';
  }

  /// The list of sub-topics for the selected chapter.
  final RxList<String> subTopicList = <String>[].obs;

  /// The currently selected sub-topic.
  RxString selectedSubTopic = ''.obs;

  /// A list of all learning outcomes.
  final List<learningDatum.Datum> allLearningOutcomes = [];

  /// The list of learning outcomes for the selected sub-topic.
  final RxList<String> currentLearningOutcomes = <String>[].obs;

  /// Called when the sub-topic selection changes.
  ///
  /// [val] is the new sub-topic value.
  void onSubTopicChange(String? val) {
    if (val != null) {
      selectedSubTopic.value = val;
      updateCurrentLearningOutcomes(val);
      updateFormValidity();
    }
  }

  /// Whether the learning outcomes are currently being edited.
  RxBool isEditing = false.obs;

  /// The text controller for the learning outcomes text field.
  final TextEditingController learningOutcomeControllers =
      TextEditingController(text: '');

  /// Resets the learning outcomes text field.
  void resetText() {
    learningOutcomeControllers.text = '';
    isEditing.value = false;
  }

  void _prepareChapterListFromResponse(
    LessonChapterListModel? chaptersResponse,
  ) {
    logD('onSubjectChange create chapter list from response');
    lastChaptersResponse = chaptersResponse;
    if (chaptersResponse == null || chaptersResponse.data?.results == null) {
      chapterList.clear();
      selectedChapter.value = '';
      logD('onSubjectChange create chapter list returned');
      return;
    }

    final results = chaptersResponse.data!.results!;
    chapterList.assignAll(
      results
          .map((item) => item.topics ?? '')
          .where((topic) => topic.isNotEmpty)
          .toList(),
    );

    logD('onSubjectChange create chapter list ${chapterList.length}');
    selectedChapter.value = chapterList.isNotEmpty ? chapterList.first : '';
    selectedChapter.value = '';
    // Set default selection if any chapters exist
    // selectedChapter.value = chapterList.isNotEmpty ? chapterList.first : '';
  }

  void _prepareLearningOutcomeListFromResponse(
    learningDatum.LearningOutcomesModel? learningOutcomeResponse,
  ) {
    if (learningOutcomeResponse == null ||
        learningOutcomeResponse.data.isEmpty) {
      allLearningOutcomes.clear();
      currentLearningOutcomes.clear();
      selectedSubTopic.value = '';
      subTopicList.clear();
      return;
    }

    allLearningOutcomes.clear();
    allLearningOutcomes.addAll(learningOutcomeResponse.data);
    subTopicList.clear();

    // Add "All Sub-Topics" ONLY if isAll: true exists
    final hasAll = allLearningOutcomes.any((d) => d.isAll == true);
    if (hasAll) {
      subTopicList.add('All Sub-Topics');
    }

    // ALWAYS add grouped non-isAll subtopics with "|" separator
    final seenGroups = <String>{};
    for (final datum in allLearningOutcomes) {
      if (datum.isAll == true ||
          datum.subTopics == null ||
          datum.subTopics.isEmpty) {
        continue;
      }

      final firstSubtopic = datum.subTopics.first.trim();
      if (seenGroups.contains(firstSubtopic)) continue;

      seenGroups.add(firstSubtopic);

      if (datum.subTopics.length > 1) {
        // Join all subtopics with " | "
        final subtopicsText = datum.subTopics.map((s) => s.trim()).join(' | ');
        subTopicList.add(subtopicsText);
      } else {
        subTopicList.add(firstSubtopic);
      }
    }

    selectedSubTopic.value = subTopicList.isNotEmpty ? subTopicList.first : '';
    selectedSubTopic.value = '';

    logD('Subtopic list: ${subTopicList.length} items - $subTopicList');
    updateFormValidity();
  }

  /// Updates the current learning outcomes based on the selected sub-topic.
  ///
  /// [subTopic] is the selected sub-topic.
  void updateCurrentLearningOutcomes(String subTopic) {
    logD("updateCurrentLearningOutcomes $subTopic");

    if (subTopic.isEmpty) {
      currentLearningOutcomes.clear();
      learningOutcomeControllers.text = '';
      selectedSubtopicId = '';
      return;
    }

    // If user selected "All Sub-Topics", find the isAll datum
    if (subTopic == 'All Sub-Topics') {
      final learningDatum.Datum? allDatum = allLearningOutcomes
          ?.firstWhereOrNull(
            (d) => d.isAll == true, // Simple: find any isAll:true datum
          );

      if (allDatum == null) {
        currentLearningOutcomes.clear();
        learningOutcomeControllers.text = '';
        selectedSubtopicId = '';
        return;
      }

      selectedSubtopicId = allDatum.id;
      currentLearningOutcomes.assignAll(allDatum.learningOutcomes);
      learningOutcomeControllers.text = allDatum.learningOutcomes.join('\n');
      return;
    }

    // Normal case: find single subTopic datum
    final List<String> selectedParts = subTopic
        .split('|')
        .map((s) => s.trim())
        .toList();

    final learningDatum.Datum? datum = allLearningOutcomes?.firstWhereOrNull(
      (d) =>
          !d.isAll! &&
          d.subTopics.any(
            (sub) => selectedParts.any((part) => sub.trim() == part),
          ),
    );

    for (final datum in allLearningOutcomes ?? []) {
      for (final sub in datum.subTopics) {
        logD(
          "Checking datum.id ${datum.id} with subTopic '$sub' against selected '$subTopic'",
        );
        final bool matches =
            sub.trim() ==
            subTopic.trim(); // Exact match like contains() would use
        // OR for contains: final bool matches = datum.subTopics.contains(subTopic);

        logD(
          "Checking datum.id  • '$sub' and ${subTopic} → ${matches ? '✅ MATCH' : '❌ NO'} (id:${datum.id})",
        );
      }
    }

    if (datum == null) {
      logD("❌ NO MATCH: subTopic '$subTopic' not found in any datum");
      logD("📋 All available datum subTopics:");
      for (var d in allLearningOutcomes ?? []) {
        logD("  - ${d.subTopics} (isAll: ${d.isAll}, id: ${d.id})");
      }
    } else {
      logD("✅ MATCH FOUND: subTopic '$subTopic'");
      logD("📄 datum.id: ${datum.id}");
      logD("📝 datum.subTopics: ${datum.subTopics}");
      logD(
        "🎯 datum.learningOutcomes (${datum.learningOutcomes.length}): ${datum.learningOutcomes}",
      );
    }
    logD(
      "updateCurrentLearningOutcomes $subTopic oyrcom ${datum?.learningOutcomes?.first}",
    );
    logD(
      "updateCurrentLearningOutcomes $subTopic oyrcom ${datum?.learningOutcomes?.first}",
    );
    learningOutcomeControllers.text = "";

    if (datum == null) {
      currentLearningOutcomes.clear();
      learningOutcomeControllers.text = '';
      selectedSubtopicId = '';
    } else {
      currentLearningOutcomes.clear();
      selectedSubtopicId = datum.id;
      currentLearningOutcomes.assignAll(datum.learningOutcomes);
      learningOutcomeControllers.text = datum.learningOutcomes.join('\n');
    }
  }
}
