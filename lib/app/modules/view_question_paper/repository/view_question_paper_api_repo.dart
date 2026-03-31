import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/question_paper/models/question_bank_model.dart';

/// Repository for API calls related to viewing question papers.
class ViewQpApiRepo {
  /// Fetches a question bank by its ID.
  ///
  /// Parameters:
  /// - `questionBankId`: The ID of the question bank to fetch.
  ///
  /// Returns:
  /// A `Future<QuestionBankModel?>` containing the fetched question bank model,
  /// or `null` if the request fails.
  Future<QuestionBankModel?> getQuestionBankById({
    String? questionBankId,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.getQuestionBank}/$questionBankId',
        encrypt: false,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return QuestionBankModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Submits feedback for a question paper.
  ///
  /// Parameters:
  /// - `questionBankId`: The ID of the question bank to submit feedback for.
  /// - `question`: The feedback question.
  /// - `feedback`: The selected feedback option (e.g., "agree", "disagree").
  /// - `overallFeedback`: Additional overall feedback comments.
  ///
  /// Returns:
  /// A `Future<bool>` indicating whether the feedback submission was successful.
  Future<bool> submitFeedback({
    String? questionBankId,
    String? question,
    String? feedback,
    String? overallFeedback,
  }) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{
        'question': question,
        'feedback': feedback,
        'overallFeedback': overallFeedback,
      };
      final Response<dynamic>? response = await APIService.patch(
        path: '${ApiConstants.getQuestionBank}/feedback/$questionBankId',
        data: data,
        encrypt: false,
      );

      if (response?.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return false;
  }
}
