import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart';

/// A repository class for handling home related API calls.
class HomeApiRepo {
  /// Fetches the list of lesson plans from the API.
  ///
  /// Returns a [LessonPlan] object on success, or `null` on failure.
  ///
  /// The following parameters can be provided:
  /// * [limit]: The maximum number of items to fetch.
  /// * [sortBy]: The field to sort the results by.
  /// * [filterType]: The type of filter to apply.
  /// * [isCompleted]: Whether to fetch completed lesson plans.
  Future<LessonPlan?> getLessonPlans({
    int limit = 999,
    String sortBy = 'updatedAt',
    String filterType = 'all',
    bool isCompleted = true,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.teacherLessonPlanList,
        params: <String, dynamic>{
          'limit': limit,
          'sortBy': sortBy,
          'filter[type]': filterType,
          'filter[isCompleted]': isCompleted,
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
