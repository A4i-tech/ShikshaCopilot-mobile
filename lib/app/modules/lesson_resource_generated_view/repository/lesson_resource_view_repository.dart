import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/regenerate_response_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/models/create_resourc%20e_feedback_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/models/save_resource_plan_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/models/view_resource_plan_model.dart';

/// A repository for handling lesson resource view related API calls.
class LessonResourceViewRepository {
  /// Fetches the lesson plan view details for a given resource ID.
  ///
  /// Returns a [ViewResourcePlanModel] on success, or `null` on failure.
  Future<ViewResourcePlanModel?> getLessonPlansViewDetails({
    required String resourceId,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.getTeacherResourcePlanByResourceId}/$resourceId',
        params: <String, dynamic>{},
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return ViewResourcePlanModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Saves a lesson resource.
  ///
  /// Returns a [SaveResourcePlanModel] on success, or `null` on failure.
  Future<SaveResourcePlanModel?> saveLessonResource({
    required bool isCompleted,
    required String resourceId,
    required List<Map<String, dynamic>> resources,
    List<dynamic>? additionalResources,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'isCompleted': isCompleted,
        'resourceId': resourceId,
        'resources': resources,
        'additionalResources': additionalResources ?? <dynamic>[],
      };

      final Response<dynamic>? response = await APIService.post(
        path: '${ApiConstants.saveTeacherLessonPlan}',
        data: requestData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return SaveResourcePlanModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error saving lesson resource: $e');
      return null;
    }
    return null;
  }

  /// Creates feedback for a resource.
  ///
  /// Returns a [CreateResourceFeedbackModel] on success, or `null` on failure.
  Future<CreateResourceFeedbackModel?> createResourceFeedback({
    required String resourceId,
    required bool isCompleted,
    required String feedback,
    required String overallFeedbackReason,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'isCompleted': isCompleted,
        'resourceId': resourceId,
        'feedbackPerSets':
            <dynamic, dynamic>{}, // pass empty list as per your JSON
        'feedback': feedback,
        if (overallFeedbackReason.isNotEmpty)
          'overallFeedbackReason': overallFeedbackReason,
      };

      final Response<dynamic>? response = await APIService.post(
        path: '${ApiConstants.createResourceFeedback}',
        data: requestData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return CreateResourceFeedbackModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error creating lesson feedback: $e');
    }
    return null;
  }

  /// Regenerates a lesson plan.
  ///
  /// Returns a [RegenerateResponseModel] on success, or `null` on failure.
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
        path:
            '${ApiConstants.regenerate}', // map this in your ApiConstants: '/teacher-lesson-plan/regenerate'
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

  /// Adds media to a resource plan activity.
  ///
  /// Returns `true` on success, or `false` on failure.
  Future<bool> addMediaToResourceActivity({
    required String resourcePlanId,
    required String resourceId,
    required String itemId,
    required String title,
    required String type,
    required String link,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'resourceId': resourceId,
        'itemId': itemId,
        'title': title,
        'type': type,
        'link': link,
      };

      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.addResourceActivityMediaUrl(resourcePlanId),
        data: requestData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        final bool success = response!.data['success'] ?? false;
        if (success) {
          debugPrint('Resource activity media uploaded successfully');
        } else {
          debugPrint(
            'Failed to upload resource activity media: ${response.data['message']}',
          );
        }
        return success;
      }
    } catch (e) {
      debugPrint('Error uploading resource activity media: $e');
    }
    return false;
  }

  /// Deletes media from a resource plan activity.
  ///
  /// Returns `true` on success, or `false` on failure.
  Future<bool> deleteMediaFromResourceActivity({
    required String resourcePlanId,
    required String resourceId,
    required String itemId,
    required String mediaId,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'resourceId': resourceId,
        'itemId': itemId,
        'mediaId': mediaId,
      };

      final Response<dynamic>? response = await APIService.delete(
        path: ApiConstants.deleteResourceActivityMediaUrl(resourcePlanId),
        data: requestData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        final bool success = response!.data['success'] ?? false;
        if (success) {
          debugPrint('Media deleted from resource activity successfully');
        } else {
          debugPrint('Failed to delete media: ${response.data['message']}');
        }
        return success;
      }
    } catch (e) {
      debugPrint('Error deleting media from resource activity: $e');
    }
    return false;
  }

  /// Adds a rating for an activity.
  ///
  /// Returns `true` on success, or `false` on failure.
  Future<bool> addRatingForActivity({
    required String resourcePlanId,
    required String resourceId,
    required String activityId,
    required bool performed,
    String? engagement,
    String? alignment,
    String? application,
    int? stars,
    String? notPerformedReason,
  }) async {
    try {
      final Map<String, dynamic> requestData = <String, dynamic>{
        'resourceId': resourceId,
        'activityId': activityId,
        'performed': performed,
      };

      if (performed) {
        if (engagement != null) requestData['engagement'] = engagement;
        if (alignment != null) requestData['alignment'] = alignment;
        if (application != null) requestData['application'] = application;
        if (stars != null) requestData['stars'] = stars;
      } else {
        if (notPerformedReason != null) {
          requestData['notPerformedReason'] = notPerformedReason;
        }
      }

      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.addRatingForActivity(resourcePlanId),
        data: requestData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        final bool success = response!.data['success'] ?? false;
        if (success) {
          debugPrint('Activity rated successfully');
        } else {
          debugPrint('Failed to rate activity: ${response.data['message']}');
        }
        return success;
      }
    } catch (e) {
      debugPrint('Error rating activity: $e');
    }
    return false;
  }
}