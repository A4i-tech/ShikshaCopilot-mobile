// To parse this JSON data, do
//
//     final createResourceFeedbackModel = createResourceFeedbackModelFromJson(jsonString);

import 'dart:convert';

/// Creates a [CreateResourceFeedbackModel] from a JSON string.
CreateResourceFeedbackModel createResourceFeedbackModelFromJson(String str) =>
    CreateResourceFeedbackModel.fromJson(json.decode(str));

/// Converts a [CreateResourceFeedbackModel] to a JSON string.
String createResourceFeedbackModelToJson(CreateResourceFeedbackModel data) =>
    json.encode(data.toJson());

/// A model representing the response from creating a resource feedback.
class CreateResourceFeedbackModel {
  /// Creates a [CreateResourceFeedbackModel].
  CreateResourceFeedbackModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [CreateResourceFeedbackModel] from a JSON map.
  factory CreateResourceFeedbackModel.fromJson(Map<String, dynamic> json) =>
      CreateResourceFeedbackModel(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  /// Indicates whether the request was successful.
  bool success;

  /// A message describing the result of the request.
  String message;

  /// The data returned by the request.
  Data data;

  /// Converts this [CreateResourceFeedbackModel] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// A model representing the data of a resource feedback.
class Data {
  /// Creates a [Data] object.
  Data({
    required this.teacherId,
    required this.resourceId,
    required this.feedback,
    required this.isCompleted,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// Creates a [Data] object from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    teacherId: json['teacherId'],
    resourceId: json['resourceId'],
    feedback: json['feedback'],
    isCompleted: json['isCompleted'],
    id: json['_id'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The ID of the teacher who provided the feedback.
  String teacherId;

  /// The ID of the resource for which the feedback was provided.
  String resourceId;

  /// The feedback content.
  String feedback;

  /// Indicates whether the resource is completed.
  bool isCompleted;

  /// The ID of the feedback.
  String id;

  /// The date and time when the feedback was created.
  DateTime createdAt;

  /// The date and time when the feedback was last updated.
  DateTime updatedAt;

  /// The version of the feedback.
  int v;

  /// Converts this [Data] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'teacherId': teacherId,
    'resourceId': resourceId,
    'feedback': feedback,
    'isCompleted': isCompleted,
    '_id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}
