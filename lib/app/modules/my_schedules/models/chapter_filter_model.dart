// To parse this JSON data, do
//
//     final chapterFilterModel = chapterFilterModelFromJson(jsonString);

import 'dart:convert';

/// Parses the JSON string and returns a [ChapterFilterModel] object.
ChapterFilterModel chapterFilterModelFromJson(String str) =>
    ChapterFilterModel.fromJson(json.decode(str));

/// Converts a [ChapterFilterModel] object to a JSON string.
String chapterFilterModelToJson(ChapterFilterModel data) =>
    json.encode(data.toJson());

/// Represents the top-level response for the chapter filter API.
class ChapterFilterModel {
  /// Creates a [ChapterFilterModel] instance.
  ChapterFilterModel({this.success, this.message, this.data});

  /// Creates a [ChapterFilterModel] from a JSON object.
  factory ChapterFilterModel.fromJson(Map<String, dynamic> json) =>
      ChapterFilterModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );
  /// Indicates if the API call was successful.
  final bool? success;
  /// A message from the API.
  final String? message;
  /// The main data payload of the response.
  final Data? data;

  /// Creates a copy of the instance with optional new values.
  ChapterFilterModel copyWith({bool? success, String? message, Data? data}) =>
      ChapterFilterModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

/// Represents the data payload containing pagination info and results.
class Data {
  /// Creates a [Data] instance.
  Data({this.page, this.totalItems, this.limit, this.results});

  /// Creates a [Data] instance from a JSON object.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    page: json['page'],
    totalItems: json['totalItems'],
    limit: json['limit'],
    results: json['results'] == null
        ? <Result>[]
        : List<Result>.from(json['results']!.map((x) => Result.fromJson(x))),
  );
  /// The current page number.
  final int? page;
  /// The total number of items available.
  final int? totalItems;
  /// The number of items per page.
  final int? limit;
  /// The list of chapter results.
  final List<Result>? results;

  /// Creates a copy of the instance with optional new values.
  Data copyWith({
    int? page,
    int? totalItems,
    int? limit,
    List<Result>? results,
  }) => Data(
    page: page ?? this.page,
    totalItems: totalItems ?? this.totalItems,
    limit: limit ?? this.limit,
    results: results ?? this.results,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'page': page,
    'totalItems': totalItems,
    'limit': limit,
    'results': results == null
        ? <dynamic>[]
        : List<dynamic>.from(results!.map((Result x) => x.toJson())),
  };
}

/// Represents a single chapter (or topic) item.
class Result {
  /// Creates a [Result] instance.
  Result({
    this.id,
    this.subjectId,
    this.topics,
    this.subTopics,
    this.medium,
    this.standard,
    this.board,
    this.orderNumber,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.indexPath,
    this.learningOutcomes,
    this.topicsLearningOutcomes,
    this.subject,
  });

  /// Creates a [Result] instance from a JSON object.
  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json['_id'],
    subjectId: json['subjectId'],
    topics: json['topics'],
    subTopics: json['subTopics'] == null
        ? <String>[]
        : List<String>.from(json['subTopics']!.map((x) => x)),
    medium: json['medium'],
    standard: json['standard'],
    board: json['board'],
    orderNumber: json['orderNumber'],
    isDeleted: json['isDeleted'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
    indexPath: json['indexPath'],
    learningOutcomes: json['learningOutcomes'] == null
        ? <String>[]
        : List<String>.from(json['learningOutcomes']!.map((x) => x)),
    topicsLearningOutcomes: json['topicsLearningOutcomes'] == null
        ? <TopicsLearningOutcome>[]
        : List<TopicsLearningOutcome>.from(
            json['topicsLearningOutcomes']!.map(
              (x) => TopicsLearningOutcome.fromJson(x),
            ),
          ),
    subject: json['subject'] == null
        ? <Subject>[]
        : List<Subject>.from(json['subject']!.map((x) => Subject.fromJson(x))),
  );
  /// The unique identifier for the chapter.
  final String? id;
  /// The ID of the subject this chapter belongs to.
  final String? subjectId;
  /// The name of the topic/chapter.
  final String? topics;
  /// A list of sub-topics within this chapter.
  final List<String>? subTopics;
  /// The medium of instruction.
  final String? medium;
  /// The class/standard level.
  final int? standard;
  /// The educational board.
  final String? board;
  /// The order number for sorting.
  final int? orderNumber;
  /// A flag indicating if the item is deleted.
  final bool? isDeleted;
  /// The timestamp when the item was created.
  final DateTime? createdAt;
  /// The timestamp when the item was last updated.
  final DateTime? updatedAt;
  /// The version key.
  final int? v;
  /// The index path.
  final String? indexPath;
  /// A list of learning outcomes for the chapter.
  final List<String>? learningOutcomes;
  /// Detailed learning outcomes grouped by title.
  final List<TopicsLearningOutcome>? topicsLearningOutcomes;
  /// Detailed information about the subject.
  final List<Subject>? subject;

  /// Creates a copy of the instance with optional new values.
  Result copyWith({
    String? id,
    String? subjectId,
    String? topics,
    List<String>? subTopics,
    String? medium,
    int? standard,
    String? board,
    int? orderNumber,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? indexPath,
    List<String>? learningOutcomes,
    List<TopicsLearningOutcome>? topicsLearningOutcomes,
    List<Subject>? subject,
  }) => Result(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    topics: topics ?? this.topics,
    subTopics: subTopics ?? this.subTopics,
    medium: medium ?? this.medium,
    standard: standard ?? this.standard,
    board: board ?? this.board,
    orderNumber: orderNumber ?? this.orderNumber,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    indexPath: indexPath ?? this.indexPath,
    learningOutcomes: learningOutcomes ?? this.learningOutcomes,
    topicsLearningOutcomes:
        topicsLearningOutcomes ?? this.topicsLearningOutcomes,
    subject: subject ?? this.subject,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subjectId': subjectId,
    'topics': topics,
    'subTopics': subTopics == null
        ? <dynamic>[]
        : List<dynamic>.from(subTopics!.map((String x) => x)),
    'medium': medium,
    'standard': standard,
    'board': board,
    'orderNumber': orderNumber,
    'isDeleted': isDeleted,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'indexPath': indexPath,
    'learningOutcomes': learningOutcomes == null
        ? <dynamic>[]
        : List<dynamic>.from(learningOutcomes!.map((String x) => x)),
    'topicsLearningOutcomes': topicsLearningOutcomes == null
        ? <dynamic>[]
        : List<dynamic>.from(
            topicsLearningOutcomes!.map(
              (TopicsLearningOutcome x) => x.toJson(),
            ),
          ),
    'subject': subject == null
        ? <dynamic>[]
        : List<dynamic>.from(subject!.map((Subject x) => x.toJson())),
  };
}

/// Represents the subject details associated with a chapter.
class Subject {
  /// Creates a [Subject] instance.
  Subject({
    this.id,
    this.subjectName,
    this.name,
    this.sem,
    this.boards,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Creates a [Subject] instance from a JSON object.
  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json['_id'],
    subjectName: json['subjectName'],
    name: json['name'],
    sem: json['sem'],
    boards: json['boards'] == null
        ? <String>[]
        : List<String>.from(json['boards']!.map((x) => x)),
    isDeleted: json['isDeleted'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );
  /// The unique identifier for the subject.
  final String? id;
  /// The name of the subject.
  final String? subjectName;
  /// An alternative name for the subject.
  final String? name;
  /// The semester.
  final int? sem;
  /// The boards this subject is associated with.
  final List<String>? boards;
  /// A flag indicating if the item is deleted.
  final bool? isDeleted;
  /// The timestamp when the item was created.
  final DateTime? createdAt;
  /// The timestamp when the item was last updated.
  final DateTime? updatedAt;
  /// The version key.
  final int? v;

  /// Creates a copy of the instance with optional new values.
  Subject copyWith({
    String? id,
    String? subjectName,
    String? name,
    int? sem,
    List<String>? boards,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Subject(
    id: id ?? this.id,
    subjectName: subjectName ?? this.subjectName,
    name: name ?? this.name,
    sem: sem ?? this.sem,
    boards: boards ?? this.boards,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subjectName': subjectName,
    'name': name,
    'sem': sem,
    'boards': boards == null
        ? <dynamic>[]
        : List<dynamic>.from(boards!.map((String x) => x)),
    'isDeleted': isDeleted,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

/// Represents a grouping of learning outcomes by a title.
class TopicsLearningOutcome {
  /// Creates a [TopicsLearningOutcome] instance.
  TopicsLearningOutcome({this.title, this.learningOutcomes, this.id});

  /// Creates a [TopicsLearningOutcome] instance from a JSON object.
  factory TopicsLearningOutcome.fromJson(Map<String, dynamic> json) =>
      TopicsLearningOutcome(
        title: json['title'],
        learningOutcomes: json['learningOutcomes'] == null
            ? <String>[]
            : List<String>.from(json['learningOutcomes']!.map((x) => x)),
        id: json['_id'],
      );
  /// The title of the group.
  final String? title;
  /// The list of learning outcome strings.
  final List<String>? learningOutcomes;
  /// The unique ID for this group.
  final String? id;

  /// Creates a copy of the instance with optional new values.
  TopicsLearningOutcome copyWith({
    String? title,
    List<String>? learningOutcomes,
    String? id,
  }) => TopicsLearningOutcome(
    title: title ?? this.title,
    learningOutcomes: learningOutcomes ?? this.learningOutcomes,
    id: id ?? this.id,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'learningOutcomes': learningOutcomes == null
        ? <dynamic>[]
        : List<dynamic>.from(learningOutcomes!.map((String x) => x)),
    '_id': id,
  };
}
