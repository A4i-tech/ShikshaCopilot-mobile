import 'package:sikshana/app/modules/lesson_plan_generated_view/utils/from_page.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/lesson_chapter_list_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generation_details/models/generate_resource_response_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generation_details/models/lesson_resource_template_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generation_details/repository/lesson_resource_generation_details_repo.dart';
import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/learning_outcomes_model.dart'
    as learningDatum;

import 'package:sikshana/app/utils/exports.dart';

/// Controller for the lesson resource generation details screen.
///
/// This controller manages the state and business logic for creating
/// lesson resources, including fetching data for dropdowns, handling user
/// selections, and generating the final resource.
class LessonResourceGenerationDetailsController extends GetxController {
  /// The user's class details.
  List<ClassDetail>? userClasses;

  /// The response from the generate resource API.
  final Rx<GenerateResourceResponseModel?> generatedResourceResponse =
      Rx<GenerateResourceResponseModel?>(null);

  final LessonResourceGenerationDetailsRepo
  _lessonResourceGenerationDetailsRepo = LessonResourceGenerationDetailsRepo();

  /// The ID of the selected chapter.
  String selectedChapterId = '';

  /// A list of template IDs.
  final RxList<String> templateIds = <String>[].obs;

  /// The ID of the selected subtopic.
  String selectedSubtopicId = '';

  /// A list of available boards.
  final RxList<String> boardList = <String>[].obs;

  /// A list of available mediums.
  final RxList<String> mediumList = <String>[].obs;

  /// A list of available classes.
  final RxList<String> classList = <String>[].obs;

  /// A list of available subjects.
  final RxList<String> subjectList = <String>[].obs;

  /// A list of subject codes for selection.
  final RxList<String> subjectSelectionList = <String>[].obs;

  /// The currently selected board.
  RxString selectedBoard = ''.obs;

  RxString currentBoard = ''.obs;

  /// Whether all mandatory fields are filled for generation.
  final RxBool isFormValid = false.obs;

  /// Updates form validity based on mandatory selections.
  void updateFormValidity() {
    // Print all values with keys for debugging
    print('=== RESOURCE FORM VALIDITY CHECK ===');
    print('selectedBoard: "${selectedBoard.value}"');
    print('selectedMedium: "${selectedMedium.value}"');
    print('selectedClass: "${selectedClass.value}"');
    print('selectedSubject: "${selectedSubject.value}"');
    print('selectedChapter: "${selectedChapter.value}"');
    print('selectedSubTopic: "${selectedSubTopic.value}"');
    print('selectedChapterId: "$selectedChapterId"');
    print('selectedSubtopicId: "$selectedSubtopicId"');

    final boardValid = selectedBoard.isNotEmpty;
    final mediumValid = selectedMedium.isNotEmpty;
    final classValid = selectedClass.isNotEmpty;
    final subjectValid = selectedSubject.isNotEmpty;
    final chapterValid = selectedChapter.isNotEmpty;
    final subtopicValid = selectedSubTopic.isNotEmpty;

    print('boardValid: $boardValid');
    print('mediumValid: $mediumValid');
    print('classValid: $classValid');
    print('subjectValid: $subjectValid');
    print('chapterValid: $chapterValid');
    print('subtopicValid: $subtopicValid');

    isFormValid.value =
        boardValid &&
        mediumValid &&
        classValid &&
        subjectValid &&
        chapterValid &&
        subtopicValid;

    print('isFormValid: ${isFormValid.value}');
    print('===============================\n');
  }

  /// Handles the change of the selected board.
  ///
  /// Clears the subsequent selections and updates the selected board.
  ///
  /// [val] is the new selected board.
  void onBoardChanged(String? val) {
    if (val != null) {
      clearBoardSelection();
      selectedBoard.value = val;

      updateFormValidity();
    }
  }

  /// The currently selected medium.
  RxString selectedMedium = ''.obs;

  /// Handles the change of the selected medium.
  ///
  /// Clears the subsequent selections and updates the selected medium.
  ///
  /// [val] is the new selected medium.
  void onMediumChange(String? val) {
    if (val != null) {
      clearMediumSelection();
      selectedMedium.value = val;
      updateFormValidity();
    }
  }

  /// The currently selected class.
  RxString selectedClass = ''.obs;

  /// Handles the change of the selected class.
  ///
  /// Clears the subsequent selections and updates the selected class.
  ///
  /// [val] is the new selected class.
  void onClassChange(String? val) {
    if (val != null) {
      clearClassSelection();
      selectedClass.value = val;
      updateFormValidity();
    }
  }

  /// The currently selected subject.
  RxString selectedSubject = ''.obs;

  /// The code of the currently selected subject.
  RxString selectedSubjectCode = ''.obs;

  /// Handles the change of the selected subject.
  ///
  /// Clears the subsequent selections, updates the selected subject and its code,
  /// and fetches the lesson plan templates and chapter list.
  ///
  /// [val] is the new selected subject.
  Future<void> onSubjectChange(String? val) async {
    if (val != null) {
      clearSubjectSelection();
      selectedSubject.value = val;

      final selectedIdx = subjectList.indexOf(selectedSubject.value);

      selectedSubjectCode.value = selectedIdx >= 0
          ? subjectSelectionList[selectedIdx]
          : '';
    }
    Loader.show();
    await Future.wait(<Future<void>>[
      getLessonPlanTemplateList(),
      getChapterList(),
    ]);
    updateFormValidity();
    Loader.dismiss();
  }

  /// Clears all selections related to the board.
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
    selectedChapterId = '';
    selectedSubtopicId = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears all selections related to the medium.
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
    selectedChapterId = '';
    selectedSubtopicId = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears all selections related to the class.
  void clearClassSelection() {
    selectedClass.value = '';
    subjectList.clear();
    selectedSubject.value = '';
    selectedSubjectCode.value = '';
    chapterList.clear();
    selectedChapter.value = '';
    subTopicList.clear();
    selectedSubTopic.value = '';
    selectedChapterId = '';
    selectedSubtopicId = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears all selections related to the subject.
  void clearSubjectSelection() {
    selectedSubject.value = '';
    selectedSubjectCode.value = '';
    chapterList.clear();
    selectedChapter.value = '';
    subTopicList.clear();
    selectedSubTopic.value = '';
    selectedChapterId = '';
    selectedSubtopicId = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears all selections related to the chapter.
  void clearChapterSelection() {
    selectedChapter.value = '';
    subTopicList.clear();
    selectedSubTopic.value = '';
    selectedChapterId = '';
    selectedSubtopicId = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Clears the subtopic selection.
  void clearSubTopicSelection() {
    selectedSubTopic.value = '';
    selectedSubtopicId = '';
    currentLearningOutcomes.clear();
    updateFormValidity();
  }

  /// Initializes the controller.
  ///
  /// Fetches the user's classes and populates the board list.
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

    Loader.dismiss();
  }

  @override
  void onInit() {
    // ever<List<String>>(boardList, (list) {
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

  // --- Loading States ---
  /// Whether the lesson plan templates are currently being loaded.
  final RxBool isLoadingLessonPlansTemplate = false.obs;

  // --- Data Holders ---
  /// The lesson resource template model.
  final Rx<LessonResourceTemplateModel?> lessonResourceTemplate =
      Rx<LessonResourceTemplateModel?>(null);

  /// Fetches the list of lesson plan templates.
  Future<void> getLessonPlanTemplateList() async {
    isLoadingLessonPlansTemplate(true);
    final LessonResourceTemplateModel? result =
        await _lessonResourceGenerationDetailsRepo
            .getLessonResourceTemplateList(
              boards: selectedBoard.value,
              mediums: selectedMedium.value,
              classes: selectedClass.value,
              subjects: selectedSubjectCode.value,
            );
    if (result != null) {
      lessonResourceTemplate.value = result;
      templateIds.assignAll(result.data.map((item) => item.id).toList());
      //  _prepareLessonPlanList();
    }
    isLoadingLessonPlansTemplate(false);
  }

  /// Whether the chapters are currently being loaded.
  final RxBool isLoadingChapters = false.obs;

  /// A list of available chapters.
  final RxList<String> chapterList = <String>[].obs;

  /// The currently selected chapter.
  RxString selectedChapter = ''.obs;

  /// The last response from the chapter list API.
  LessonChapterListModel? lastChaptersResponse;

  /// Fetches the list of chapters.
  Future<void> getChapterList() async {
    isLoadingChapters(true);

    final LessonChapterListModel? chaptersResponse =
        await _lessonResourceGenerationDetailsRepo.getChapterList(
          board: selectedBoard.value,
          subject: selectedSubjectCode.value,
          medium: selectedMedium.value,
          standard: selectedClass.value,
        );

    _prepareChapterListFromResponse(chaptersResponse);
    isLoadingChapters(false);
  }

  void _prepareChapterListFromResponse(
    LessonChapterListModel? chaptersResponse,
  ) {
    logD('_prepareChapterListFromResponse calles ${chapterList.length}');
    lastChaptersResponse = chaptersResponse;
    logD('_prepareChapterListFromResponse call success ${chapterList.length}');
    if (chaptersResponse == null || chaptersResponse.data?.results == null) {
      chapterList.clear();
      selectedChapter.value = '';
      return;
    }

    final results = chaptersResponse.data!.results!;
    chapterList.assignAll(
      results
          .map((item) => item.topics ?? '')
          .where((topic) => topic.isNotEmpty)
          .toList(),
    );

    logD('_prepareChapterListFromResponse ${chapterList.length}');
    selectedChapter.value = chapterList.isNotEmpty ? chapterList.first : '';
    selectedChapter.value = '';

    // selectedChapter.value = chapterList.isNotEmpty ? chapterList.first : '';
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Observable checkbox states
  /// Whether the beginner level is selected.
  final RxBool beginnerSelected = true.obs;

  /// Whether the intermediate level is selected.
  final RxBool intermediateSelected = true.obs;

  /// Whether the advanced level is selected.
  final RxBool advancedSelected = true.obs;

  // Toggle methods for each checkbox
  /// Toggles the beginner level selection.
  ///
  /// [val] is the new selection state.
  void toggleBeginner(bool? val) {
    if (val != null) {
      beginnerSelected.value = val;
    }
  }

  /// Toggles the intermediate level selection.
  ///
  /// [val] is the new selection state.
  void toggleIntermediate(bool? val) {
    if (val != null) {
      intermediateSelected.value = val;
    }
  }

  /// Toggles the advanced level selection.
  ///
  /// [val] is the new selection state.
  void toggleAdvanced(bool? val) {
    if (val != null) {
      advancedSelected.value = val;
    }
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
          ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    classList.assignAll(filteredClasses);
    if (classList.length == 1) {
      selectedClass.value = classList.first;
    }
  }

  void _updateSubjectList(String board, String medium, String classVal) {
    if (userClasses == null) return;

    // 1) For the visible subject list (with Sem when > 0)
    final List<String> filteredSubjects = userClasses!
        .where(
          (e) =>
              e.board.toString() == board &&
              e.medium.toString() == medium &&
              e.classClass.toString() == classVal,
        )
        .map<String>((e) {
          final sem = e.sem.value ?? 0;
          return sem > 0 ? '${e.name} Sem $sem' : '${e.name}';
        })
        .toSet()
        .toList();

    subjectList.assignAll(filteredSubjects); // assignAll(Iterable<String>)

    // 2) For the selection value list (pure subject string)
    final List<String> filteredSubjectsSelection = userClasses!
        .where(
          (e) =>
              e.board.toString() == board &&
              e.medium.toString() == medium &&
              e.classClass.toString() == classVal,
        )
        .map<String>((e) => '${e.subject}')
        .toSet()
        .toList();

    subjectSelectionList.assignAll(filteredSubjectsSelection);
  }

  /// Handles the change of the selected chapter.
  ///
  /// Clears the chapter selection, updates the selected chapter,
  /// prepares the subtopic list, and fetches the learning outcomes.
  ///
  /// [val] is the new selected chapter.
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
    }
  }

  /// Whether the learning outcomes are currently being loaded.
  final RxBool isLoadingLearningOutcomes = false.obs;

  /// Fetches the learning outcomes for the selected chapter and templates.
  Future<void> getLearningOutcomes() async {
    isLoadingLearningOutcomes(true);

    Loader.show();

    final learningDatum.LearningOutcomesModel? learningOutcomeResponse =
        await _lessonResourceGenerationDetailsRepo.getResourceLearningOutcomes(
          chapterId: selectedChapterId,
          templateIds: templateIds.value,
        );

    _prepareLearningOutcomeListFromResponse(learningOutcomeResponse);
    isLoadingLearningOutcomes(false);
    Loader.dismiss();
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

    //  subTopicList.assignAll(chapter.subTopics!);
    selectedSubTopic.value = subTopicList.isNotEmpty ? subTopicList.first : '';
  }

  // Sub Topic
  /// A list of available subtopics.
  final RxList<String> subTopicList = <String>[].obs;

  /// The currently selected subtopic.
  RxString selectedSubTopic = ''.obs;

  /// A list of all learning outcomes.
  final List<learningDatum.Datum> allLearningOutcomes = [];

  /// A list of the current learning outcomes.
  final RxList<String> currentLearningOutcomes = <String>[].obs;

  /// Whether the learning outcomes are in editing mode.
  RxBool isEditing = false.obs;

  /// The text controller for the learning outcomes.
  final TextEditingController learningOutcomeControllers =
      TextEditingController(text: '');

  /// Resets the text of the learning outcome controller.
  void resetText() {
    learningOutcomeControllers.text = '';
    isEditing.value = false;
  }

  /// Handles the change of the selected subtopic.
  ///
  /// Clears the subtopic selection and updates the current learning outcomes.
  ///
  /// [val] is the new selected subtopic.
  void onSubTopicChange(String? val) {
    if (val != null) {
      clearSubTopicSelection();
      selectedSubTopic.value = val;
      updateCurrentLearningOutcomes(val);
      updateFormValidity();
    }
  }

  /// Updates the current learning outcomes based on the selected subtopic.
  ///
  /// [subTopic] is the selected subtopic.
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
      final learningDatum.Datum? allDatum = allLearningOutcomes.firstWhere(
        (d) => d.isAll == true,
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
    final learningDatum.Datum? datum = allLearningOutcomes.firstWhere(
      (d) => d.subTopics.contains(subTopic) && d.isAll == false,
    );

    if (datum == null) {
      currentLearningOutcomes.clear();
      learningOutcomeControllers.text = '';
      selectedSubtopicId = '';
    } else {
      selectedSubtopicId = datum.id;
      currentLearningOutcomes.assignAll(datum.learningOutcomes);
      learningOutcomeControllers.text = datum.learningOutcomes.join('\n');
    }
  }

  /// Whether the resource is currently being generated.
  final RxBool isLoadingGenerateResource = false.obs;

  /// Generates the lesson resource.
  ///
  /// This method builds the list of selected levels, calls the generate
  /// resource API, and handles the response.
  Future<void> generateResource() async {
    isLoadingGenerateResource(true);
    Loader.show();

    if (selectedSubtopicId.isEmpty) {
      isLoadingGenerateResource(false);
      return;
    }

    // Build the levels list from checkbox state
    final List<String> levels = [];
    if (beginnerSelected.value) levels.add("beginner");
    if (intermediateSelected.value) levels.add("intermediate");
    if (advancedSelected.value) levels.add("advanced");

    // Call the resource API
    final generateResourceResponseModel =
        await _lessonResourceGenerationDetailsRepo.generateResource(
          subTopicId: selectedSubtopicId,
          //   levels: levels, // new parameter
        );
    if (generateResourceResponseModel is String) {
      appSnackBar(
        message: generateResourceResponseModel,
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    } else if (generateResourceResponseModel?.success == true) {
      final String? resourceId = generateResourceResponseModel?.data?.first?.id;
      generatedResourceResponse.value = generateResourceResponseModel;
      if (resourceId != null) {
        Get.toNamed(
          Routes.LESSON_RESOURCE_GENERATED_VIEW,
          arguments: {
            'resourceId': resourceId,
            'from_page': FromPage.generate, // passes "view"
          },
        );
      }
    } else {
      appSnackBar(
        message:
            generateResourceResponseModel?.message ?? 'Something went wrong',
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    }
    Loader.dismiss();
    isLoadingGenerateResource(false);
  }
}
