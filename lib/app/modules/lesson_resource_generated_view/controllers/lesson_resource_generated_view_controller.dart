import 'package:sikshana/app/modules/lesson_resource_generated_view/models/create_resourc%20e_feedback_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/models/save_resource_plan_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/models/view_resource_plan_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/repository/lesson_resource_view_repository.dart';
import 'package:sikshana/app/modules/view_question_paper/views/widgets/docx_generator.dart';
import 'package:sikshana/app/modules/view_question_paper/views/widgets/pdf_generator.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Controller for the lesson resource generated view.
///
/// This controller manages the state and business logic for displaying,
/// editing, and providing feedback on a generated lesson resource.
class LessonResourceGeneratedViewController extends GetxController {
  /// The ID of the lesson resource.
  String? lessonId; // Declare variable for lessonId
  ScrollController scrollController = ScrollController();
  @override
  Future<void> onInit() async {
    // Get arguments on initialization
    lessonId = Get.arguments?['lessonId'] as String?;
    logD('section lessonId $lessonId');
    await getLessonPlanById();

    everAll([isQuestionBankEdit, isRealWorldEdit, isActivitiesEdit], (_) {
      if (isQuestionBankEdit.isTrue ||
          isRealWorldEdit.isTrue ||
          isActivitiesEdit.isTrue) {
        canPop.value = false;
      }
    });

    super.onInit();
  }

  void toggleResourceFeedbackSection() {
    showResourceFeedbackSection.value = !showResourceFeedbackSection.value;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final double targetOffset = showResourceFeedbackSection.value
          ? scrollController
                .position
                .maxScrollExtent // show → scroll down
          : scrollController.position.minScrollExtent; // hide → scroll up (0.0)

      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  final RxBool showResourceFeedbackSection = false.obs;

  final RxBool showChapterDetailsTooltip = false.obs;

  /// Indicates whether the question bank is in edit mode.
  final isQuestionBankEdit = false.obs;

  /// Indicates whether the real-world scenarios are in edit mode.
  final isRealWorldEdit = false.obs;

  /// Indicates whether the activities are in edit mode.
  final isActivitiesEdit = false.obs;

  ///boolean value to check if screen can pop with unsaved data
  final RxBool canPop = true.obs;

  LessonResourceViewRepository _lessonResourceViewRepository =
      LessonResourceViewRepository();

  /// Saves the current state of the lesson resource plan.
  ///
  /// This includes the resource content and any feedback provided.
  Future<void> saveResourcePlan() async {
    final fromPage = Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    Loader.show();

    String? resourceId;
    bool isVideoSelected = false;
    List<Map<String, dynamic>> resources = [];
    bool isCompleted = false;

    if (fromPage == FromPage.view) {
      final data = lessonResource.value?.data;
      isCompleted = data?.isCompleted ?? false;

      resourceId = data?.resourceId;
      isVideoSelected = data?.isVideoSelected ?? false;
      // Convert Section objects to Map
      resources =
          data?.resources
              .map(
                (resource) => {
                  "id": resource.id,
                  "title": resource.title,
                  "content": resource.content,
                  "outputFormat": resource.outputFormat,
                },
              )
              .toList()
              .cast<Map<String, dynamic>>() ??
          [];
    } else if (fromPage == FromPage.generate) {
      final generationDetailsController =
          Get.find<LessonResourceGenerationDetailsController>();
      final generated = generationDetailsController
          .generatedResourceResponse
          .value
          ?.data
          .first;

      isCompleted = true;

      resourceId = generated?.id; // Or generated?.lessonId if that's the key
      isVideoSelected = false; // Or generated?.isVideoSelected if exists

      // Convert Section objects to Map
      resources =
          generated?.resources
              .map(
                (resource) => {
                  "id": resource.id,
                  "title": resource.title,
                  "content": resource.content,
                  "outputFormat": resource.outputFormat,
                },
              )
              .toList()
              .cast<Map<String, dynamic>>() ??
          [];
    }

    final SaveResourcePlanModel? result = await _lessonResourceViewRepository
        .saveLessonResource(
          isCompleted: isCompleted,
          resourceId: resourceId ?? '',
          resources: resources,
          additionalResources: null,
        );

    if (result != null) {
      canPop.value = true;
      final String overallFeedbackReason = feedbackCommentController.text;
      final String feedback = feedbackRadioValue.value;
      final bool completed = isCompleted;
      final String id = resourceId ?? '';

      final CreateResourceFeedbackModel? feedbackResult =
          await _lessonResourceViewRepository.createResourceFeedback(
            resourceId: id,
            isCompleted: completed,
            feedback: feedback,
            overallFeedbackReason: overallFeedbackReason,
          );
      try {
        final contentGenController = Get.find<ContentGenerationController>();
        await contentGenController.refreshContentGenerationScreen();
      } catch (e) {
        logD('ContentGenerationController not found, skipping refresh: $e');
      }

      Get.back();
      Get.back();
    }
    Loader.dismiss();

    // Handle result as required
  }

  /// The currently selected feedback radio button value.
  final feedbackRadioValue = "".obs;

  /// The text controller for the feedback comment field.
  final feedbackCommentController = TextEditingController();

  /// Indicates whether the chapter details section is expanded.
  var isChapterDetailsExpanded = false.obs;

  /// Regenerates the lesson plan.
  ///
  /// This method is not yet implemented.
  void regenerateLessonPlan() {
    // TODO: Implement regenerate logic
  }

  /// Toggles the expanded state of the chapter details section.
  void toggleChapterDetailsExpanded() {
    isChapterDetailsExpanded.value = !isChapterDetailsExpanded.value;
  }

  /// Indicates whether the lesson plan is currently being loaded.
  final RxBool isLoadingLessonPlan = false.obs;

  /// The currently loaded lesson resource plan.
  final Rx<ViewResourcePlanModel?> lessonResource = Rx<ViewResourcePlanModel?>(
    null,
  );

  /// Fetches the lesson plan details by its ID.
  Future<void> getLessonPlanById() async {
    if (lessonId == null) {
      return;
    }
    Loader.show();
    isLoadingLessonPlan(true);
    final ViewResourcePlanModel? result = await _lessonResourceViewRepository
        .getLessonPlansViewDetails(resourceId: lessonId!);
    if (result != null) {
      lessonResource.value = result;

      if (result.data.feedback != null) {
        feedbackRadioValue.value = result.data.feedback!.feedback;
        if (result.data.feedback!.overallFeedbackReason != null) {
          feedbackCommentController.text =
              result.data.feedback!.overallFeedbackReason!;
        }
      } else {}
    }
    isLoadingLessonPlan(false);
    Loader.dismiss();
  }

  /// Saves the edited question bank data.
  Future<void> saveQuestionBankEdits() async {
    final resource = lessonResource.value;
  }

  /// Adds a media link to a resource activity.
  ///
  /// The [resourceId], [itemId], [title], [type], and [link] are required.
  Future<void> addMediaToResourceActivity({
    required String resourceId,
    required String itemId,
    required String title,
    required String type,
    required String link,
  }) async {
    Loader.show();
    logD('addMediaToResourceActivity lessonId $lessonId');
    if (lessonId == null) {
      Loader.dismiss();
      return;
    }
    logD('addMediaToResourceActivity lessonId notnull $lessonId');
    isLoadingLessonPlan(true);

    final bool success = await _lessonResourceViewRepository
        .addMediaToResourceActivity(
          resourcePlanId: lessonId!,
          resourceId: resourceId,
          itemId: itemId,
          title: title,
          type: type,
          link: link,
        );

    isLoadingLessonPlan(false);

    if (success) {
      debugPrint('Resource activity media uploaded successfully');
      await getLessonPlanById(); // Optionally refresh the plan
    } else {
      debugPrint('Failed to upload resource activity media');
    }
    Loader.dismiss();
  }

  /// Deletes a media item from a resource activity.
  ///
  /// The [resourceId], [itemId], and [mediaId] are required.
  Future<void> deleteMediaFromResourceActivity({
    required String resourceId,
    required String itemId,
    required String mediaId,
  }) async {
    isLoadingLessonPlan(true);
    Loader.show();

    final bool success = await _lessonResourceViewRepository
        .deleteMediaFromResourceActivity(
          resourcePlanId: lessonId!,
          resourceId: resourceId,
          itemId: itemId,
          mediaId: mediaId,
        );

    isLoadingLessonPlan(false);
    Loader.dismiss();
    if (success) {
      await getLessonPlanById();
    } else {
      debugPrint('Failed to delete resource activity media');
    }
  }

  /// Adds a rating for a resource activity.
  ///
  /// The [resourceId] and [activityId] are required.
  Future<void> addRatingForActivity({
    required String resourceId,
    required String activityId,
    required bool performed,
    String? engagement,
    String? alignment,
    String? application,
    int? stars,
    String? notPerformedReason,
  }) async {
    if (lessonId == null) {
      return;
    }
    isLoadingLessonPlan(true);
    Loader.show();

    final bool success = await _lessonResourceViewRepository
        .addRatingForActivity(
          resourcePlanId: lessonId!,
          resourceId: resourceId,
          activityId: activityId,
          performed: performed,
          engagement: engagement,
          alignment: alignment,
          application: application,
          stars: stars,
          notPerformedReason: notPerformedReason,
        );

    isLoadingLessonPlan(false);
    Loader.dismiss();

    if (success) {
      debugPrint('Activity rated successfully');

      await getLessonPlanById(); // Refresh the lesson plan view
    } else {
      debugPrint('Failed to rate activity');
    }
    Get.back();
  }

  Future<void> generateLessonResourcePdf({bool saveToDevice = false}) async {
    try {
      Loader.show();
      final data = lessonResource.value;

      if (data == null) {
        appSnackBar(
          message: 'Error: No data available to generate Resource PDF.',
          state: SnackBarState.danger,
        );
        return;
      }

      // await PdfGenerator.generateLessonResourcePdf(
      //   UserProvider.currentUser,
      //   data,
      //   saveToDevice: saveToDevice,
      // );

      await DocxGenerator.generateLessonResourceDocx(
        UserProvider.currentUser,
        data,
        saveToDevice: saveToDevice,
      );
    } finally {
      Loader.dismiss();
    }
  }
}
