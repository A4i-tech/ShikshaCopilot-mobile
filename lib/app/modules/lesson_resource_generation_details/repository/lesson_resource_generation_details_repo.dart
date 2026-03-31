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
import 'package:sikshana/app/modules/lesson_resource_generation_details/models/generate_resource_response_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generation_details/models/lesson_resource_template_model.dart';
import 'dart:convert';

/// A repository class for handling lesson resource generation details.
///
/// This class provides methods to fetch data from the API related to
/// lesson resource generation, such as lesson resource templates, chapters,
/// learning outcomes, and generating the final resource.
class LessonResourceGenerationDetailsRepo {
  /// Fetches the list of lesson resource templates from the API.
  ///
  /// The [boards], [mediums], [classes], [subjects], and [type] parameters
  /// can be used to filter the results.
  ///
  /// Returns a [LessonResourceTemplateModel] object if the request is successful,
  /// otherwise returns `null`.
  Future<LessonResourceTemplateModel?> getLessonResourceTemplateList({
    String boards = '',
    String mediums = '',
    String classes = '', // Example: class 10
    String subjects = '', // Example: Math subject
    String type =
        'lesson_resource', // Example: template type (customize as needed)
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
        return LessonResourceTemplateModel.fromJson(
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
  /// The [board], [subject], [medium], and [standard] parameters are required
  /// to filter the results.
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

  /// Fetches the learning outcomes for a resource from the API.
  ///
  /// The [chapterId] and [templateIds] parameters are required.
  ///
  /// Returns a [LearningOutcomesModel] object if the request is successful,
  /// otherwise returns `null`.
  Future<LearningOutcomesModel?> getResourceLearningOutcomes({
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
            .resourcePlanLearningOutcomes, // Use ApiConstants if defined
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

  /// Generates a resource from the API.
  ///
  /// The [subTopicId] parameter is required. The [levels] parameter
  /// can be used to specify the difficulty levels of the resource.
  ///
  /// Returns a [GenerateResourceResponseModel] object if the request is successful,
  /// otherwise returns the error message or `null`.
  Future<dynamic> generateResource({
    required String subTopicId,
    List<String> levels = const <String>[
      'beginner',
      'intermediate',
      'advanced',
    ],
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.generateResource}$subTopicId',
        params: <String, dynamic>{
          // Encode list to JSON string for a single query key
          'filters[levels]': jsonEncode(levels),
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return GenerateResourceResponseModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } on DioException catch (e) {
      debugPrint('Error fetching resource data: $e');
      return e.response?.data['message'];
    } catch (e, stackTrace) {
      debugPrint('Error fetching resource data: $e');
      debugPrint('❌ Parse error: $e');
      debugPrint('Stack trace:\n$stackTrace');
    }
    return null;
  }
}
