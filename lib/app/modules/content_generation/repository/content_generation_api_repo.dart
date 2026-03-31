import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart';

/// A repository class for handling content generation API requests.
///
/// This class provides methods for fetching lesson plans and lesson plan
/// templates from the API.
class ContentGenerationApiRepo {
  /// Fetches a list of lesson plans from the API.
  ///
  /// This method sends a GET request to the [ApiConstants.teacherLessonPlanList]
  /// endpoint with the specified filters.
  ///
  /// The [limit] parameter specifies the maximum number of items to return.
  /// The [sortBy] parameter specifies the field to sort the results by.
  /// The [filterType] parameter can be used to filter the results.
  /// The [isCompleted] parameter filters for completed lesson plans.
  /// The [board], [medium], [createdMonth], [planStatus], [planType],
  /// [className], [subject], and [search] parameters are used to filter the
  /// results based on their respective fields.
  ///
  /// Returns a [LessonPlan] object on success, or `null` on failure.
  Future<LessonPlan?> getLessonPlans({
    int limit = 999,
    String sortBy = 'updatedAt',
    String filterType = 'all',
    bool isCompleted = true,
    String board = '',
    String medium = '',
    String createdMonth = '00',
    bool isGenerated = false,
    String planStatus = 'All',
    String planType = 'All',
    String className = '', // renamed from 'class' to avoid keyword clash
    String subject = '',
    String search = '',
  }) async {
    try {
      final Response? response = await APIService.get(
        path: ApiConstants.teacherLessonPlanList,
        params: <String, dynamic>{
          'limit': limit,
          'sortBy': sortBy,
          'filter[type]': filterType,
          //  'filter[isCompleted]': isCompleted,
          if (board.isNotEmpty) 'filter[board]': board,
          if (medium.isNotEmpty) 'filter[medium]': medium,
          if (createdMonth.isNotEmpty) 'filter[createdMonth]': createdMonth,
          'filter[isGenerated]': isGenerated,
          if (planStatus != 'All') 'filter[planStatus]': planStatus,
          if (planType != 'All') 'filter[planType]': planType,
          if (className.isNotEmpty) 'filter[class]': className,
          if (search.isNotEmpty) 'search': search,
          //    if (subject.isNotEmpty) 'filter[subject]': subject,
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return LessonPlan.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Fetches a list of lesson plan templates from the API.
  ///
  /// This method sends a GET request to the [ApiConstants.lessonPlanTemplateList]
  /// endpoint with the specified filters.
  ///
  /// The [boards], [mediums], [classes], [subjects], and [type] parameters are
  /// used to filter the results.
  ///
  /// Returns a [LessonPlan] object on success, or `null` on failure.
  Future<LessonPlan?> lessonPlanTemplateList({
    String boards = 'KSEEB',
    String mediums = 'english',
    String classes = '10', // Example: class 10
    String subjects = 'math', // Example: Math subject
    String type = 'template', // Example: template type (customize as needed)
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
        return LessonPlan.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }
}
