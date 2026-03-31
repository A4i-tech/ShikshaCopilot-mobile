// To parse this JSON data, do
//
//     final learningOutcomesModel = learningOutcomesModelFromJson(jsonString);

import 'dart:convert';

/// A function to convert a JSON string into a [LearningOutcomesModel] object.
LearningOutcomesModel learningOutcomesModelFromJson(String str) =>
    LearningOutcomesModel.fromJson(json.decode(str));

/// A function to convert a [LearningOutcomesModel] object into a JSON string.
String learningOutcomesModelToJson(LearningOutcomesModel data) =>
    json.encode(data.toJson());

/// A model class that represents the response from the learning outcomes API.
class LearningOutcomesModel {

  /// Creates a [LearningOutcomesModel] object.
  LearningOutcomesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [LearningOutcomesModel] object from a JSON map.
  factory LearningOutcomesModel.fromJson(Map<String, dynamic> json) =>
      LearningOutcomesModel(
        success: json['success'],
        message: json['message'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );
  /// Whether the request was successful.
  bool success;
  /// A message describing the result of the request.
  String message;
  /// The data returned by the API.
  List<Datum> data;

  /// Converts the [LearningOutcomesModel] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': List<dynamic>.from(data.map((Datum x) => x.toJson())),
  };
}

/// A model class that represents a single learning outcome.
class Datum {

  /// Creates a [Datum] object.
  Datum({
    required this.id,
    required this.isAll,
    required this.subTopics,
    required this.learningOutcomes,
  });

  /// Creates a [Datum] object from a JSON map.
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['_id'],
    isAll: json['isAll'],
    subTopics: List<String>.from(json['subTopics'].map((x) => x)),
    learningOutcomes: List<String>.from(json['learningOutcomes'].map((x) => x)),
  );
  /// The ID of the learning outcome.
  String id;
  /// Whether the learning outcome is for all sub-topics.
  bool isAll;
  /// The sub-topics covered by the learning outcome.
  List<String> subTopics;
  /// The learning outcomes.
  List<String> learningOutcomes;

  /// Converts the [Datum] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'isAll': isAll,
    'subTopics': List<dynamic>.from(subTopics.map((String x) => x)),
    'learningOutcomes': List<dynamic>.from(learningOutcomes.map((String x) => x)),
  };
}
