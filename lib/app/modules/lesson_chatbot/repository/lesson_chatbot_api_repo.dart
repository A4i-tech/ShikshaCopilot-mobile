import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/lesson_chatbot/models/lesson_chatbot_model.dart';

/// A repository for handling API calls related to the lesson chatbot.
class LessonChatbotApiRepo {
  /// Fetches the chat messages for a specific lesson and chapter.
  ///
  /// Returns a [LessonChatbotModel] on success, otherwise returns `null`.
  ///
  /// - [lessonId]: The ID of the lesson.
  /// - [chapterId]: The ID of the chapter.
  Future<LessonChatbotModel?> getChatMessages({
    required String lessonId,
    required String chapterId,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.lessonchatMessages}/$lessonId/$chapterId',
      );

      if ((response?.statusCode == 200 || response?.statusCode == 304) &&
          response?.data != null) {
        return LessonChatbotModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Sends a chat message to the server.
  ///
  /// Returns a [String] response on success, otherwise returns `null`.
  ///
  /// - [message]: The message to send.
  /// - [lessonId]: The ID of the lesson.
  /// - [chapterId]: The ID of the chapter.
  Future<String?> sendChatMessage(
    String message, {
    required String lessonId,
    required String chapterId,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.post(
        path: '${ApiConstants.lessonchatMessage}/$lessonId/$chapterId',
        data: <String, dynamic>{'message': message},
      );
      if (response?.statusCode == 200 && response?.data['data'] != null) {
        return response!.data['data'] is String ? response.data['data'] : null;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }
}
