// To parse this JSON data, do
//
//     final lessonChatbotModel = lessonChatbotModelFromJson(jsonString);

import 'dart:convert';

/// Parses a JSON string and returns a [LessonChatbotModel] object.
LessonChatbotModel lessonChatbotModelFromJson(String str) =>
    LessonChatbotModel.fromJson(json.decode(str));

/// Converts a [LessonChatbotModel] object to a JSON string.
String lessonChatbotModelToJson(LessonChatbotModel data) =>
    json.encode(data.toJson());

/// Represents the main model for the lesson chatbot.
class LessonChatbotModel {
  /// Creates a new instance of [LessonChatbotModel].
  LessonChatbotModel({this.message, this.data});

  /// Creates a [LessonChatbotModel] from a JSON object.
  factory LessonChatbotModel.fromJson(Map<String, dynamic> json) =>
      LessonChatbotModel(
        message: json['message'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  /// The message associated with the response.
  final String? message;

  /// The data associated with the response.
  final Data? data;

  /// Creates a copy of the [LessonChatbotModel] with the given fields replaced.
  LessonChatbotModel copyWith({String? message, Data? data}) =>
      LessonChatbotModel(
        message: message ?? this.message,
        data: data ?? this.data,
      );

  /// Converts the [LessonChatbotModel] to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'message': message,
    'data': data?.toJson(),
  };
}

/// Represents the data payload of the lesson chatbot response.
class Data {
  /// Creates a new instance of [Data].
  Data({this.messages, this.chapterDetails, this.subject});

  /// Creates a [Data] object from a JSON object.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    messages: json['messages'] == null
        ? <Message>[]
        : List<Message>.from(json['messages']!.map((x) => Message.fromJson(x))),
    chapterDetails: json['chapterDetails'] == null
        ? null
        : ChapterDetails.fromJson(json['chapterDetails']),
    subject: json['subject'] == null ? null : Subject.fromJson(json['subject']),
  );

  /// The list of messages in the chat.
  final List<Message>? messages;

  /// The details of the chapter.
  final ChapterDetails? chapterDetails;

  /// The subject of the lesson.
  final Subject? subject;

  /// Creates a copy of the [Data] with the given fields replaced.
  Data copyWith({
    List<Message>? messages,
    ChapterDetails? chapterDetails,
    Subject? subject,
  }) => Data(
    messages: messages ?? this.messages,
    chapterDetails: chapterDetails ?? this.chapterDetails,
    subject: subject ?? this.subject,
  );

  /// Converts the [Data] to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'messages': messages == null
        ? <dynamic>[]
        : List<dynamic>.from(messages!.map((Message x) => x.toJson())),
    'chapterDetails': chapterDetails?.toJson(),
    'subject': subject?.toJson(),
  };
}

/// Represents the details of a chapter.
class ChapterDetails {
  /// Creates a new instance of [ChapterDetails].
  ChapterDetails({
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
  });

  /// Creates a [ChapterDetails] object from a JSON object.
  factory ChapterDetails.fromJson(Map<String, dynamic> json) => ChapterDetails(
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
  );

  /// The unique identifier of the chapter.
  final String? id;

  /// The identifier of the subject.
  final String? subjectId;

  /// The topics covered in the chapter.
  final String? topics;

  /// The sub-topics covered in the chapter.
  final List<String>? subTopics;

  /// The medium of instruction.
  final String? medium;

  /// The standard or grade level.
  final int? standard;

  /// The educational board.
  final String? board;

  /// The order number of the chapter.
  final int? orderNumber;

  /// Indicates whether the chapter is deleted.
  final bool? isDeleted;

  /// The timestamp when the chapter was created.
  final DateTime? createdAt;

  /// The timestamp when the chapter was last updated.
  final DateTime? updatedAt;

  /// The version number.
  final int? v;

  /// The index path of the chapter.
  final String? indexPath;

  /// The learning outcomes of the chapter.
  final List<String>? learningOutcomes;

  /// The learning outcomes for each topic.
  final List<TopicsLearningOutcome>? topicsLearningOutcomes;

  /// Creates a copy of the [ChapterDetails] with the given fields replaced.
  ChapterDetails copyWith({
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
  }) => ChapterDetails(
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
  );

  /// Converts the [ChapterDetails] to a JSON object.
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
  };
}

/// Represents the learning outcomes for a specific topic.
class TopicsLearningOutcome {
  /// Creates a new instance of [TopicsLearningOutcome].
  TopicsLearningOutcome({this.title, this.learningOutcomes, this.id});

  /// Creates a [TopicsLearningOutcome] object from a JSON object.
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

  /// The learning outcomes for the topic.
  final List<String>? learningOutcomes;

  /// The unique identifier of the topic learning outcome.
  final String? id;

  /// Creates a copy of the [TopicsLearningOutcome] with the given fields replaced.
  TopicsLearningOutcome copyWith({
    String? title,
    List<String>? learningOutcomes,
    String? id,
  }) => TopicsLearningOutcome(
    title: title ?? this.title,
    learningOutcomes: learningOutcomes ?? this.learningOutcomes,
    id: id ?? this.id,
  );

  /// Converts the [TopicsLearningOutcome] to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'learningOutcomes': learningOutcomes == null
        ? <dynamic>[]
        : List<dynamic>.from(learningOutcomes!.map((String x) => x)),
    '_id': id,
  };
}

/// Represents a single message in the chat.
class Message {
  /// Creates a new instance of [Message].
  Message({this.question, this.answer, this.version, this.timestamp});

  /// Creates a [Message] object from a JSON object.
  factory Message.fromJson(Map<String, dynamic> json) => Message(
    question: json['question'],
    answer: json['answer'],
    version: json['version'],
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp']),
  );

  /// The question asked by the user.
  final String? question;

  /// The answer provided by the chatbot.
  final String? answer;

  /// The version of the message.
  final int? version;

  /// The timestamp of the message.
  final DateTime? timestamp;

  /// Creates a copy of the [Message] with the given fields replaced.
  Message copyWith({
    String? question,
    String? answer,
    int? version,
    DateTime? timestamp,
  }) => Message(
    question: question ?? this.question,
    answer: answer ?? this.answer,
    version: version ?? this.version,
    timestamp: timestamp ?? this.timestamp,
  );

  /// Converts the [Message] to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'question': question,
    'answer': answer,
    'version': version,
    'timestamp': timestamp?.toIso8601String(),
  };
}

/// Represents the subject of the lesson.
class Subject {
  /// Creates a new instance of [Subject].
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

  /// Creates a [Subject] object from a JSON object.
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

  /// The semester.
  final int? sem;

  /// The educational boards associated with the subject.
  final List<String>? boards;

  /// Indicates whether the subject is deleted.
  final bool? isDeleted;

  /// The timestamp when the subject was created.
  final DateTime? createdAt;

  /// The timestamp when the subject was last updated.
  final DateTime? updatedAt;

  /// The version number.
  final int? v;

  /// Creates a copy of the [Subject] with the given fields replaced.
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

  /// Converts the [Subject] to a JSON object.
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
