import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/modules/question_paper/models/get_by_sem_model.dart';
import 'package:sikshana/app/modules/question_paper/models/question_bank_model.dart';
import 'package:sikshana/app/modules/question_paper/models/template_model.dart';
import 'package:sikshana/app/modules/question_paper/repository/question_paper_api_repo.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A map of question types to their descriptions.
const Map<String, String> questionTypes = <String, String>{
  'Objective Questions (MCQ)':
      'Four alternatives are given for each of the following questions, '
      'choose the correct alternative',

  'Fill in the blanks with suitable words':
      'Fill in the blanks with suitable words',

  'Match the following': 'Match the following',

  'Very Short Answer': 'Answer the following in a word, phrase or sentence',

  'Short Answer': 'Answer the following in two or three sentences each',

  'Answer the following questions': 'Answer the following questions',

  'Long Answer': 'Answer the following question in four or five sentences',
};

/// Controller for the question paper generation process.
class QuestionPaperController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Global key for the configuration form.
  final GlobalKey<FormBuilderState> configurationFormKey =
      GlobalKey<FormBuilderState>();

  /// Global key for the template form.
  final GlobalKey<FormBuilderState> templateFormKey =
      GlobalKey<FormBuilderState>();

  /// Global key for the blueprint form.
  final GlobalKey<FormBuilderState> blueprintFormKey =
      GlobalKey<FormBuilderState>();

  /// Tab controller for the stepper.
  late TabController tabController;

  /// Scroll controller for the blueprint view.
  final ScrollController blueprintScrollController = ScrollController();

  /// Repository for question paper API calls.
  final QuestionPaperApiRepo _questionPaperApiRepo = QuestionPaperApiRepo();

  /// Repository for profile API calls.
  final ProfileApiRepo _profileApiRepo = ProfileApiRepo();

  /// The current step in the generation process.
  final RxInt currentStep = 1.obs;

  /// Indicates if data is being loaded.
  final RxBool isLoading = false.obs;

  /// List of available boards.
  final RxList<String> boards = <String>[].obs;

  /// List of available mediums.
  final RxList<String> mediums = <String>[].obs;

  /// List of available classes.
  final RxList<String> classes = <String>[].obs;

  /// List of available subjects.
  final RxList<String> subjects = <String>[].obs;

  /// The currently selected board.
  final RxnString selectedBoard = RxnString();

  /// The currently selected medium.
  final RxnString selectedMedium = RxnString();

  /// The currently selected class.
  final RxnString selectedClass = RxnString();

  /// The currently selected subject.
  final RxnString selectedSubject = RxnString();

  /// The name of the examination.
  final RxString examinationName = ''.obs;

  /// The total marks for the question paper.
  final RxString totalMarks = ''.obs;

  /// The scope of the question paper (e.g., 'Multiple Chapters').
  final RxString questionPaperScope = 'Multiple Chapters'.obs;

  /// List of selected chapters.
  final RxList<String> selectedChapters = <String>[].obs;

  /// List of selected sub-topics.
  final RxList<String> selectedSubTopics = <String>[].obs;

  /// List of available sub-topics.
  final RxList<String> subTopicList = <String>[].obs;

  /// The percentage of knowledge-based questions.
  final RxString knowledge = '25'.obs;

  /// The percentage of understanding-based questions.
  final RxString understanding = '45'.obs;

  /// The percentage of application-based questions.
  final RxString application = '20'.obs;

  /// The percentage of skill-based questions.
  final RxString skill = '10'.obs;

  /// Flag to show objectives on ready.
  final RxBool showObjectivesOnReady = true.obs;

  /// A map of chapter names to a list of their sub-topics.
  final RxMap<String, List<String>> chapterList = <String, List<String>>{}.obs;

  /// A map of chapter names to their IDs.
  Map<String, String> chapterIds = <String, String>{};

  /// List of question templates.
  final RxList<TemplateData> questionTemplates = <TemplateData>[].obs;

  /// List of blueprint data for the question paper.
  final RxList<TemplateData> questionBluePrint = <TemplateData>[].obs;

  /// The distribution of marks across topics.
  final RxList<Map<String, String>> marksDistribution =
      <Map<String, String>>[].obs;

  /// The total distributed marks.
  final RxInt distributedMarks = 0.obs;

  /// The total distributed marks in the template.
  final RxInt templateDistributedMarks = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      currentStep.value = tabController.index + 1;
      if (tabController.index == 1 && tabController.previousIndex == 0) {
        patchTemplateForm();
      }
      if (tabController.index == 2 && tabController.previousIndex == 1) {
        patchBlueprintForm();
      }
    });
    loadStatusData();
    questionTemplates.listen((_) {
      calculateTemplateDistributedMarks();
    });
  }

  @override
  void onReady() {
    configurationFormKey.currentState?.patchValue({
      'board': selectedBoard.value,
      'medium': selectedMedium.value,
      'class': selectedClass.value,
      'subject': selectedSubject.value,
      'knowledge': knowledge.value,
      'understanding': understanding.value,
      'application': application.value,
      'skill': skill.value,
    });
    showObjectivesOnReady.value = false;
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    blueprintScrollController.dispose();
    super.onClose();
  }

  /// Returns true if the total percentage of objectives is 100.
  bool get totalObjectives {
    final int k = int.tryParse(knowledge.value) ?? 0;
    final int u = int.tryParse(understanding.value) ?? 0;
    final int a = int.tryParse(application.value) ?? 0;
    final int s = int.tryParse(skill.value) ?? 0;
    final int totalObjectives = k + u + a + s;
    return totalObjectives == 100;
  }

  /// Returns a list of unique unit names from the blueprint.
  List<String> get blueprintUnitNames => questionBluePrint
      .expand(
        (TemplateData template) =>
            template.questionDistribution?.map((dist) => dist.unitName) ??
            <String>[],
      )
      .whereType<String>()
      .toSet()
      .toList();

  /// Returns a list of unique objectives from the blueprint.
  List<String> get blueprintObjectives => questionBluePrint
      .expand(
        (TemplateData template) =>
            template.questionDistribution?.map((dist) => dist.objective) ??
            <String>[],
      )
      .whereType<String>()
      .toSet()
      .toList();

  /// Fetches the user's profile information.
  Future<void> getProfile() async {
    isLoading(true);

    try {
      final ProfileModel? res = await _profileApiRepo.getProfile(
        userId: UserProvider.currentUser?.id ?? '',
      );
      if (res != null && (res.success ?? false)) {
        UserProvider.currentUser = UserProvider.currentUser!.copyWith(
          classes: res.data!.classes,
        );
      } else {
        appSnackBar(
          message: res?.message ?? 'Failed to fetch profile data.',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    } on Exception catch (_) {
      appSnackBar(
        message: 'An error occurred while fetching profile data.',
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Calculates the distribution of marks across topics.
  void calculateMarksDistribution() {
    marksDistribution.clear();
    final int total = int.tryParse(totalMarks.value) ?? 0;
    if (total == 0) {
      distributedMarks.value = 0;
      return;
    }

    final List<String> topics = questionPaperScope.value == 'Multiple Chapters'
        ? selectedChapters
        : selectedSubTopics;

    if (topics.isEmpty) {
      distributedMarks.value = 0;
      return;
    }

    final int marksPerTopic = total ~/ topics.length;
    final int remainingMarks = total % topics.length;
    int currentDistributedMarks = 0;

    final List<Map<String, String>> newDistribution = <Map<String, String>>[];
    for (int i = 0; i < topics.length; i++) {
      int marks = marksPerTopic;
      if (i < remainingMarks) {
        marks++;
      }
      newDistribution.add(<String, String>{
        'topic': topics[i],
        'marks': marks.toString(),
      });
      currentDistributedMarks += marks;
    }
    marksDistribution.assignAll(newDistribution);
    distributedMarks.value = currentDistributedMarks;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (configurationFormKey.currentState != null) {
        final Map<String, dynamic> newValues = {};
        for (var i = 0; i < marksDistribution.length; i++) {
          newValues['marks_$i'] = marksDistribution[i]['marks'];
        }
        configurationFormKey.currentState!.patchValue(newValues);
      }
    });
  }

  /// Called when the marks for a topic are changed.
  ///
  /// Parameters:
  /// - `index`: The index of the topic in the marks distribution list.
  /// - `marks`: The new marks for the topic.
  void onMarksChanged(int index, String marks) {
    if (index < marksDistribution.length) {
      marksDistribution[index]['marks'] = marks;
      int currentDistributedMarks = 0;
      for (final Map<String, String> item in marksDistribution) {
        currentDistributedMarks += int.tryParse(item['marks'] ?? '0') ?? 0;
      }
      distributedMarks.value = currentDistributedMarks;
      marksDistribution.refresh();
    }
  }

  /// Fetches the chapters for the selected board, medium, class, and subject.
  Future<void> getChapterBySem() async {
    if (selectedBoard.value == null ||
        selectedMedium.value == null ||
        selectedClass.value == null ||
        selectedSubject.value == null) {
      chapterList.clear();
      chapterIds = {};
      return;
    }
    final List<ClassDetail>? userClasses = UserProvider.currentUser?.classes;
    List<String> tempSubjects = <String>[];
    List<ClassDetail> tempClasses = <ClassDetail>[];
    if (userClasses != null && userClasses.isNotEmpty) {
      tempClasses = userClasses
          .where(
            (ClassDetail e) =>
                e.board.value == selectedBoard.value &&
                e.medium.value == selectedMedium.value &&
                e.classClass.value!.toString() == selectedClass.value,
          )
          .toSet()
          .toList();
    }
    if (tempClasses.isEmpty) {
      chapterList.clear();
      chapterIds = {};
      return;
    }
    tempSubjects = tempClasses
        .where(
          (ClassDetail element) => element.name.value == selectedSubject.value,
        )
        .toSet()
        .expand((ClassDetail e) => e.subjectDetails ?? <SubjectDetail>[])
        .map((SubjectDetail e) => e.subjectName)
        .whereType<String>()
        .toSet()
        .toList();
    try {
      isLoading.value = true;
      final GetBySemModel? response = await _questionPaperApiRepo
          .getChapterBySem(
            board: selectedBoard.value,
            medium: selectedMedium.value,
            standard: selectedClass.value,
            subject: tempSubjects,
          );
      if (response != null && response.data != null) {
        final Map<String, List<String>> chapters = <String, List<String>>{};
        final Map<String, String> ids = <String, String>{};
        for (final item in response.data!) {
          if (item.topics != null) {
            chapters[item.topics!] = item.subTopics ?? <String>[];
            ids[item.topics!] = item.id!;
          }
        }
        chapterList.value = chapters;
        chapterIds = ids;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads the initial status data for the question paper generation.
  void loadStatusData() {
    final List<ClassDetail>? userClasses = UserProvider.currentUser?.classes;
    if (userClasses != null && userClasses.isNotEmpty) {
      boards.value = userClasses
          .map((ClassDetail e) => e.board.value!)
          .toSet()
          .toList();
      if (boards.length == 1) {
        onBoardChanged(boards.first);
      }
    }
  }

  /// Called when the selected board changes.
  ///
  /// Parameters:
  /// - `value`: The newly selected board.
  void onBoardChanged(String? value) {
    selectedBoard.value = value;
    selectedMedium.value = null;
    selectedClass.value = null;
    selectedSubject.value = null;
    mediums.clear();
    classes.clear();
    subjects.clear();
    if (value != null) {
      final List<ClassDetail>? userClasses = UserProvider.currentUser?.classes;
      if (userClasses != null && userClasses.isNotEmpty) {
        mediums.value = userClasses
            .where((ClassDetail e) => e.board.value == value)
            .map((ClassDetail e) => e.medium.value!)
            .toSet()
            .toList();
        if (mediums.length == 1) {
          onMediumChanged(mediums.first);
          return;
        }
      }
    }
  }

  /// Called when the selected medium changes.
  ///
  /// Parameters:
  /// - `value`: The newly selected medium.
  void onMediumChanged(String? value) {
    selectedMedium.value = value;
    selectedClass.value = null;
    selectedSubject.value = null;
    classes.clear();
    subjects.clear();
    if (value != null) {
      final List<ClassDetail>? userClasses = UserProvider.currentUser?.classes;
      if (userClasses != null && userClasses.isNotEmpty) {
        classes.value = userClasses
            .where(
              (ClassDetail e) =>
                  e.board.value == selectedBoard.value &&
                  e.medium.value == value,
            )
            .map((ClassDetail e) => e.classClass.value!.toString())
            .toSet()
            .toList();
        if (classes.length == 1) {
          onClassChanged(classes.first);
          return;
        }
      }
    }
  }

  /// Called when the selected class changes.
  ///
  /// Parameters:
  /// - `value`: The newly selected class.
  void onClassChanged(String? value) {
    selectedClass.value = value;
    selectedSubject.value = null;
    subjects.clear();
    if (value != null) {
      final List<ClassDetail>? userClasses = UserProvider.currentUser?.classes;
      if (userClasses != null && userClasses.isNotEmpty) {
        subjects.value = userClasses
            .where(
              (ClassDetail e) =>
                  e.board.value == selectedBoard.value &&
                  e.medium.value == selectedMedium.value &&
                  e.classClass.value!.toString() == value,
            )
            .map((ClassDetail e) => e.name.value!)
            .toSet()
            .toList();
        if (subjects.length == 1) {
          onSubjectChanged(subjects.first);
          return;
        }
      }
    }
  }

  /// Called when the selected subject changes.
  ///
  /// Parameters:
  /// - `value`: The newly selected subject.
  void onSubjectChanged(String? value) {
    selectedSubject.value = value;
    getChapterBySem();
  }

  /// Called when the examination name changes.
  ///
  /// Parameters:
  /// - `value`: The new examination name.
  void onExaminationNameChanged(String value) {
    examinationName.value = value;
  }

  /// Called when the total marks change.
  ///
  /// Parameters:
  /// - `value`: The new total marks.
  void onTotalMarksChanged(String value) {
    totalMarks.value = value;
    calculateMarksDistribution();
  }

  /// Called when the question paper scope changes.
  ///
  /// Parameters:
  /// - `value`: The new question paper scope.
  void onQuestionPaperScopeChanged(String? value) {
    if (value != null) {
      questionPaperScope.value = value;
    }
    configurationFormKey.currentState!.patchValue(<String, dynamic>{
      'chapter': <String>[],
      'subtopic': <String>[],
    });
    selectedChapters.clear();
    subTopicList.clear();
    selectedSubTopics.clear();
    calculateMarksDistribution();
  }

  /// Called when the selected chapters change.
  ///
  /// Parameters:
  /// - `value`: The list of newly selected chapters.
  void onChapterChanged(List<String>? value) {
    selectedSubTopics.clear();
    if (value != null && value.isNotEmpty) {
      if (questionPaperScope.value == 'Multiple Chapters') {
        selectedChapters.assignAll(value);
        subTopicList.clear();
      } else {
        selectedChapters.assignAll(value);
        subTopicList.value = chapterList[value.first] ?? <String>[];
      }
    } else {
      selectedChapters.clear();
      subTopicList.clear();
    }

    if (questionPaperScope.value == 'Multiple Chapters') {
      calculateMarksDistribution();
    } else {
      marksDistribution.clear();
      distributedMarks.value = 0;
    }
  }

  /// Called when the selected sub-topics change.
  ///
  /// Parameters:
  /// - `value`: The list of newly selected sub-topics.
  void onSubTopicChanged(List<String>? value) {
    if (value != null) {
      selectedSubTopics.assignAll(value);
    } else {
      selectedSubTopics.clear();
    }
    calculateMarksDistribution();
  }

  /// Called when the generate question paper button is pressed.
  void onGenerateQuestionPaper() {
    if (blueprintFormKey.currentState!.validate()) {
      generateQuestionBank();
    }
  }

  /// Called when the next button is pressed.
  Future<void> onNextPressed() async {
    if (tabController.index == 0) {
      if (configurationFormKey.currentState!.validate()) {
        if (questionPaperScope.value == 'Multiple Chapters' &&
            (selectedChapters.value?.length ?? 0) < 2) {
          // Adjust Rx var names as needed
          if (!Get.isSnackbarOpen) {
            appSnackBar(
              message: LocaleKeys
                  .atLeastTwoChaptersRequired
                  .tr, // "Select at least 2 chapters"
              state: SnackBarState.warning,
            );
          }
          return;
        }
        if (!totalObjectives) {
          if (!Get.isSnackbarOpen) {
            appSnackBar(
              message: LocaleKeys.pleaseEnsureTheSumOfAllObjectives.tr,
              state: SnackBarState.warning,
            );
          }
          return;
        }
        if (distributedMarks.value != (int.tryParse(totalMarks.value) ?? 0)) {
          if (!Get.isSnackbarOpen) {
            appSnackBar(
              message: LocaleKeys.theTotalDistributionOfMarksMustEqual.tr,
              state: SnackBarState.warning,
            );
          }
          return;
        }
        unawaited(generateTemplate());
      }
    } else if (tabController.index == 1) {
      if (templateFormKey.currentState!.validate()) {
        if (!(templateDistributedMarks.value.toString() == totalMarks.value)) {
          if (!Get.isSnackbarOpen) {
            appSnackBar(
              message: LocaleKeys.theTotalMarksDistributedInTheTemplate.tr,
              state: SnackBarState.warning,
            );
          }
          return;
        }
        if (questionTemplates.length !=
            questionTemplates()
                .map((TemplateData e) => e.type)
                .toSet()
                .length) {
          if (!Get.isSnackbarOpen) {
            appSnackBar(
              message: LocaleKeys.duplicateQuestionTypesFoundPleaseVerify.tr,
              state: SnackBarState.warning,
            );
          }
          return;
        }
        unawaited(generateBluePrint());
      }
    }
  }

  /// Generates the question paper template.
  Future<void> generateTemplate() async {
    try {
      Loader.show();
      final List<String> ids = <String>[];
      for (final String s in selectedChapters) {
        if (chapterIds[s] != null) {
          ids.add(chapterIds[s]!);
        }
      }
      final TemplateModel? response = await _questionPaperApiRepo
          .generateTemplate(
            board: selectedBoard.value,
            medium: selectedMedium.value,
            grade: int.tryParse(selectedClass.value ?? '0'),
            subject: selectedSubject.value,
            chapter: selectedChapters,
            chapterIds: ids,
            subTopic: questionPaperScope.value == 'Single Chapter'
                ? selectedSubTopics
                : null,
            totalMarks: int.tryParse(totalMarks.value),
            examinationName: examinationName.value,
            isMultiChapter: questionPaperScope.value == 'Multiple Chapters',
            marksDistribution: marksDistribution
                .map(
                  (Map<String, String> e) => <String, dynamic>{
                    'unit_name': e['topic'],
                    'marks': int.tryParse(e['marks'] ?? '0'),
                    'percentage_distribution':
                        (int.parse(e['marks'] ?? '0') /
                                (int.tryParse(totalMarks.value) ?? 1) *
                                100)
                            .toStringAsFixed(0),
                  },
                )
                .toList(),
          );
      if (response?.data != null) {
        if (tabController.index < 2) {
          tabController.animateTo(tabController.index + 1);
        }
        questionTemplates.value = response!.data!;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Loader.dismiss();
    }
  }

  /// Patches the blueprint form with the generated blueprint data.
  void patchBlueprintForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (blueprintFormKey.currentState != null) {
        final Map<String, dynamic> newValues = <String, dynamic>{};
        for (int i = 0; i < questionBluePrint.length; i++) {
          if (questionBluePrint[i].questionDistribution != null) {
            for (
              int j = 0;
              j < questionBluePrint[i].questionDistribution!.length;
              j++
            ) {
              final questionDistribution =
                  questionBluePrint[i].questionDistribution![j];
              newValues['topic_${i}_$j'] = questionDistribution.unitName != null
                  ? <String>[questionDistribution.unitName!]
                  : null;
              newValues['objective_${i}_$j'] =
                  questionDistribution.objective != null
                  ? <String>[questionDistribution.objective!]
                  : null;
            }
          }
        }
        blueprintFormKey.currentState!.patchValue(newValues);
      }
    });
  }

  /// Patches the template form with the generated template data.
  void patchTemplateForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (templateFormKey.currentState != null) {
        final Map<String, dynamic> newValues = <String, dynamic>{};
        for (int i = 0; i < questionTemplates.length; i++) {
          newValues['question_type_$i'] = questionTemplates[i].type != null
              ? <String>[
                  questionTypes.keys.toList().firstWhereOrNull(
                        (String element) =>
                            questionTypes[element] == questionTemplates[i].type,
                      ) ??
                      questionTemplates[i].type!,
                ]
              : null;
          newValues['number_of_questions_$i'] = questionTemplates[i]
              .numberOfQuestions
              ?.toString();
          newValues['marks_per_question_$i'] = questionTemplates[i]
              .marksPerQuestion
              ?.toString();
        }
        templateFormKey.currentState!.patchValue(newValues);
        calculateTemplateDistributedMarks();
      }
    });
  }

  /// Generates the question paper blueprint.
  Future<void> generateBluePrint() async {
    try {
      Loader.show();
      final List<String> ids = <String>[];
      for (final String s in selectedChapters) {
        if (chapterIds[s] != null) {
          ids.add(chapterIds[s]!);
        }
      }
      final response = await _questionPaperApiRepo.generateBluePrint(
        board: selectedBoard.value,
        medium: selectedMedium.value,
        grade: int.tryParse(selectedClass.value ?? '0'),
        subject: selectedSubject.value,
        chapter: selectedChapters,
        chapterIds: ids,
        subTopic: questionPaperScope.value == 'Single Chapter'
            ? selectedSubTopics
            : null,
        totalMarks: int.tryParse(totalMarks.value),
        examinationName: examinationName.value,
        isMultiChapter: questionPaperScope.value == 'Multiple Chapters',
        marksDistribution: marksDistribution
            .map(
              (Map<String, String> e) => <String, dynamic>{
                'unit_name': e['topic'],
                'marks': int.tryParse(e['marks'] ?? '0'),
                'percentage_distribution':
                    (int.parse(e['marks'] ?? '0') /
                            (int.tryParse(totalMarks.value) ?? 1) *
                            100)
                        .toStringAsFixed(0),
              },
            )
            .toList(),
        objectiveDistribution: <Map<String, dynamic>>[
          <String, dynamic>{
            'objective': 'Knowledge',
            'percentage_distribution': int.tryParse(knowledge.value),
          },
          <String, dynamic>{
            'objective': 'Understanding',
            'percentage_distribution': int.tryParse(understanding.value),
          },
          <String, dynamic>{
            'objective': 'Application',
            'percentage_distribution': int.tryParse(application.value),
          },
          <String, dynamic>{
            'objective': 'Skill',
            'percentage_distribution': int.tryParse(skill.value),
          },
        ],
        template: questionTemplates
            .map(
              (TemplateData e) =>
                  e.copyWith(type: questionTypes['${e.type}']).toJson(),
            )
            .toList(),
      );
      if (response?.data != null) {
        // templateData.value = response!;
        if (tabController.index < 2) {
          tabController.animateTo(tabController.index + 1);
        }
        questionBluePrint.value = response!.data!;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Loader.dismiss();
    }
  }

  /// Calculates the total distributed marks in the template.
  void calculateTemplateDistributedMarks() {
    int total = 0;
    for (final TemplateData template in questionTemplates) {
      total +=
          (template.numberOfQuestions ?? 0) * (template.marksPerQuestion ?? 0);
    }
    templateDistributedMarks.value = total;
  }

  /// Navigates to the previous step in the generation process.
  void onPreviousPressed() {
    if (tabController.index > 0) {
      tabController.animateTo(tabController.index - 1);
    }
  }

  /// Adds a new question template.
  void addQuestionTemplate() {
    if (templateFormKey.currentState!.validate()) {
      questionTemplates.add(TemplateData());
    }
  }

  /// Removes a question template at the specified index.
  ///
  /// Parameters:
  /// - `index`: The index of the template to remove.
  void removeQuestionTemplate(int index) {
    final int oldLength = questionTemplates.length;
    questionTemplates.removeAt(index);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (templateFormKey.currentState != null) {
        final Map<String, dynamic> newValues = <String, dynamic>{};

        for (int i = 0; i < questionTemplates.length; i++) {
          newValues['question_type_$i'] = questionTemplates[i].type != null
              ? <String>[
                  questionTypes.keys.toList().firstWhereOrNull(
                        (String element) =>
                            questionTypes[element] == questionTemplates[i].type,
                      ) ??
                      questionTemplates[i].type!,
                ]
              : null;
          newValues['number_of_questions_$i'] = questionTemplates[i]
              .numberOfQuestions
              ?.toString();
          newValues['marks_per_question_$i'] = questionTemplates[i]
              .marksPerQuestion
              ?.toString();
        }

        // Null out old values that are no longer needed
        for (int i = questionTemplates.length; i < oldLength; i++) {
          newValues['question_type_$i'] = null;
          newValues['number_of_questions_$i'] = null;
          newValues['marks_per_question_$i'] = null;
        }

        templateFormKey.currentState!.patchValue(newValues);
      }
    });
  }

  /// Generates the final question bank.
  Future<void> generateQuestionBank() async {
    try {
      Loader.show();
      final List<String> chapterIdsList = <String>[];
      for (final String s in selectedChapters) {
        if (chapterIds[s] != null) {
          chapterIdsList.add(chapterIds[s]!);
        }
      }

      final QuestionBankModel? response = await _questionPaperApiRepo
          .generateQuestionBank(
            medium: selectedMedium.value,
            board: selectedBoard.value,
            grade: int.tryParse(selectedClass.value ?? '0'),
            subject: selectedSubject.value,
            chapter: selectedChapters,
            subTopic: questionPaperScope.value == 'Single Chapter'
                ? selectedSubTopics
                : null,
            totalMarks: int.tryParse(totalMarks.value),
            examinationName: examinationName.value,
            chapterIds: chapterIdsList,
            isMultiChapter: questionPaperScope.value == 'Multiple Chapters',
            marksDistribution: marksDistribution
                .map(
                  (Map<String, String> e) => <String, dynamic>{
                    'unit_name': e['topic'],
                    'marks': int.tryParse(e['marks'] ?? '0'),
                    'percentage_distribution':
                        (int.parse(e['marks'] ?? '0') /
                                (int.tryParse(totalMarks.value) ?? 1) *
                                100)
                            .toStringAsFixed(0),
                  },
                )
                .toList(),
            objectiveDistribution: <Map<String, dynamic>>[
              <String, dynamic>{
                'objective': 'Knowledge',
                'percentage_distribution': int.tryParse(knowledge.value),
              },
              <String, dynamic>{
                'objective': 'Understanding',
                'percentage_distribution': int.tryParse(understanding.value),
              },
              <String, dynamic>{
                'objective': 'Application',
                'percentage_distribution': int.tryParse(application.value),
              },
              <String, dynamic>{
                'objective': 'Skill',
                'percentage_distribution': int.tryParse(skill.value),
              },
            ],
            template: questionBluePrint
                .map(
                  (TemplateData e) =>
                      e.copyWith(type: questionTypes['${e.type}']).toJson(),
                )
                .toList(),
            questionBankTemplate: questionTemplates
                .map(
                  (TemplateData e) =>
                      e.copyWith(type: questionTypes['${e.type}']).toJson(),
                )
                .toList(),
          );

      if (response?.data != null) {
        debugPrint('Question Bank Generated: ${response?.message}');

        appSnackBar(
          message: 'Question Bank Generated',
          type: SnackBarType.top,
          state: SnackBarState.success,
        );
        unawaited(
          Get.offAndToNamed(
            Routes.VIEW_QUESTION_PAPER,
            arguments: <String, String>{'id': response!.data!.id!},
          ),
        );
      }
    } catch (e) {
      debugPrint('Error generating question bank: $e');
    } finally {
      Loader.dismiss();
    }
  }
}
