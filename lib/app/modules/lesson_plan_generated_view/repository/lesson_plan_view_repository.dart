import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/create_lesson_feedback_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/regenerate_limit_response_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/regenerate_response_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/save_lesson_plan_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/view_lesson_plan_model.dart';

/// A repository responsible for handling all network operations related to
/// viewing, saving, regenerating, and updating lesson plans.
///
/// This class interfaces with the backend APIs using the shared [APIService].
/// All methods return parsed models on success or `null`/`false` on failure.
class LessonPlanViewRepository {
  /// Fetches detailed data for a teacher’s lesson plan using its [lessonId].
  ///
  /// - Sends a GET request to the endpoint:
  ///   `/getTeacherLessonPlanByLessonId/:lessonId`
  /// - Returns a fully parsed [ViewLessonPlanModel] on success.
  ///
  /// Returns:
  /// - [ViewLessonPlanModel]? → The parsed lesson plan
  /// - `null` → If request fails or server returns invalid response
  Future<ViewLessonPlanModel?> getLessonPlansViewDetails({
    required String lessonId,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.getTeacherLessonPlanByLessonId}/$lessonId',
        params: <String, dynamic>{},
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return ViewLessonPlanModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Saves or updates a teacher's lesson plan.
  ///
  /// Required fields:
  /// - [lessonId] → ID of the lesson
  /// - [isCompleted] → Whether the lesson plan is marked completed
  /// - [learningOutcomes] → List of outcomes
  /// - [isVideoSelected] → Whether videos were included
  /// - [sections] → List of maps containing section details
  ///
  /// Optional:
  /// - [includeVideos] → If true, sends additional flag to API
  ///
  /// Returns:
  /// - Parsed [SaveLessonPlanModel] on success
  /// - `null` if an error occurs
  Future<SaveLessonPlanModel?> saveLessonPlan({
    required String lessonId,
    required bool isCompleted,
    required List<String> learningOutcomes,
    required bool isVideoSelected,
    required List<Map<String, dynamic>> sections,
    bool includeVideos = false,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'isCompleted': isCompleted,
        'lessonId': lessonId,
        'learningOutcomes': learningOutcomes,
        'isVideoSelected': isVideoSelected,
        'sections': sections,
        if (includeVideos) 'includeVideos': includeVideos,
      };

      final Response<dynamic>? response = await APIService.post(
        path: '${ApiConstants.saveTeacherLessonPlan}',
        data: requestData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return SaveLessonPlanModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error saving lesson plan: $e');
    }
    return null;
  }

  /// Adds media (image/video/document link) to a specific lesson section.
  ///
  /// Required:
  /// - [lessonId] → The lesson containing the section
  /// - [sectionId] → ID of the section to attach media to
  /// - [title] → Media title
  /// - [type] → Media type (“video”, “image”, “pdf”, etc.)
  /// - [link] → URL link to media
  ///
  /// Returns:
  /// - `true` → If media added successfully
  /// - `false` → If request fails
  Future<bool> addMediaToLesson({
    required String lessonId,
    required String sectionId,
    required String title,
    required String type,
    required String link,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'sectionId': sectionId,
        'title': title,
        'type': type,
        'link': link,
      };

      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.addMediaUrl(lessonId),
        data: requestData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        final bool success = response!.data['success'] ?? false;
        return success;
      }
    } catch (e) {
      debugPrint('Error uploading media to lesson: $e');
    }
    return false;
  }

  /// Deletes a media item from a specific lesson section.
  ///
  /// Required:
  /// - [lessonId] → ID of the lesson
  /// - [sectionId] → ID of the section from which media is deleted
  /// - [mediaId] → The media ID
  ///
  /// Returns:
  /// - `true` when deletion is successful
  /// - `false` otherwise
  Future<bool> deleteMediaFromLesson({
    required String lessonId,
    required String sectionId,
    required String mediaId,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'sectionId': sectionId,
        'mediaId': mediaId,
      };

      final Response<dynamic>? response = await APIService.delete(
        path: ApiConstants.deleteMediaUrl(lessonId),
        data: requestData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        final bool success = response!.data['success'] ?? false;
        return success;
      }
    } catch (e) {
      debugPrint('Error deleting media from lesson: $e');
    }
    return false;
  }

  /// Submits overall feedback for a lesson plan.
  ///
  /// Required:
  /// - [lessonId] → ID of lesson plan
  /// - [isCompleted] → Whether lesson plan is marked as completed
  /// - [feedback] → Feedback text written by user
  ///
  /// The API expects:
  /// - `feedbackPerSets` → Always an empty list
  ///
  /// Returns:
  /// - A parsed [CreateLessonFeedbackModel] on success
  /// - `null` otherwise
  Future<CreateLessonFeedbackModel?> createLessonFeedback({
    required String lessonId,
    required bool isCompleted,
    required String feedback,
    required String overallFeedbackReason,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'isCompleted': isCompleted,
        'lessonId': lessonId,
        'feedbackPerSets': <dynamic>[],
        'feedback': feedback,
        if (overallFeedbackReason.isNotEmpty)
          'overallFeedbackReason': overallFeedbackReason,
      };

      // 🔹 FEEDBACK - Request Log
      debugPrint('[FEEDBACK] API: ${ApiConstants.createLessonFeedback}');
      debugPrint('[FEEDBACK] Request: $requestData');

      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.createLessonFeedback,
        data: requestData,
      );

      // 🔹 FEEDBACK - Response Log
      debugPrint('[FEEDBACK] StatusCode: ${response?.statusCode}');
      debugPrint('[FEEDBACK] Response: ${response?.data}');

      if (response?.statusCode == 200 && response?.data != null) {
        return CreateLessonFeedbackModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[FEEDBACK] ❌ Error: $e');
      debugPrint('[FEEDBACK] StackTrace: $stackTrace');
    }

    return null;
  }

  /// Triggers AI regeneration of a lesson plan based on:
  /// - [chapterId]
  /// - [lessonId]
  /// - [isAll] → Whether all subtopics should be regenerated
  /// - [subTopics] → Topics to regenerate
  /// - [regenFeedback] → Phase-wise feedback (Engage, Explore, etc.)
  /// - [feedback] → Overall feedback value
  /// - [feedbackPerSets] → Optional additional structured feedback
  ///
  /// Returns:
  /// - [RegenerateResponseModel] on success
  /// - `null` on failure
  Future<RegenerateResponseModel?> regenerateLessonPlan({
    required String chapterId,
    required String lessonId,
    required bool isAll,
    required List<String> subTopics,
    required List<Map<String, String>> regenFeedback,
    required String feedback,
    List<dynamic>? feedbackPerSets,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'chapterId': chapterId,
        'lessonId': lessonId,
        'isAll': isAll,
        'subTopics': subTopics,
        'feedbackPerSets': feedbackPerSets ?? <dynamic>[],
        'feedback': feedback,
        'regenFeedback': regenFeedback,
      };

      final Response<dynamic>? response = await APIService.post(
        path: '${ApiConstants.regenerate}',
        data: requestData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return RegenerateResponseModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error regenerating lesson plan: $e');
    }
    return null;
  }

  /// Checks whether the user has reached the regeneration limit.
  ///
  /// Calls:
  /// - `/regeneration-limit`
  ///
  /// Returns:
  /// - [RegenerateLimitResponseModel] on success
  /// - `null` on error
  Future<RegenerateLimitResponseModel?> getRegenerationLimit() async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.regenerationLimit}',
        params: <String, dynamic>{},
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return RegenerateLimitResponseModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }
}
