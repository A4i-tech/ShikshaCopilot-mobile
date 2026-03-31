import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/question_paper/models/get_by_sem_model.dart';
import 'package:sikshana/app/modules/question_paper/models/question_bank_model.dart';
import 'package:sikshana/app/modules/question_paper/models/template_model.dart';

/// Repository for API calls related to question paper generation.
class QuestionPaperApiRepo {
  /// Fetches chapters by semester.
  ///
  /// Parameters:
  /// - `board`: The board of education.
  /// - `medium`: The medium of instruction.
  /// - `standard`: The class/grade level.
  /// - `subject`: The list of subjects.
  ///
  /// Returns:
  /// A `Future<GetBySemModel?>` containing the chapter data, or `null` if the request fails.
  Future<GetBySemModel?> getChapterBySem({
    String? board,
    String? medium,
    String? standard,
    List<String>? subject,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.getChapterBySem,
        encrypt: false,
        params: <String, dynamic>{
          if (board != null) 'filter[board]': board,
          if (medium != null) 'filter[medium]': medium,
          if (standard != null) 'filter[standard]': standard,
          if (subject != null) 'filter[subject]': jsonEncode(subject),
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return GetBySemModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Generates a question paper template.
  ///
  /// Parameters:
  /// - `isMultiChapter`: Whether the template covers multiple chapters.
  /// - `medium`: The medium of instruction.
  /// - `board`: The board of education.
  /// - `grade`: The class/grade level.
  /// - `subject`: The subject.
  /// - `chapter`: The list of chapters.
  /// - `subTopic`: The list of sub-topics.
  /// - `totalMarks`: The total marks for the question paper.
  /// - `examinationName`: The name of the examination.
  /// - `chapterIds`: The IDs of the chapters.
  /// - `marksDistribution`: The distribution of marks.
  ///
  /// Returns:
  /// A `Future<TemplateModel?>` containing the generated template, or `null` if the request fails.
  Future<TemplateModel?> generateTemplate({
    required bool isMultiChapter,
    String? medium,
    String? board,
    int? grade,
    String? subject,
    List<String>? chapter,
    List<String>? subTopic,
    int? totalMarks,
    String? examinationName,
    List<String>? chapterIds,
    List<Map<String, dynamic>>? marksDistribution,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.generateTemplate,
        data: <String, dynamic>{
          'medium': medium,
          'board': board,
          'grade': grade,
          'subject': subject,
          'chapter': isMultiChapter ? chapter : chapter?.first,
          'subTopic': subTopic,
          'totalMarks': totalMarks,
          'examinationName': examinationName,
          'chapterIds': isMultiChapter ? chapterIds : chapterIds?.first,
          'isMultiChapter': isMultiChapter,
          'marksDistribution': marksDistribution,
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return TemplateModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Generates a question paper blueprint.
  ///
  /// Parameters are similar to [generateTemplate], with the addition of
  /// `objectiveDistribution` and `template`.
  ///
  /// Returns:
  /// A `Future<TemplateModel?>` containing the generated blueprint, or `null` if the request fails.
  Future<TemplateModel?> generateBluePrint({
    required bool isMultiChapter,
    String? medium,
    String? board,
    int? grade,
    String? subject,
    List<String>? chapter,
    List<String>? subTopic,
    int? totalMarks,
    String? examinationName,
    List<String>? chapterIds,
    List<Map<String, dynamic>>? marksDistribution,
    List<Map<String, dynamic>>? objectiveDistribution,
    List<Map<String, dynamic>>? template,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.generateBluePrint,
        data: <String, dynamic>{
          'medium': medium,
          'board': board,
          'grade': grade,
          'subject': subject,
          'chapter': isMultiChapter ? chapter : chapter?.first,
          'subTopic': subTopic,
          'totalMarks': totalMarks,
          'examinationName': examinationName,
          'chapterIds': isMultiChapter ? chapterIds : chapterIds?.first,
          'isMultiChapter': isMultiChapter,
          'marksDistribution': marksDistribution,
          'objective_distribution': objectiveDistribution,
          'template': template,
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return TemplateModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Generates the final question bank.
  ///
  /// Parameters are similar to [generateBluePrint], with the addition of
  /// `questionBankTemplate`.
  ///
  /// Returns:
  /// A `Future<QuestionBankModel?>` containing the generated question bank, or `null` if the request fails.
  Future<QuestionBankModel?> generateQuestionBank({
    required bool isMultiChapter, String? medium,
    String? board,
    int? grade,
    String? subject,
    List<String>? chapter,
    List<String>? subTopic,
    int? totalMarks,
    String? examinationName,
    List<String>? chapterIds,
    List<Map<String, dynamic>>? marksDistribution,
    List<Map<String, dynamic>>? template,
    List<Map<String, dynamic>>? objectiveDistribution,
    List<Map<String, dynamic>>? questionBankTemplate,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.generateQuestionBank,
        data: <String, dynamic>{
          'medium': medium,
          'board': board,
          'grade': grade,
          'subject': subject,
          'chapter': isMultiChapter ? chapter : chapter?.first,
          'subTopic': subTopic,
          'totalMarks': totalMarks,
          'examinationName': examinationName,
          'chapterIds': isMultiChapter ? chapterIds : chapterIds?.first,
          'isMultiChapter': isMultiChapter,
          'marksDistribution': marksDistribution,
          'template': template,
          'objectiveDistribution': objectiveDistribution,
          'questionBankTemplate': questionBankTemplate,
        },
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
}
