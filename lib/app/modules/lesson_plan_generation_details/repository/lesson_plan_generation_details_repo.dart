// ignore_for_file: unused_import

import 'dart:async';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/generate_lesson_response_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/learning_outcomes_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/lesson_chapter_list_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/lesson_plan_template_model.dart';

/// A repository class for handling lesson plan generation details.
class LessonPlanGenerationDetailsRepo {
  /// Fetches the list of lesson plan templates from the API.
  ///
  /// Returns a [LessonPlanTemplateModel] object if the request is successful,
  /// otherwise returns `null`.
  Future<LessonPlanTemplateModel?> getLessonPlanTemplateList({
    String boards = '',
    String mediums = '',
    String classes = '', // Example: class 10
    String subjects = '', // Example: Math subject
    String type = 'lesson_plan', // Example: template type (customize as needed)
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.lessonPlanTemplateList,
        params: <String, dynamic>{
          'filter[boards]': boards,
          'filter[mediums]': mediums,
          'filter[classes]': classes,
          'filter[subjects]': subjects,
          'filter[type]': type,
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return LessonPlanTemplateModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Fetches the list of chapters from the API.
  ///
  /// Returns a [LessonChapterListModel] object if the request is successful,
  /// otherwise returns `null`.
  Future<LessonChapterListModel?> getChapterList({
    required String board,
    required String subject,
    required String medium,
    required String standard,
  }) async {
    try {
      final Response? response = await APIService.get(
        path: ApiConstants.chapterList,
        params: <String, dynamic>{
          'filter[board]': board,
          'filter[subject]': subject,
          'filter[medium]': medium,
          'filter[standard]': standard,
          'limit': 999,
          'sortBy': 'orderNumber',
          'sortOrder': 'asc',
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return LessonChapterListModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error fetching chapters: $e');
    }
    return null;
  }

  /// Fetches the learning outcomes from the API.
  ///
  /// Returns a [LearningOutcomesModel] object if the request is successful,
  /// otherwise returns `null`.
  Future<LearningOutcomesModel?> getLearningOutcomes({
    required String chapterId,
    required List<String> templateIds,
  }) async {
    try {
      final Map<String, dynamic> postData = <String, dynamic>{
        'chapterId': chapterId,
        'templateIds': templateIds,
      };

      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants
            .lessonPlanLearningOutcomes, // Use ApiConstants if defined
        data: postData,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return LearningOutcomesModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error fetching learning outcomes: $e');
    }
    return null;
  }

  /// Generates a lesson plan.
  ///
  /// Returns a [GenerateLessonResponseModel] object if the request is successful,
  /// otherwise returns `null`.
  Future<dynamic> generateLesson({
    required String subTopicId,
    bool includeVideos = false,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.generateLesson}$subTopicId',
        params: <String, dynamic>{'filter[includeVideos]': includeVideos},
        // Use ApiConstants if defined
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return GenerateLessonResponseModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } on DioException catch (e) {
      debugPrint('Error fetching learning outcomes: $e');
      return e.response?.data['message'];
    } catch (e) {
      debugPrint('Error fetching learning outcomes: $e');
    }
    return null;
  }
}
