// To parse this JSON data, do
//
//     final scheduleById = scheduleByIdFromJson(jsonString);

import 'dart:convert';

import 'package:sikshana/app/modules/my_schedules/models/my_schedules_model.dart';

/// Parses a JSON string into a [ScheduleById] object.
///
/// Takes a JSON [str] and returns a [ScheduleById] instance.
ScheduleById scheduleByIdFromJson(String str) =>
    ScheduleById.fromJson(json.decode(str));

/// Converts a [ScheduleById] object to a JSON string.
///
/// Takes a [ScheduleById] [data] object and returns its JSON string representation.
String scheduleByIdToJson(ScheduleById data) => json.encode(data.toJson());

/// Represents the response structure for fetching a schedule by ID.
///
/// Contains the API response with success status, message, and schedule data.
class ScheduleById {
  /// Creates a [ScheduleById] instance.
  ///
  /// All parameters are optional and nullable.
  ScheduleById({this.success, this.message, this.data});

  /// Creates a [ScheduleById] instance from a JSON map.
  ///
  /// Parses the [json] map and converts it into a [ScheduleById] object.
  factory ScheduleById.fromJson(Map<String, dynamic> json) => ScheduleById(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
  );

  /// Indicates whether the API request was successful.
  final bool? success;

  /// Contains the response message from the API.
  final String? message;

  /// Contains the schedule data returned from the API.
  final Data? data;

  /// Creates a copy of this [ScheduleById] with optional parameter overrides.
  ///
  /// Returns a new [ScheduleById] instance with the specified parameters replaced.
  /// If a parameter is null, the original value is retained.
  ScheduleById copyWith({bool? success, String? message, Data? data}) =>
      ScheduleById(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  /// Converts this [ScheduleById] instance to a JSON map.
  ///
  /// Returns a map representation of this object for JSON encoding.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

/// Represents the detailed schedule data.
///
/// Contains all information about a schedule including teacher details,
/// subject information, class details, and associated lesson plans.
class Data {
  /// Creates a [Data] instance.
  ///
  /// All parameters are optional and nullable.
  Data({
    this.id,
    this.teacherId,
    this.subject,
    this.scheduleType,
    this.isDeleted,
    this.dataClass,
    this.medium,
    this.board,
    this.otherClass,
    this.topic,
    this.subTopic,
    this.scheduleDateTime,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lesson,
  });

  /// Creates a [Data] instance from a JSON map.
  ///
  /// Parses the [json] map and converts it into a [Data] object.
  /// Handles nested objects and arrays appropriately.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['_id'],
    teacherId: json['teacherId'],
    subject: json['subject'],
    scheduleType: json['scheduleType'],
    isDeleted: json['isDeleted'],
    dataClass: json['class'],
    medium: json['medium'],
    board: json['board'],
    otherClass: json['otherClass'],
    topic: json['topic'],
    subTopic: json['subTopic'],
    scheduleDateTime: json['scheduleDateTime'] == null
        ? <ScheduleDateTime>[]
        : List<ScheduleDateTime>.from(
            json['scheduleDateTime']!.map((x) => ScheduleDateTime.fromJson(x)),
          ),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
    lesson: json['lesson'] == null ? null : Lesson.fromJson(json['lesson']),
  );

  /// Unique identifier for the schedule.
  final String? id;

  /// Identifier of the teacher who created the schedule.
  final String? teacherId;

  /// Subject name for the schedule.
  final String? subject;

  /// Type of schedule (e.g., regular, special, makeup).
  final String? scheduleType;

  /// Indicates whether the schedule has been soft-deleted.
  final bool? isDeleted;

  /// Class/grade number for the schedule.
  final int? dataClass;

  /// Medium of instruction (e.g., English, Hindi).
  final String? medium;

  /// Educational board (e.g., CBSE, ICSE, State Board).
  final String? board;

  /// Additional class information if not standard.
  final String? otherClass;

  /// Main topic being covered in the schedule.
  final String? topic;

  /// Subtopic being covered in the schedule.
  final String? subTopic;

  /// List of scheduled date and time slots for this schedule.
  final List<ScheduleDateTime>? scheduleDateTime;

  /// Timestamp when the schedule was created.
  final DateTime? createdAt;

  /// Timestamp when the schedule was last updated.
  final DateTime? updatedAt;

  /// Version number for MongoDB document versioning.
  final int? v;

  /// Associated lesson plan details.
  final Lesson? lesson;

  /// Creates a copy of this [Data] with optional parameter overrides.
  ///
  /// Returns a new [Data] instance with the specified parameters replaced.
  /// If a parameter is null, the original value is retained.
  Data copyWith({
    String? id,
    String? teacherId,
    String? subject,
    String? scheduleType,
    bool? isDeleted,
    int? dataClass,
    String? medium,
    String? board,
    String? otherClass,
    String? topic,
    String? subTopic,
    List<ScheduleDateTime>? scheduleDateTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    Lesson? lesson,
  }) => Data(
    id: id ?? this.id,
    teacherId: teacherId ?? this.teacherId,
    subject: subject ?? this.subject,
    scheduleType: scheduleType ?? this.scheduleType,
    isDeleted: isDeleted ?? this.isDeleted,
    dataClass: dataClass ?? this.dataClass,
    medium: medium ?? this.medium,
    board: board ?? this.board,
    otherClass: otherClass ?? this.otherClass,
    topic: topic ?? this.topic,
    subTopic: subTopic ?? this.subTopic,
    scheduleDateTime: scheduleDateTime ?? this.scheduleDateTime,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    lesson: lesson ?? this.lesson,
  );

  /// Converts this [Data] instance to a JSON map.
  ///
  /// Returns a map representation of this object for JSON encoding.
  /// Handles nested objects and arrays appropriately.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'teacherId': teacherId,
    'subject': subject,
    'scheduleType': scheduleType,
    'isDeleted': isDeleted,
    'class': dataClass,
    'medium': medium,
    'board': board,
    'otherClass': otherClass,
    'topic': topic,
    'subTopic': subTopic,
    'scheduleDateTime': scheduleDateTime == null
        ? <dynamic>[]
        : List<dynamic>.from(
            scheduleDateTime!.map((ScheduleDateTime x) => x.toJson()),
          ),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'lesson': lesson?.toJson(),
  };
}

/// Represents a lesson plan associated with a schedule.
///
/// Contains information about the lesson including its name,
/// associated chapter, and subject details.
class Lesson {
  /// Creates a [Lesson] instance.
  ///
  /// All parameters are optional and nullable.
  Lesson({this.id, this.name, this.chapter, this.subjects});

  /// Creates a [Lesson] instance from a JSON map.
  ///
  /// Parses the [json] map and converts it into a [Lesson] object.
  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['_id'],
    name: json['name'],
    chapter: json['chapter'] == null ? null : Chapter.fromJson(json['chapter']),
    subjects: json['subjects'] == null
        ? null
        : Subjects.fromJson(json['subjects']),
  );

  /// Unique identifier for the lesson.
  final String? id;

  /// Name/title of the lesson.
  final String? name;

  /// Chapter information associated with this lesson.
  final Chapter? chapter;

  /// Subject details for this lesson.
  final Subjects? subjects;

  /// Creates a copy of this [Lesson] with optional parameter overrides.
  ///
  /// Returns a new [Lesson] instance with the specified parameters replaced.
  /// If a parameter is null, the original value is retained.
  Lesson copyWith({
    String? id,
    String? name,
    Chapter? chapter,
    Subjects? subjects,
  }) => Lesson(
    id: id ?? this.id,
    name: name ?? this.name,
    chapter: chapter ?? this.chapter,
    subjects: subjects ?? this.subjects,
  );

  /// Converts this [Lesson] instance to a JSON map.
  ///
  /// Returns a map representation of this object for JSON encoding.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'chapter': chapter?.toJson(),
    'subjects': subjects?.toJson(),
  };
}

/// Represents a chapter within a curriculum.
///
/// Contains chapter details including topics covered and ordering information.
class Chapter {
  /// Creates a [Chapter] instance.
  ///
  /// All parameters are optional and nullable.
  Chapter({this.id, this.topics, this.orderNumber});

  /// Creates a [Chapter] instance from a JSON map.
  ///
  /// Parses the [json] map and converts it into a [Chapter] object.
  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json['_id'],
    topics: json['topics'],
    orderNumber: json['orderNumber'],
  );

  /// Unique identifier for the chapter.
  final String? id;

  /// Topics covered in this chapter.
  final String? topics;

  /// Sequential order number of the chapter in the curriculum.
  final int? orderNumber;

  /// Creates a copy of this [Chapter] with optional parameter overrides.
  ///
  /// Returns a new [Chapter] instance with the specified parameters replaced.
  /// If a parameter is null, the original value is retained.
  Chapter copyWith({String? id, String? topics, int? orderNumber}) => Chapter(
    id: id ?? this.id,
    topics: topics ?? this.topics,
    orderNumber: orderNumber ?? this.orderNumber,
  );

  /// Converts this [Chapter] instance to a JSON map.
  ///
  /// Returns a map representation of this object for JSON encoding.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'topics': topics,
    'orderNumber': orderNumber,
  };
}

/// Represents subject information.
///
/// Contains the subject name and semester details.
class Subjects {
  /// Creates a [Subjects] instance.
  ///
  /// All parameters are optional and nullable.
  Subjects({this.name, this.sem});

  /// Creates a [Subjects] instance from a JSON map.
  ///
  /// Parses the [json] map and converts it into a [Subjects] object.
  factory Subjects.fromJson(Map<String, dynamic> json) =>
      Subjects(name: json['name'], sem: json['sem']);

  /// Name of the subject (e.g., Mathematics, Science, English).
  final String? name;

  /// Semester number for the subject.
  final int? sem;

  /// Creates a copy of this [Subjects] with optional parameter overrides.
  ///
  /// Returns a new [Subjects] instance with the specified parameters replaced.
  /// If a parameter is null, the original value is retained.
  Subjects copyWith({String? name, int? sem}) =>
      Subjects(name: name ?? this.name, sem: sem ?? this.sem);

  /// Converts this [Subjects] instance to a JSON map.
  ///
  /// Returns a map representation of this object for JSON encoding.
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'sem': sem};
}
