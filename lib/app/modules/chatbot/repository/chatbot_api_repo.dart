import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/chatbot/models/chatbot_model.dart';

/// Repository for handling API calls related to the chatbot feature.
///
/// This class provides methods to interact with the backend for fetching
/// and sending chat messages.
class ChatbotApiRepo {
  /// Retrieves chat messages from the API.
  ///
  /// Sends a GET request to the `ApiConstants.chatMessages` endpoint.
  ///
  /// Returns a [ChatbotModel] object if the request is successful (status code 200 or 304)
  /// and `response.data` is not null. Returns `null` otherwise or if an error occurs.
  Future<ChatbotModel?> getChatMessages() async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.chatMessages,
      );

      if ((response?.statusCode == 200 || response?.statusCode == 304) &&
          response?.data != null) {
        return ChatbotModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Sends a chat message to the API.
  ///
  /// Sends a POST request to the `ApiConstants.chatMessage` endpoint with
  /// the provided [message].
  ///
  /// Parameters:
  /// - [message]: The chat message string to be sent.
  ///
  /// Returns a [String] representing the response data if the request is successful
  /// (status code 200) and `response.data['data']` is a String. Returns `null`
  /// otherwise or if an error occurs.
  Future<String?> sendChatMessage(String message) async {
    try {
      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.chatMessage,
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
