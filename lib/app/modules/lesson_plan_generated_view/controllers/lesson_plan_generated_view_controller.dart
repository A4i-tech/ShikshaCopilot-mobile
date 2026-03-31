import 'package:sikshana/app/modules/lesson_plan_generated_view/models/create_lesson_feedback_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/regenerate_limit_response_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/regenerate_response_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/save_lesson_plan_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/view_lesson_plan_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/repository/lesson_plan_view_repository.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/utils/generate_files.dart';
import 'package:sikshana/app/modules/view_question_paper/views/widgets/docx_generator.dart';
import 'package:sikshana/app/modules/view_question_paper/views/widgets/pdf_generator.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Controller responsible for:
/// - Fetching, managing, and updating generated lesson plan data
/// - Handling regeneration rules & limits
/// - Saving lesson plans
/// - Generating DOCX/PDF outputs
/// - Adding/deleting lesson media
/// - Managing feedback and learning outcomes
///
/// This controller communicates with:
/// - [LessonPlanViewRepository] for API interactions
/// - Other GetX controllers for navigation and UI updates
class LessonPlanGeneratedViewController extends GetxController {
  /// Repository for performing network requests related to lesson plans.
  final LessonPlanViewRepository _lessonPlanViewRepository =
      LessonPlanViewRepository();

  final RxBool showChapterDetailsTooltip = false.obs;

  /// The index of the currently selected main tab (Lesson, Summary, etc.).
  final RxInt _mainTabIndex = 0.obs;

  /// Getter for the currently selected main tab index.
  int get mainTabIndex => _mainTabIndex.value;

  /// Setter for the main tab index, allowing external updates.
  void setMainTabIndex(int index) {
    _mainTabIndex.value = index;
  }

  // ---------------------------------------------------------------------------
  // LOADING STATES
  // ---------------------------------------------------------------------------

  /// Indicates whether lesson plan data is currently being loaded.
  final RxBool isLoadingLessonPlan = false.obs;

  /// Tracks which sections are currently in "edit" mode.
  ///
  /// This should be initialized after section data loads using [initializeEditFlags].
  final RxList<bool> isSectionEdit = <bool>[].obs;

  ///boolean value to check if screen can pop with unsaved data
  final RxBool canPop = true.obs;

  /// Initializes the edit flags for each lesson section.
  ///
  /// [count] — total number of sections in the lesson plan.
  void initializeEditFlags(int count) {
    isSectionEdit.value = List.filled(count, false);
  }

  final RxBool showFeedbackSection = false.obs;
  ScrollController scrollController = ScrollController();

  void toggleFeedbackSection() {
    showFeedbackSection.value = !showFeedbackSection.value;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final double targetOffset = showFeedbackSection.value
          ? scrollController
                .position
                .maxScrollExtent // 👇 show → go bottom
          : scrollController.position.minScrollExtent; // 👆 hide → go top (0.0)

      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  bool get hasChecklist {
    final fromPage = Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    if (fromPage == FromPage.view) {
      return lessonPlan.value?.data?.sections?.any(
            (s) => s.id == "section_checklist",
          ) ??
          false;
    }

    final genController = Get.find<LessonPlanGenerationDetailsController>();
    final generatedData =
        genController.generatedLessonResponse.value?.data?.first;
    return generatedData?.sections?.any((s) => s.id == "section_checklist") ??
        false;
  }

  bool get hasApiLoaded {
    final fromPage = Get.arguments?['fromPage'] as FromPage? ?? FromPage.view;

    if (fromPage == FromPage.view) {
      return lessonPlan.value?.data != null &&
          (lessonPlan.value?.data?.sections?.isNotEmpty ?? false);
    }

    final genController = Get.find<LessonPlanGenerationDetailsController>();
    return genController.generatedLessonResponse.value?.data?.first != null &&
        (genController
                .generatedLessonResponse
                .value
                ?.data
                ?.first
                ?.sections
                ?.isNotEmpty ??
            false);
  }

  /// The main lesson plan data fetched from the server.
  final Rx<ViewLessonPlanModel?> lessonPlan = Rx<ViewLessonPlanModel?>(null);

  /// Stores the regeneration limit details for a user.
  final Rx<RegenerateLimitResponseModel?> regenerateLimitResponse =
      Rx<RegenerateLimitResponseModel?>(null);

  /// The current lesson ID associated with this view.
  String? lessonId;

  // ---------------------------------------------------------------------------
  // FEEDBACK CONTROLLERS (PHASE-WISE)
  // ---------------------------------------------------------------------------

  /// Feedback for Engage phase.
  final engageFeedbackController = TextEditingController();

  /// Feedback for Explore phase.
  final exploreFeedbackController = TextEditingController();

  /// Feedback for Explain phase.
  final explainFeedbackController = TextEditingController();

  /// Feedback for Elaborate phase.
  final elaborateFeedbackController = TextEditingController();

  /// Feedback for Evaluate phase.
  final evaluateFeedbackController = TextEditingController();

  /// Overall feedback comment controller.
  final feedbackCommentController = TextEditingController();

  /// Selected feedback type value (radio selection).
  final feedbackRadioValue = ''.obs;

  /// Additional feedback text input (if required).
  final feedbackTextController = TextEditingController();

  final RxBool isLearningOutcomeExpanded = false.obs;

  /// Toggle Learning Outcomes section expansion
  void toggleLearningOutcomeExpanded() {
    isLearningOutcomeExpanded.value = !isLearningOutcomeExpanded.value;
  }

  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------

  /// Cleans up all text controllers when the controller is closed.
  @override
  void onClose() {
    engageFeedbackController.dispose();
    exploreFeedbackController.dispose();
    explainFeedbackController.dispose();
    elaborateFeedbackController.dispose();
    evaluateFeedbackController.dispose();
    super.onClose();
  }

  /// Initialization:
  /// - Retrieves `lessonId` from navigation arguments.
  /// - Loads lesson plan.
  /// - Checks regenerate limit.
  @override
  Future<void> onInit() async {
    lessonId = Get.arguments?['lessonId'] as String?;
    logD('section lessonId $lessonId');

    await getLessonPlanById();
    await checkRegenerateLimit();
    ever(isSectionEdit, (List<bool> sections) {
      if (sections.any((element) => element == true)) {
        canPop.value = false;
      }
    });
    // scrollController = ScrollController();
    super.onInit();
  }

  /// Called when the UI is fully ready (unused but kept for clarity).
  @override
  void onReady() {
    super.onReady();
  }

  // ---------------------------------------------------------------------------
  // FETCHING & PREPARATION
  // ---------------------------------------------------------------------------

  /// Fetches the user's regeneration limit from the API.
  ///
  /// Updates [regenerateLimitResponse] if data is received.
  Future<void> checkRegenerateLimit() async {
    final RegenerateLimitResponseModel? result = await _lessonPlanViewRepository
        .getRegenerationLimit();
    if (result != null) {
      regenerateLimitResponse.value = result;
    }
  }

  /// Loads the lesson plan details for the current [lessonId].
  ///
  /// - Sets loading state
  /// - Processes existing feedback
  /// - Prepares learning outcomes
  Future<void> getLessonPlanById() async {
    if (lessonId == null) {
      return;
    }

    isLoadingLessonPlan(true);
    Loader.show();

    final ViewLessonPlanModel? result = await _lessonPlanViewRepository
        .getLessonPlansViewDetails(lessonId: lessonId!);

    if (result != null) {
      lessonPlan.value = result;

      // Load feedback if available
      if (result.data.feedback != null) {
        feedbackRadioValue.value = result.data.feedback!.feedback;

        if (result.data.feedback!.overallFeedbackReason != null) {
          feedbackCommentController.text =
              result.data.feedback!.overallFeedbackReason!;
        }
      }

      _prepareLearningOutcomes();
    }

    isLoadingLessonPlan(false);
    Loader.dismiss();
  }

  // ---------------------------------------------------------------------------
  // LEARNING OUTCOMES
  // ---------------------------------------------------------------------------

  /// Maintains the list of learning outcomes in the UI.
  var learningOutcomes = <String>[].obs;

  /// Adds a new learning outcome to the list.
  void addLearningOutcome(String outcome) {
    learningOutcomes.add(outcome);
  }

  /// Removes an existing learning outcome.
  void removeLearningOutcome(String outcome) {
    learningOutcomes.remove(outcome);
  }

  /// Prepares learning outcomes from loaded lesson plan.
  void _prepareLearningOutcomes() {
    if (lessonPlan.value?.data.learningOutcomes != null) {
      learningOutcomes.assignAll(lessonPlan.value!.data.learningOutcomes);
    }
  }

  // ---------------------------------------------------------------------------
  // UI STATE CONTROLS
  // ---------------------------------------------------------------------------

  /// Controls expansion state of chapter details in UI.
  var isChapterDetailsExpanded = false.obs;

  /// Toggles chapter details expansion/collapse.
  void toggleChapterDetailsExpanded() {
    isChapterDetailsExpanded.value = !isChapterDetailsExpanded.value;
  }

  // ---------------------------------------------------------------------------
  // SAVE LESSON PLAN
  // ---------------------------------------------------------------------------

  /// Saves the current lesson plan.
  ///
  /// Depending on `fromPage`, collects data either from:
  /// - The viewed lesson plan
  /// - A newly generated lesson plan
  ///
  /// After saving:
  /// - Sends overall feedback
  /// - Refreshes the content generation screen if available
  /// - Navigates back
  Future<void> saveLessonPlan() async {
    Loader.show();
    final fromPage = Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    List<String> outcomes = [];
    bool isCompleted = true;
    String? lessonId;
    bool isVideoSelected = false;
    List<Map<String, dynamic>> sections = [];

    if (fromPage == FromPage.view) {
      final data = lessonPlan.value?.data;
      outcomes = data?.learningOutcomes ?? [];
      isCompleted = data?.isCompleted ?? false;
      lessonId = data?.lessonId;
      isVideoSelected = data?.isVideoSelected ?? false;

      sections =
          data?.sections
              .map(
                (section) => {
                  'id': section.id,
                  'title': section.title,
                  'content': section.content,
                  'outputFormat': section.outputFormat,
                  'media':
                      section
                          .media // Add missing media array field
                          ?.map(
                            (mediaItem) => {
                              'title': mediaItem.title ?? '',
                              'type': mediaItem.type,
                              'link': mediaItem.link,
                              'uploadedAt': mediaItem.uploadedAt
                                  ?.toIso8601String(),
                            },
                          )
                          .toList() ??
                      [],
                },
              )
              .toList()
              .cast<Map<String, dynamic>>() ??
          [];
    } else if (fromPage == FromPage.generate) {
      final generationDetailsController =
          Get.find<LessonPlanGenerationDetailsController>();
      final generated =
          generationDetailsController.generatedLessonResponse.value?.data.first;

      outcomes = generated?.learningOutcomes ?? [];
      isCompleted = true;
      lessonId = generated?.id;
      isVideoSelected = false;

      sections =
          generated?.sections
              .map(
                (section) => {
                  'id': section.id,
                  'title': section.title,
                  'content': section.content,
                  'outputFormat': section.outputFormat,
                  'media':
                      section
                          .media // Add missing media array field if exists
                          ?.map(
                            (mediaItem) => {
                              'title': mediaItem.title ?? '',
                              'type': mediaItem.type,
                              'link': mediaItem.link,
                              'uploadedAt': mediaItem.uploadedAt
                                  ?.toIso8601String(),
                            },
                          )
                          .toList() ??
                      [],
                },
              )
              .toList()
              .cast<Map<String, dynamic>>() ??
          [];
    }

    final SaveLessonPlanModel? result = await _lessonPlanViewRepository
        .saveLessonPlan(
          isCompleted: isCompleted,
          lessonId: lessonId ?? '',
          learningOutcomes: outcomes,
          isVideoSelected: isVideoSelected,
          sections: sections,
        );

    if (result != null) {
      canPop.value = true;
      final String overallFeedbackReason = feedbackCommentController.text;
      final String feedback = feedbackRadioValue.value;
      final bool completed = isCompleted;
      final String id = lessonId ?? '';

      final CreateLessonFeedbackModel? feedbackResult =
          await _lessonPlanViewRepository.createLessonFeedback(
            lessonId: lessonId ?? '',
            isCompleted: isCompleted,
            feedback: feedback,
            overallFeedbackReason: overallFeedbackReason,
          );

      try {
        final contentGenController = Get.find<ContentGenerationController>();
        await contentGenController.refreshContentGenerationScreen();
      } catch (_) {}

      Get.back();
      Get.back();
    }
    Loader.dismiss();
  }

  // ---------------------------------------------------------------------------
  // DOCUMENT GENERATION
  // ---------------------------------------------------------------------------

  /// Generates a DOCX file for the current lesson plan using the provided template.
  Future<void> generateLessonPlanDocx({bool saveToDevice = false}) async {
    try {
      Loader.show();
      final data = lessonPlan.value?.data;

      List<Map<String, dynamic>> sections =
          data?.sections
              .map(
                (section) => {
                  'id': section.id,
                  'title': section.title,
                  'content': section.content,
                  'outputFormat': section.outputFormat,
                },
              )
              .toList()
              .cast<Map<String, dynamic>>() ??
          [];

      if (data == null) {
        return;
      }

      // await PdfGenerator.generateLessonPlanPdf(
      //   UserProvider.currentUser,
      //   lessonPlan.value,
      //   saveToDevice: saveToDevice,
      // );

      await DocxGenerator.generateLessonPlanDocx(
        UserProvider.currentUser,
        lessonPlan.value,
        saveToDevice: saveToDevice,
      );
    } finally {
      Loader.dismiss();
    }
  }

  /// Whether to show 5E table (KSEEB only).
  bool get show5ETableFeature {
    final fromPage = Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    if (fromPage == FromPage.view) {
      // VIEW mode: Check loaded lessonPlan board
      return lessonPlan.value?.data?.lesson?.chapter?.board?.toLowerCase() ==
          'kseeb';
    } else {
      // GENERATE mode: Get from generation controller
      final genController = Get.find<LessonPlanGenerationDetailsController>();
      return genController?.generatedLessonResponse?.value?.data?.first.board
              ?.toLowerCase() ==
          'kseeb';
    }
  }

  Future<void> generate5ETableDocx({bool saveToDevice = false}) async {
    try {
      Loader.show();
      final data = lessonPlan.value;
      Map<String, dynamic>? checklist;
      final section = lessonPlan.value?.data?.sections?.firstWhereOrNull(
        (s) => s.id == 'section_checklist',
      );
      checklist =
          section?.content
              as Map<String, dynamic>?; // your ViewLessonPlanModel.data
      if (data == null) {
        return;
      }

      // PdfGenerator.generate5ETable(
      //   checklist,
      //   UserProvider.currentUser, // user (for teacher/school/etc.)
      //   data, // lesson plan data (for board, medium, etc.)
      //   saveToDevice: saveToDevice,
      // );

      DocxGenerator.generate5ETableDocx(
        checklist,
        UserProvider.currentUser, // user (for teacher/school/etc.)
        data, // lesson plan data (for board, medium, etc.)
        saveToDevice: saveToDevice,
      );
    } finally {
      Loader.dismiss();
    }
  }

  /// Placeholder for generating 5E table PDF output.
  Future<void> generate5ETablePdf({bool saveToDevice = false}) async {
    try {
      Loader.show();
      final data = lessonPlan.value;
      Map<String, dynamic>? checklist;
      final section = lessonPlan.value?.data?.sections?.firstWhereOrNull(
        (s) => s.id == 'section_checklist',
      );
      checklist =
          section?.content
              as Map<String, dynamic>?; // your ViewLessonPlanModel.data
      if (data == null) {
        return;
      }

      await PdfGenerator.generate5ETable(
        checklist,
        UserProvider.currentUser, // user (for teacher/school/etc.)
        data, // lesson plan data (for board, medium, etc.)
        saveToDevice: saveToDevice,
      );
    } finally {
      Loader.dismiss();
    }
  }

  // ---------------------------------------------------------------------------
  // LESSON PLAN REGENERATION
  // ---------------------------------------------------------------------------

  /// Collects regeneration feedback from dialog and triggers lesson plan regeneration.
  Future<void> regenerateLessonPlanFromDialog() async {
    final regenFeedback = [
      {'phase': 'Engage', 'feedback': engageFeedbackController.text.trim()},
      {'phase': 'Explore', 'feedback': exploreFeedbackController.text.trim()},
      {'phase': 'Explain', 'feedback': explainFeedbackController.text.trim()},
      {
        'phase': 'Elaborate',
        'feedback': elaborateFeedbackController.text.trim(),
      },
      {'phase': 'Evaluate', 'feedback': evaluateFeedbackController.text.trim()},
    ].where((item) => item['feedback']!.isNotEmpty).toList();

    final generationDetailsController =
        Get.find<LessonPlanGenerationDetailsController>();
    final data =
        generationDetailsController.generatedLessonResponse.value?.data?.first;

    final String chapterId = data?.chapter?.id ?? '';
    final String lessonId = data?.id ?? '';
    final List<String> subTopics = data?.subTopics?.cast<String>() ?? [];

    await regenerateLessonPlan(
      chapterId: chapterId,
      lessonId: lessonId,
      isAll: false,
      subTopics: subTopics,
      regenFeedback: regenFeedback.cast<Map<String, String>>(),
      feedback: feedbackRadioValue.string,
      feedbackPerSets: [],
    );
  }

  /// Regenerates a lesson plan with the given parameters.
  ///
  /// - [chapterId]: ID of the chapter
  /// - [lessonId]: ID of the lesson
  /// - [isAll]: Whether to regenerate entire lesson or only selected parts
  /// - [subTopics]: List of subtopics involved
  /// - [regenFeedback]: List of feedback objects by 5E phases
  /// - [feedback]: Overall feedback
  /// - [feedbackPerSets]: Additional feedback data (optional)
  Future<void> regenerateLessonPlan({
    required String chapterId,
    required String lessonId,
    required bool isAll,
    required List<String> subTopics,
    required List<Map<String, String>> regenFeedback,
    required String feedback,
    List<dynamic>? feedbackPerSets,
  }) async {
    isLoadingLessonPlan(true);
    Loader.show();

    final RegenerateResponseModel? result = await _lessonPlanViewRepository
        .regenerateLessonPlan(
          chapterId: chapterId,
          lessonId: lessonId,
          isAll: isAll,
          subTopics: subTopics,
          regenFeedback: regenFeedback,
          feedback: feedback,
          feedbackPerSets: feedbackPerSets,
        );

    if (result != null) {
      if (Get.isRegistered<GenerationStatusController>()) {
        Get.until((route) => Get.currentRoute == Routes.GENERATION_STATUS);
      } else {
        Get.offNamedUntil(
          Routes.GENERATION_STATUS,
          (Route<dynamic> route) => false,
        );
      }
    }
    Loader.dismiss();
    isLoadingLessonPlan(false);
  }

  // ---------------------------------------------------------------------------
  // MEDIA MANAGEMENT
  // ---------------------------------------------------------------------------

  /// Adds a media item (video, link, document, etc.) to a lesson section.
  ///
  /// - [sectionId]: ID of the section to attach media to
  /// - [title]: Title/label of the media item
  /// - [type]: Type of media (e.g., "video", "pdf")
  /// - [link]: The resource URL
  Future<void> addMedia({
    required String sectionId,
    required String title,
    required String type,
    required String link,
  }) async {
    Loader.show();
    if (lessonId == null) {
      debugPrint('Lesson ID is null, cannot add media');
      return;
    }

    bool success = await _lessonPlanViewRepository.addMediaToLesson(
      lessonId: lessonId!,
      sectionId: sectionId,
      title: title,
      type: type,
      link: link,
    );

    if (success) {
      debugPrint('Media uploaded successfully');
      await getLessonPlanById();
    } else {
      debugPrint('Failed to upload media');
    }
    Loader.dismiss();
  }

  /// Deletes a media item from a lesson section.
  ///
  /// - [sectionId]: ID of the section the media belongs to
  /// - [mediaId]: ID of the media to delete
  Future<void> deleteMedia({
    required String sectionId,
    required String mediaId,
  }) async {
    if (lessonId == null) {
      debugPrint('Lesson ID is null, cannot delete media');
      return;
    }
    Loader.show();

    final success = await _lessonPlanViewRepository.deleteMediaFromLesson(
      lessonId: lessonId!,
      sectionId: sectionId,
      mediaId: mediaId,
    );

    if (success) {
      debugPrint('Media deleted successfully');
      await getLessonPlanById();
    } else {
      debugPrint('Failed to delete media');
    }
    Loader.dismiss();
  }
}
