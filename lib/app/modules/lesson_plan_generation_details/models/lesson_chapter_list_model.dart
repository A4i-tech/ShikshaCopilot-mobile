// To parse this JSON data, do
//
//     final lessonChapterListModel = lessonChapterListModelFromJson(jsonString);

import 'dart:convert';

/// A function to convert a JSON string into a [LessonChapterListModel] object.
LessonChapterListModel lessonChapterListModelFromJson(String str) =>
    LessonChapterListModel.fromJson(json.decode(str));

/// A function to convert a [LessonChapterListModel] object into a JSON string.
String lessonChapterListModelToJson(LessonChapterListModel data) =>
    json.encode(data.toJson());

/// A model class that represents the response from the chapter list API.
class LessonChapterListModel {
  /// Creates a [LessonChapterListModel] object.
  LessonChapterListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [LessonChapterListModel] object from a JSON map.
  factory LessonChapterListModel.fromJson(Map<String, dynamic> json) =>
      LessonChapterListModel(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  /// Whether the request was successful.
  bool success;

  /// A message describing the result of the request.
  String message;

  /// The data returned by the API.
  Data data;

  /// Converts the [LessonChapterListModel] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// A model class that represents the data returned by the chapter list API.
class Data {
  /// Creates a [Data] object.
  Data({
    required this.page,
    required this.totalItems,
    required this.limit,
    required this.results,
  });

  /// Creates a [Data] object from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    page: json['page'],
    totalItems: json['totalItems'],
    limit: json['limit'],
    results: List<Result>.from(json['results'].map((x) => Result.fromJson(x))),
  );

  /// The current page number.
  int page;

  /// The total number of items.
  int totalItems;

  /// The number of items per page.
  int limit;

  /// The list of chapters.
  List<Result> results;

  /// Converts the [Data] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'page': page,
    'totalItems': totalItems,
    'limit': limit,
    'results': List<dynamic>.from(results.map((Result x) => x.toJson())),
  };
}

/// A model class that represents a single chapter.
class Result {
  /// Creates a [Result] object.
  Result({
    required this.id,
    required this.subjectId,
    required this.topics,
    required this.subTopics,
    required this.medium,
    required this.standard,
    required this.board,
    required this.orderNumber,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,

    //  required this.v,
    required this.learningOutcomes,
    required this.topicsLearningOutcomes,
    required this.subject,
  });

  /// Creates a [Result] object from a JSON map.
  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json['_id'],
    subjectId: json['subjectId'],
    topics: json['topics'],
    subTopics: List<String>.from(json['subTopics'].map((x) => x)),
    medium: json['medium'],
    standard: json['standard'],
    board: json['board'],
    orderNumber: json['orderNumber'],
    isDeleted: json['isDeleted'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),

    // v: json['__v'],
    learningOutcomes:
        json['learningOutcomes']?.map<String>((x) => x.toString()).toList() ??
        [],
    topicsLearningOutcomes:
        json['topicsLearningOutcomes']
            ?.map<TopicsLearningOutcome>(
              (x) => TopicsLearningOutcome.fromJson(x),
            )
            .toList() ??
        [],
    subject:
        json['subject']?.map<Subject>((x) => Subject.fromJson(x)).toList() ??
        [],
  );

  /// The ID of the chapter.
  String id;

  /// The ID of the subject to which the chapter belongs.
  String subjectId;

  /// The topics in the chapter.
  String topics;

  /// The sub-topics in the chapter.
  List<String> subTopics;

  /// The medium of instruction for the chapter.
  String medium;

  /// The standard of the chapter.
  int standard;

  /// The board to which the chapter belongs.
  String board;

  /// The order number of the chapter.
  int orderNumber;

  /// Whether the chapter has been deleted.
  bool isDeleted;

  /// The date and time when the chapter was created.
  DateTime createdAt;

  /// The date and time when the chapter was last updated.
  DateTime updatedAt;

  // /// The version of the chapter.
  // int v;

  /// The learning outcomes of the chapter.
  List<String> learningOutcomes;

  /// The learning outcomes for each topic in the chapter.
  List<TopicsLearningOutcome> topicsLearningOutcomes;

  /// The subject to which the chapter belongs.
  List<Subject> subject;

  /// Converts the [Result] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subjectId': subjectId,
    'topics': topics,
    'subTopics': List<dynamic>.from(subTopics.map((String x) => x)),
    'medium': medium,
    'standard': standard,
    'board': board,
    'orderNumber': orderNumber,
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),

    // '__v': v,
    'learningOutcomes': List<dynamic>.from(
      learningOutcomes.map((String x) => x),
    ),
    'topicsLearningOutcomes': List<dynamic>.from(
      topicsLearningOutcomes.map((TopicsLearningOutcome x) => x.toJson()),
    ),
    'subject': List<dynamic>.from(subject.map((Subject x) => x.toJson())),
  };
}

/// A model class that represents a subject.
class Subject {
  /// Creates a [Subject] object.
  Subject({
    required this.id,
    required this.subjectName,
    required this.name,
    required this.sem,
    required this.boards,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// Creates a [Subject] object from a JSON map.
  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json['_id'],
    subjectName: json['subjectName'],
    name: json['name'],
    sem: json['sem'],
    boards: List<String>.from(json['boards'].map((x) => x)),
    isDeleted: json['isDeleted'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The ID of the subject.
  String id;

  /// The name of the subject.
  String subjectName;

  /// The name of the subject.
  String name;

  /// The semester in which the subject is taught.
  int sem;

  /// The boards to which the subject belongs.
  List<String> boards;

  /// Whether the subject has been deleted.
  bool isDeleted;

  /// The date and time when the subject was created.
  DateTime createdAt;

  /// The date and time when the subject was last updated.
  DateTime updatedAt;

  /// The version of the subject.
  int v;

  /// Converts the [Subject] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subjectName': subjectName,
    'name': name,
    'sem': sem,
    'boards': List<dynamic>.from(boards.map((String x) => x)),
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}

/// A model class that represents the learning outcomes for a topic.
class TopicsLearningOutcome {
  /// Creates a [TopicsLearningOutcome] object.
  TopicsLearningOutcome({
    required this.title,
    required this.learningOutcomes,
    required this.id,
  });

  /// Creates a [TopicsLearningOutcome] object from a JSON map.
  factory TopicsLearningOutcome.fromJson(Map<String, dynamic> json) =>
      TopicsLearningOutcome(
        title: json['title'],
        learningOutcomes: List<String>.from(
          json['learningOutcomes'].map((x) => x),
        ),
        id: json['_id'],
      );

  /// The title of the topic.
  String title;

  /// The learning outcomes for the topic.
  List<String> learningOutcomes;

  /// The ID of the topic.
  String id;

  /// Converts the [TopicsLearningOutcome] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'learningOutcomes': List<dynamic>.from(
      learningOutcomes.map((String x) => x),
    ),
    '_id': id,
  };
}
