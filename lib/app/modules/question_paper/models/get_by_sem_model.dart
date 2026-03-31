import 'dart:convert';

/// Parses the JSON string into a [GetBySemModel] object.
GetBySemModel getBySemModelFromJson(String str) =>
    GetBySemModel.fromJson(json.decode(str));

/// Converts a [GetBySemModel] object to a JSON string.
String getBySemModelToJson(GetBySemModel data) => json.encode(data.toJson());

/// Model representing the response for fetching chapters by semester.
class GetBySemModel {
  /// Constructs a [GetBySemModel].
  GetBySemModel({this.success, this.message, this.data});

  /// Factory constructor to create a [GetBySem-Model] from JSON.
  factory GetBySemModel.fromJson(Map<String, dynamic> json) => GetBySemModel(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null
        ? <Datum>[]
        : List<Datum>.from(json['data']!.map((x) => Datum.fromJson(x))),
  );

  /// Indicates if the API call was successful.
  final bool? success;

  /// A message from the API.
  final String? message;

  /// The data containing the list of chapters.
  final List<Datum>? data;

  /// Creates a copy of this [GetBySemModel] with optional new values.
  GetBySemModel copyWith({bool? success, String? message, List<Datum>? data}) =>
      GetBySemModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  /// Converts this [GetBySemModel] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data == null
        ? <dynamic>[]
        : List<dynamic>.from(data!.map((Datum x) => x.toJson())),
  };
}

/// Represents a single chapter data item.
class Datum {
  /// Constructs a [Datum].
  Datum({
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

  /// Factory constructor to create a [Datum] from JSON.
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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

  /// The unique identifier of the chapter.
  final String? id;

  /// The ID of the subject this chapter belongs to.
  final String? subjectId;

  /// The topics covered in this chapter.
  final String? topics;

  /// A list of sub-topics in this chapter.
  final List<String>? subTopics;

  /// The medium of instruction.
  final String? medium;

  /// The class/grade level.
  final int? standard;

  /// The board (e.g., KSEEB).
  final String? board;

  /// The order number of the chapter.
  final int? orderNumber;

  /// Indicates if the chapter is deleted.
  final bool? isDeleted;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// The index path.
  final String? indexPath;

  /// A list of learning outcomes for this chapter.
  final List<String>? learningOutcomes;

  /// A list of learning outcomes categorized by topics.
  final List<TopicsLearningOutcome>? topicsLearningOutcomes;

  /// The subject associated with this chapter.
  final List<Subject>? subject;

  /// Creates a copy of this [Datum] with optional new values.
  Datum copyWith({
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
  }) => Datum(
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

  /// Converts this [Datum] object to JSON.
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

/// Represents a subject.
class Subject {
  /// Constructs a [Subject].
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

  /// Factory constructor to create a [Subject] from JSON.
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

  /// The unique identifier of the subject.
  final String? id;

  /// The name of the subject.
  final String? subjectName;

  /// The name of the subject.
  final String? name;

  /// The semester number.
  final int? sem;

  /// The boards associated with this subject.
  final List<String>? boards;

  /// Indicates if the subject is deleted.
  final bool? isDeleted;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// Creates a copy of this [Subject] with optional new values.
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

  /// Converts this [Subject] object to JSON.
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

/// Represents learning outcomes for a specific topic.
class TopicsLearningOutcome {
  /// Constructs a [TopicsLearningOutcome].
  TopicsLearningOutcome({this.title, this.learningOutcomes, this.id});

  /// Factory constructor to create a [TopicsLearningOutcome] from JSON.
  factory TopicsLearningOutcome.fromJson(Map<String, dynamic> json) =>
      TopicsLearningOutcome(
        title: json['title'],
        learningOutcomes: json['learningOutcomes'] == null
            ? <String>[]
            : List<String>.from(json['learningOutcomes']!.map((x) => x)),
        id: json['_id'],
      );

  /// The title of the topic.
  final String? title;

  /// A list of learning outcomes for this topic.
  final List<String>? learningOutcomes;

  /// The unique identifier of the topic learning outcome.
  final String? id;

  /// Creates a copy of this [TopicsLearningOutcome] with optional new values.
  TopicsLearningOutcome copyWith({
    String? title,
    List<String>? learningOutcomes,
    String? id,
  }) => TopicsLearningOutcome(
    title: title ?? this.title,
    learningOutcomes: learningOutcomes ?? this.learningOutcomes,
    id: id ?? this.id,
  );

  /// Converts this [TopicsLearningOutcome] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'learningOutcomes': learningOutcomes == null
        ? <dynamic>[]
        : List<dynamic>.from(learningOutcomes!.map((String x) => x)),
    '_id': id,
  };
}
