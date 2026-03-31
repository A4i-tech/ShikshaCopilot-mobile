import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/generation_status/models/generation_status_model.dart';

class GenerationStatusApiRepo {
  ///get generation status list
  Future<GenerationStatus?> getGenerationStatus({
    String? board,
    String? medium,
    String? filterClass,
    String? subject,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.teacherLessonPlanList,
        params: <String, dynamic>{
          'page': 1,
          'limit': 999,
          'filter[type]': 'all',
          if (board != null) 'filter[board]': board,
          if (medium != null) 'filter[medium]': medium,
          if (filterClass != null) 'filter[class]': filterClass,
          if (subject != null) 'filter[subject]': subject,
          'filter[isGenerated]': true,
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return GenerationStatus.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }
}
