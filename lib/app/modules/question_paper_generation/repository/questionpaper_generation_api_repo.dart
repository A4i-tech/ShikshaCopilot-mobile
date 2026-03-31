import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/question_paper_generation/models/question_bank_list_model.dart';

/// Repository for API calls related to question paper generation.
class QuestionpaperGenerationApiRepo {
  /// Fetches a list of question banks.
  ///
  /// Parameters:
  /// - `board`: Optional filter for the board.
  /// - `medium`: Optional filter for the medium.
  /// - `grade`: Optional filter for the grade/class.
  /// - `subject`: Optional filter for the subject.
  /// - `search`: Optional search query.
  ///
  /// Returns:
  /// A `Future<QuestionBankListModel?>` containing the list of question banks,
  /// or `null` if the request fails.
  Future<QuestionBankListModel?> getQuestionBankList({
    String? board,
    String? medium,
    String? grade,
    String? subject,
    String? search,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.questionBankList,
        params: <String, dynamic>{
          'page': 1,
          'limit': 999,
          if (board != null) 'filter[board]': board,
          if (medium != null) 'filter[medium]': medium,
          if (grade != null) 'filter[grade]': grade,
          if (subject != null) 'filter[subject]': subject,
          if (search != null) 'search': search,
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return QuestionBankListModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }
}
