// To parse this JSON data, do
//
//     final mySchedules = mySchedulesFromJson(jsonString);

import 'dart:convert';

import 'package:sikshana/app/modules/my_schedules/models/my_schedules_model.dart';

/// Parses the JSON string and returns a [MySchedules] object.
MySchedules mySchedulesFromJson(String str) =>
    MySchedules.fromJson(json.decode(str));

/// Converts a [MySchedules] object to a JSON string.
String mySchedulesToJson(MySchedules data) => json.encode(data.toJson());

/// Represents the top-level response for the get schedules API.
class MySchedules {
  /// Creates a [MySchedules] instance.
  MySchedules({this.success, this.message, this.data});

  /// Creates a [MySchedules] instance from a JSON object.
  factory MySchedules.fromJson(Map<String, dynamic> json) => MySchedules(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null
        ? <Schedules>[]
        : List<Schedules>.from(json['data']!.map((x) => Schedules.fromJson(x))),
  );

  /// Indicates if the API call was successful.
  final bool? success;

  /// A message from the API.
  final String? message;

  /// The main data payload of the response, containing a list of schedules.
  final List<Schedules>? data;

  /// Creates a copy of the instance with optional new values.
  MySchedules copyWith({
    bool? success,
    String? message,
    List<Schedules>? data,
  }) => MySchedules(
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
        : List<dynamic>.from(data!.map((Schedules x) => x.toJson())),
  };
}

/// Represents a single schedule item with its associated details.
class Schedules {
  /// Creates a [Schedules] instance.
  Schedules({
    this.id,
    this.teacherId,
    this.subject,
    this.schoolId,
    this.scheduleType,
    this.isDeleted,
    this.datumClass,
    this.medium,
    this.board,
    this.otherClass,
    this.topic,
    this.subTopic,
    this.lessonId,
    this.scheduleDateTime,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lesson,
    this.teacher,
  });

  /// Creates a [Schedules] instance from a JSON object.
  factory Schedules.fromJson(Map<String, dynamic> json) => Schedules(
    id: json['_id'],
    teacherId: json['teacherId'],
    subject: json['subject'],
    schoolId: json['schoolId'],
    scheduleType: json['scheduleType'],
    isDeleted: json['isDeleted'],
    datumClass: json['class'],
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
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
    lesson: json['lesson'] == null ? null : Lesson.fromJson(json['lesson']),
    teacher: json['teacher'] == null ? null : Teacher.fromJson(json['teacher']),
  );

  /// The unique identifier for the schedule.
  final String? id;

  /// The ID of the teacher for the schedule.
  final String? teacherId;

  /// The subject of the class.
  final String? subject;

  /// The ID of the school.
  final String? schoolId;

  /// The type of schedule (e.g., 'regular').
  final String? scheduleType;

  /// Flag indicating if the schedule is deleted.
  final bool? isDeleted;

  /// The class/grade for the schedule.
  final int? datumClass;

  /// The medium of instruction.
  final String? medium;

  /// The educational board.
  final String? board;

  /// Field for other class information.
  final String? otherClass;

  /// The main topic of the lesson.
  final String? topic;

  /// The sub-topic of the lesson.
  final String? subTopic;

  /// The ID of the associated lesson plan.
  final String? lessonId;

  /// A list of date and time instances for this schedule.
  final List<ScheduleDateTime>? scheduleDateTime;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// The associated lesson details.
  final Lesson? lesson;

  /// The associated teacher details.
  final Teacher? teacher;

  /// Creates a copy of the instance with optional new values.
  Schedules copyWith({
    String? id,
    String? teacherId,
    String? subject,
    String? schoolId,
    String? scheduleType,
    bool? isDeleted,
    int? datumClass,
    String? medium,
    String? board,
    String? otherClass,
    String? topic,
    String? subTopic,
    String? lessonId,
    List<ScheduleDateTime>? scheduleDateTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    Lesson? lesson,
    Teacher? teacher,
  }) => Schedules(
    id: id ?? this.id,
    teacherId: teacherId ?? this.teacherId,
    subject: subject ?? this.subject,
    schoolId: schoolId ?? this.schoolId,
    scheduleType: scheduleType ?? this.scheduleType,
    isDeleted: isDeleted ?? this.isDeleted,
    datumClass: datumClass ?? this.datumClass,
    medium: medium ?? this.medium,
    board: board ?? this.board,
    otherClass: otherClass ?? this.otherClass,
    topic: topic ?? this.topic,
    subTopic: subTopic ?? this.subTopic,
    lessonId: lessonId ?? this.lessonId,
    scheduleDateTime: scheduleDateTime ?? this.scheduleDateTime,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    lesson: lesson ?? this.lesson,
    teacher: teacher ?? this.teacher,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'teacherId': teacherId,
    'subject': subject,
    'schoolId': schoolId,
    'scheduleType': scheduleType,
    'isDeleted': isDeleted,
    'class': datumClass,
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
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'lesson': lesson?.toJson(),
    'teacher': teacher?.toJson(),
  };
}

/// Represents the lesson details associated with a schedule.
class Lesson {
  /// Creates a [Lesson] instance.
  Lesson({this.id, this.name, this.subjects});

  /// Creates a [Lesson] instance from a JSON object.
  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['_id'],
    name: json['name'],
    subjects: json['subjects'] == null
        ? null
        : Subjects.fromJson(json['subjects']),
  );

  /// The unique identifier for the lesson.
  final String? id;

  /// The name of the lesson.
  final String? name;

  /// The subject details for the lesson.
  final Subjects? subjects;

  /// Creates a copy of the instance with optional new values.
  Lesson copyWith({String? id, String? name, Subjects? subjects}) => Lesson(
    id: id ?? this.id,
    name: name ?? this.name,
    subjects: subjects ?? this.subjects,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'subjects': subjects?.toJson(),
  };
}

/// Represents the subject details within a lesson.
class Subjects {
  /// Creates a [Subjects] instance.
  Subjects({this.name, this.sem});

  /// Creates a [Subjects] instance from a JSON object.
  factory Subjects.fromJson(Map<String, dynamic> json) =>
      Subjects(name: json['name'], sem: json['sem']);

  /// The name of the subject.
  final String? name;

  /// The semester number.
  final int? sem;

  /// Creates a copy of the instance with optional new values.
  Subjects copyWith({String? name, int? sem}) =>
      Subjects(name: name ?? this.name, sem: sem ?? this.sem);

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'sem': sem};
}

/// Represents the teacher details associated with a schedule.
class Teacher {
  /// Creates a [Teacher] instance.
  Teacher({this.id, this.name, this.role, this.profileImage});

  /// Creates a [Teacher] instance from a JSON object.
  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json['_id'],
    name: json['name'],
    role: json['role'] == null
        ? <String>[]
        : List<String>.from(json['role']!.map((x) => x)),
    profileImage: json['profileImage'],
  );

  /// The unique identifier for the teacher.
  final String? id;

  /// The name of the teacher.
  final String? name;

  /// A list of roles for the teacher.
  final List<String>? role;

  /// The URL of the teacher's profile image.
  final String? profileImage;

  /// Creates a copy of the instance with optional new values.
  Teacher copyWith({
    String? id,
    String? name,
    List<String>? role,
    String? profileImage,
  }) => Teacher(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role ?? this.role,
    profileImage: profileImage ?? this.profileImage,
  );

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'role': role == null
        ? <dynamic>[]
        : List<dynamic>.from(role!.map((String x) => x)),
    'profileImage': profileImage,
  };
}
