// To parse this JSON data, do
//
//     final createSchedule = createScheduleFromJson(jsonString);

import 'dart:convert';

import 'package:sikshana/app/modules/my_schedules/models/my_schedules_model.dart';

/// Parses the JSON string and returns a [CreateSchedule] object.
CreateSchedule createScheduleFromJson(String str) =>
    CreateSchedule.fromJson(json.decode(str));

/// Converts a [CreateSchedule] object to a JSON string.
String createScheduleToJson(CreateSchedule data) => json.encode(data.toJson());

/// Represents the response from the API after creating or updating a schedule.
class CreateSchedule {
  /// Creates a [CreateSchedule] instance.
  CreateSchedule({this.success, this.message, this.data});

  /// Creates a [CreateSchedule] from a JSON object.
  factory CreateSchedule.fromJson(Map<String, dynamic> json) => CreateSchedule(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
  );

  /// Indicates if the API call was successful.
  final bool? success;

  /// A message from the API, such as "Schedule created successfully".
  final String? message;

  /// The data payload containing the details of the created/updated schedule.
  final Data? data;

  /// Creates a copy of the instance with optional new values.
  CreateSchedule copyWith({bool? success, String? message, Data? data}) =>
      CreateSchedule(
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

/// Represents the detailed data of a single schedule.
class Data {
  /// Creates a [Data] instance.
  Data({
    this.teacherId,
    this.subject,
    this.schoolId,
    this.scheduleType,
    this.isDeleted,
    this.dataClass,
    this.medium,
    this.board,
    this.otherClass,
    this.topic,
    this.subTopic,
    this.lessonId,
    this.scheduleDateTime,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Creates a [Data] instance from a JSON object.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    teacherId: json['teacherId'],
    subject: json['subject'],
    schoolId: json['schoolId'],
    scheduleType: json['scheduleType'],
    isDeleted: json['isDeleted'],
    dataClass: json['class'],
    medium: json['medium'],
    board: json['board'],
    otherClass: json['otherClass'],
    topic: json['topic'],
    subTopic: json['subTopic'],
    lessonId: json['lessonId'],
    scheduleDateTime: json['scheduleDateTime'] == null
        ? <ScheduleDateTime>[]
        : List<ScheduleDateTime>.from(
            json['scheduleDateTime']!.map((x) => ScheduleDateTime.fromJson(x)),
          ),
    id: json['_id'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The ID of the teacher associated with this schedule.
  final String? teacherId;

  /// The subject of the scheduled class.
  final String? subject;

  /// The ID of the school where the class is scheduled.
  final String? schoolId;

  /// The type of schedule (e.g., "regular").
  final String? scheduleType;

  /// A flag indicating if the schedule is deleted.
  final bool? isDeleted;

  /// The class/grade level for the schedule.
  final int? dataClass;

  /// The medium of instruction.
  final String? medium;

  /// The educational board.
  final String? board;

  /// A field for any other class information.
  final String? otherClass;

  /// The main topic or chapter for the lesson.
  final String? topic;

  /// The specific sub-topic to be covered.
  final String? subTopic;

  /// The ID of the associated lesson plan.
  final String? lessonId;

  /// A list of date and time details for this schedule.
  final List<ScheduleDateTime>? scheduleDateTime;

  /// The unique identifier for the schedule.
  final String? id;

  /// The timestamp when the schedule was created.
  final DateTime? createdAt;

  /// The timestamp when the schedule was last updated.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// Creates a copy of the instance with optional new values.
  Data copyWith({
    String? teacherId,
    String? subject,
    String? schoolId,
    String? scheduleType,
    bool? isDeleted,
    int? dataClass,
    String? medium,
    String? board,
    String? otherClass,
    String? topic,
    String? subTopic,
    String? lessonId,
    List<ScheduleDateTime>? scheduleDateTime,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    // Note: The 'lesson' field from the original JSON is handled separately
    // and is not a direct property of this generated class.
  }) => Data(
    teacherId: teacherId ?? this.teacherId,
    subject: subject ?? this.subject,
    schoolId: schoolId ?? this.schoolId,
    scheduleType: scheduleType ?? this.scheduleType,
    isDeleted: isDeleted ?? this.isDeleted,
    dataClass: dataClass ?? this.dataClass,
    medium: medium ?? this.medium,
    board: board ?? this.board,
    otherClass: otherClass ?? this.otherClass,
    topic: topic ?? this.topic,
    subTopic: subTopic ?? this.subTopic,
    lessonId: lessonId ?? this.lessonId,
    scheduleDateTime: scheduleDateTime ?? this.scheduleDateTime,
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'teacherId': teacherId,
    'subject': subject,
    'schoolId': schoolId,
    'scheduleType': scheduleType,
    'isDeleted': isDeleted,
    'class': dataClass,
    'medium': medium,
    'board': board,
    'otherClass': otherClass,
    'topic': topic,
    'subTopic': subTopic,
    'lessonId': lessonId,
    'scheduleDateTime': scheduleDateTime == null
        ? <dynamic>[]
        : List<dynamic>.from(
            scheduleDateTime!.map((ScheduleDateTime x) => x.toJson()),
          ),
    '_id': id,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}
