// To parse this JSON data, do
//
//     final createLessonFeedbackModel = createLessonFeedbackModelFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into a [CreateLessonFeedbackModel] instance.
///
/// - [str]: The raw JSON string received from the API.
/// - Returns: A parsed [CreateLessonFeedbackModel] object.
CreateLessonFeedbackModel createLessonFeedbackModelFromJson(String str) =>
    CreateLessonFeedbackModel.fromJson(json.decode(str));

/// Converts a [CreateLessonFeedbackModel] instance into a JSON string.
///
/// - [data]: The model instance to be converted.
/// - Returns: A JSON-encoded string.
String createLessonFeedbackModelToJson(CreateLessonFeedbackModel data) =>
    json.encode(data.toJson());

/// Represents the response model returned after submitting lesson feedback.
///
/// This model contains:
/// - Whether the operation was successful
/// - A message from the server
/// - A nested [Data] object with detailed feedback information
class CreateLessonFeedbackModel {
  /// Creates a new instance of [CreateLessonFeedbackModel].
  ///
  /// All fields are required as the API guarantees their presence.
  CreateLessonFeedbackModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Parses a JSON map into a [CreateLessonFeedbackModel] object.
  ///
  /// - [json]: The decoded JSON map.
  factory CreateLessonFeedbackModel.fromJson(Map<String, dynamic> json) =>
      CreateLessonFeedbackModel(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  /// Whether the feedback submission was successful.
  bool success;

  /// Server-returned message describing the operation result.
  String message;

  /// Detailed feedback information.
  Data data;

  /// Converts this model into a JSON map.
  ///
  /// Useful for API requests or local storage.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// Represents the detailed feedback data associated with a lesson.
///
/// This includes:
/// - Teacher and lesson IDs
/// - Lists of phase-based feedback (5E model)
/// - Assessment details
/// - Completion status
/// - Metadata such as creation timestamps
class Data {
  /// Constructs a [Data] model representing detailed feedback attributes.
  Data({
    required this.teacherId,
    required this.lessonId,
    required this.feedbackPerSets,
    required this.assessment,
    required this.feedback,
    required this.isCompleted,
    required this.id,
    required this.regenFeedback,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// Creates a [Data] instance by parsing a JSON map.
  ///
  /// - [json]: The decoded JSON map returned by the API.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    teacherId: json['teacherId'],
    lessonId: json['lessonId'],
    feedbackPerSets: List<dynamic>.from(json['feedbackPerSets'].map((x) => x)),
    assessment: List<dynamic>.from(json['assessment'].map((x) => x)),
    feedback: json['feedback'],
    isCompleted: json['isCompleted'],
    id: json['_id'],
    regenFeedback: List<dynamic>.from(json['regenFeedback'].map((x) => x)),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// ID of the teacher who submitted the feedback.
  String teacherId;

  /// ID of the lesson associated with the feedback.
  String lessonId;

  /// Phase-wise feedback sets (e.g., Engage, Explore, Explain, etc.).
  List<dynamic> feedbackPerSets;

  /// Assessment data (structure depends on backend response).
  List<dynamic> assessment;

  /// Overall textual feedback.
  String feedback;

  /// Indicates whether the lesson has been marked as completed.
  bool isCompleted;

  /// Unique identifier for this feedback entry.
  String id;

  /// Phase-based regeneration feedback provided during re-generation attempts.
  List<dynamic> regenFeedback;

  /// The timestamp when this entry was created.
  DateTime createdAt;

  /// The timestamp when this entry was last updated.
  DateTime updatedAt;

  /// Version key used internally by MongoDB.
  int v;

  /// Converts this model instance to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'teacherId': teacherId,
    'lessonId': lessonId,
    'feedbackPerSets': List<dynamic>.from(feedbackPerSets.map((x) => x)),
    'assessment': List<dynamic>.from(assessment.map((x) => x)),
    'feedback': feedback,
    'isCompleted': isCompleted,
    '_id': id,
    'regenFeedback': List<dynamic>.from(regenFeedback.map((x) => x)),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}
