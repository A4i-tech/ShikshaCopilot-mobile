// To parse this JSON data, do
//
//     final lessonPlanModel = lessonPlanModelFromJson(jsonString);

import 'dart:convert';

/// Parses the JSON string and returns a [LessonPlanModel] object.
LessonPlanModel lessonPlanModelFromJson(String str) =>
    LessonPlanModel.fromJson(json.decode(str));

/// Converts a [LessonPlanModel] object to a JSON string.
String lessonPlanModelToJson(LessonPlanModel data) =>
    json.encode(data.toJson());

/// Represents the top-level response for the lesson plan API.
class LessonPlanModel {
  /// Creates a [LessonPlanModel] instance.
  LessonPlanModel({this.success, this.message, this.data});

  /// Creates a [LessonPlanModel] from a JSON object.
  factory LessonPlanModel.fromJson(Map<String, dynamic> json) =>
      LessonPlanModel(
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

  /// The main data payload of the response, containing a list of lesson plan data.
  final List<Datum>? data;

  /// Creates a copy of the instance with optional new values.
  LessonPlanModel copyWith({
    bool? success,
    String? message,
    List<Datum>? data,
  }) => LessonPlanModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data == null
        ? <dynamic>[]
        : List<dynamic>.from(data!.map((Datum x) => x.toJson())),
  };
}

/// Represents a single data entry in the lesson plan list, typically grouped by topic.
class Datum {
  /// Creates a [Datum] instance.
  Datum({this.id, this.subtopics});

  /// Creates a [Datum] instance from a JSON object.
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['_id'],
    subtopics: json['subtopics'] == null
        ? <Subtopic>[]
        : List<Subtopic>.from(
            json['subtopics']!.map((x) => Subtopic.fromJson(x)),
          ),
  );
  /// The unique identifier for the grouping, often the topic name.
  final String? id;

  /// A list of subtopics associated with this data entry.
  final List<Subtopic>? subtopics;

  /// Creates a copy of the instance with optional new values.
  Datum copyWith({String? id, List<Subtopic>? subtopics}) =>
      Datum(id: id ?? this.id, subtopics: subtopics ?? this.subtopics);

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subtopics': subtopics == null
        ? <dynamic>[]
        : List<dynamic>.from(subtopics!.map((Subtopic x) => x.toJson())),
  };
}

/// Represents a subtopic, which contains a list of lessons.
class Subtopic {
  /// Creates a [Subtopic] instance.
  Subtopic({this.subtopic, this.isAll, this.lessons});

  /// Creates a [Subtopic] instance from a JSON object.
  factory Subtopic.fromJson(Map<String, dynamic> json) => Subtopic(
    subtopic: json['subtopic'] == null
        ? <String>[]
        : List<String>.from(json['subtopic']!.map((x) => x)),
    isAll: json['isAll'],
    lessons: json['lessons'] == null
        ? <Lesson>[]
        : List<Lesson>.from(json['lessons']!.map((x) => Lesson.fromJson(x))),
  );
  /// The name(s) of the subtopic.
  final List<String>? subtopic;

  /// A flag indicating if this entry represents all subtopics.
  final bool? isAll;

  /// A list of lessons belonging to this subtopic.
  final List<Lesson>? lessons;

  /// Creates a copy of the instance with optional new values.
  Subtopic copyWith({
    List<String>? subtopic,
    bool? isAll,
    List<Lesson>? lessons,
  }) => Subtopic(
    subtopic: subtopic ?? this.subtopic,
    isAll: isAll ?? this.isAll,
    lessons: lessons ?? this.lessons,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'subtopic': subtopic == null
        ? <dynamic>[]
        : List<dynamic>.from(subtopic!.map((String x) => x)),
    'isAll': isAll,
    'lessons': lessons == null
        ? <dynamic>[]
        : List<dynamic>.from(lessons!.map((Lesson x) => x.toJson())),
  };
}

/// Represents a single lesson within a subtopic.
class Lesson {
  /// Creates a [Lesson] instance.
  Lesson({this.name, this.lessonId, this.isAll});

  /// Creates a [Lesson] instance from a JSON object.
  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    name: json['name'],
    lessonId: json['lessonId'],
    isAll: json['isAll'],
  );
  /// The name of the lesson.
  final String? name;

  /// The unique identifier for the lesson.
  final String? lessonId;

  /// A flag that may indicate if this represents all lessons.
  final bool? isAll;

  /// Creates a copy of the instance with optional new values.
  Lesson copyWith({String? name, String? lessonId, bool? isAll}) => Lesson(
    name: name ?? this.name,
    lessonId: lessonId ?? this.lessonId,
    isAll: isAll ?? this.isAll,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'lessonId': lessonId,
    'isAll': isAll,
  };
}
