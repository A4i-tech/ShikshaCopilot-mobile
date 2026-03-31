// To parse this JSON data, do
//
//     final chatbotModel = chatbotModelFromJson(jsonString);

import 'dart:convert';

/// Parses a JSON string into a [ChatbotModel].
///
/// This function decodes the given JSON [str] and then converts it into
/// a [ChatbotModel] instance using [ChatbotModel.fromJson].
///
/// Parameters:
/// - [str]: The JSON string to be parsed.
///
/// Returns:
/// A [ChatbotModel] object.
ChatbotModel chatbotModelFromJson(String str) =>
    ChatbotModel.fromJson(json.decode(str));

/// Encodes a [ChatbotModel] into a JSON string.
///
/// This function converts the given [ChatbotModel] [data] into a JSON string
/// using [ChatbotModel.toJson] and then encodes it.
///
/// Parameters:
/// - [data]: The [ChatbotModel] object to be encoded.
///
/// Returns:
/// A JSON string representation of the [ChatbotModel].
String chatbotModelToJson(ChatbotModel data) => json.encode(data.toJson());

/// A model class representing the overall chatbot response.
///
/// This class holds the message and the data structure containing chat history.
class ChatbotModel {
  /// Creates a new [ChatbotModel] instance.
  ///
  /// Parameters:
  /// - [message]: An optional message string.
  /// - [data]: An optional [Data] object containing chat history.
  ChatbotModel({this.message, this.data});

  /// Factory constructor to create a [ChatbotModel] from a JSON map.
  ///
  /// Parameters:
  /// - [json]: A map containing the JSON data.
  factory ChatbotModel.fromJson(Map<String, dynamic> json) => ChatbotModel(
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
  );

  /// An optional message from the chatbot.
  final String? message;

  /// An optional [Data] object containing the chat history.
  final Data? data;

  /// Creates a copy of this [ChatbotModel] with optional new values.
  ///
  /// Parameters:
  /// - [message]: New message string to replace the current one.
  /// - [data]: New [Data] object to replace the current one.
  ///
  /// Returns:
  /// A new [ChatbotModel] instance with updated values.
  ChatbotModel copyWith({String? message, Data? data}) =>
      ChatbotModel(message: message ?? this.message, data: data ?? this.data);

  /// Converts this [ChatbotModel] instance to a JSON map.
  ///
  /// Returns:
  /// A map representation of this [ChatbotModel].
  Map<String, dynamic> toJson() => <String, dynamic>{
    'message': message,
    'data': data?.toJson(),
  };
}

/// A model class representing the data part of the chatbot response,
/// primarily containing the chat history.
class Data {
  /// Creates a new [Data] instance.
  ///
  /// Parameters:
  /// - [id]: The ID of the chat history.
  /// - [chatHistoryId]: The ID of the chat history.
  /// - [messages]: A list of [Message] objects representing individual messages.
  /// - [createdAt]: The creation timestamp of the chat history.
  /// - [updatedAt]: The last update timestamp of the chat history.
  /// - [v]: Version key.
  Data({
    this.id,
    this.chatHistoryId,
    this.messages,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Factory constructor to create a [Data] from a JSON map.
  ///
  /// Parameters:
  /// - [json]: A map containing the JSON data.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['_id'],
    chatHistoryId: json['chatHistoryId'],
    messages: json['messages'] == null
        ? <Message>[]
        : List<Message>.from(
            json['messages']!.map((dynamic x) => Message.fromJson(x)),
          ),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The unique identifier for this data entry.
  final String? id;

  /// The identifier for the chat history.
  final String? chatHistoryId;

  /// A list of messages in the chat history.
  final List<Message>? messages;

  /// The timestamp when this chat history was created.
  final DateTime? createdAt;

  /// The timestamp when this chat history was last updated.
  final DateTime? updatedAt;

  /// A version number for the data.
  final int? v;

  /// Creates a copy of this [Data] with optional new values.
  ///
  /// Parameters:
  /// - [id]: New ID to replace the current one.
  /// - [chatHistoryId]: New chat history ID to replace the current one.
  /// - [messages]: New list of [Message] objects to replace the current one.
  /// - [createdAt]: New creation timestamp to replace the current one.
  /// - [updatedAt]: New update timestamp to replace the current one.
  /// - [v]: New version number to replace the current one.
  ///
  /// Returns:
  /// A new [Data] instance with updated values.
  Data copyWith({
    String? id,
    String? chatHistoryId,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Data(
    id: id ?? this.id,
    chatHistoryId: chatHistoryId ?? this.chatHistoryId,
    messages: messages ?? this.messages,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  /// Converts this [Data] instance to a JSON map.
  ///
  /// Returns:
  /// A map representation of this [Data].
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'chatHistoryId': chatHistoryId,
    'messages': messages == null
        ? <dynamic>[]
        : List<dynamic>.from(messages!.map((Message x) => x.toJson())),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

/// A model class representing a single message in the chat history.
///
/// Each message can contain a question and an answer, along with its creation timestamp.
class Message {
  /// Creates a new [Message] instance.
  ///
  /// Parameters:
  /// - [question]: The question asked in the message.
  /// - [answer]: The answer provided in the message.
  /// - [createdAt]: The timestamp when the message was created.
  /// - [id]: The ID of the message.
  Message({this.question, this.answer, this.createdAt, this.id});

  /// Factory constructor to create a [Message] from a JSON map.
  ///
  /// Parameters:
  /// - [json]: A map containing the JSON data.
  factory Message.fromJson(Map<String, dynamic> json) => Message(
    question: json['question'],
    answer: json['answer'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    id: json['_id'],
  );

  /// The question part of the message.
  final String? question;

  /// The answer part of the message.
  final String? answer;

  /// The timestamp when the message was created.
  final DateTime? createdAt;

  /// The unique identifier for this message.
  final String? id;

  /// Creates a copy of this [Message] with optional new values.
  ///
  /// Parameters:
  /// - [question]: New question string to replace the current one.
  /// - [answer]: New answer string to replace the current one.
  /// - [createdAt]: New creation timestamp to replace the current one.
  /// - [id]: New ID to replace the current one.
  ///
  /// Returns:
  /// A new [Message] instance with updated values.
  Message copyWith({
    String? question,
    String? answer,
    DateTime? createdAt,
    String? id,
  }) => Message(
    question: question ?? this.question,
    answer: answer ?? this.answer,
    createdAt: createdAt ?? this.createdAt,
    id: id ?? this.id,
  );

  /// Converts this [Message] instance to a JSON map.
  ///
  /// Returns:
  /// A map representation of this [Message].
  Map<String, dynamic> toJson() => <String, dynamic>{
    'question': question,
    'answer': answer,
    'createdAt': createdAt?.toIso8601String(),
    '_id': id,
  };
}
