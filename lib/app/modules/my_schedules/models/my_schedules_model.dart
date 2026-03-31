// To parse this JSON data, do
//
//     final mySchedules = mySchedulesFromJson(jsonString);

import 'dart:convert';

/// Deserializes a JSON string into a [MySchedules] object.
MySchedules mySchedulesFromJson(String str) =>
    MySchedules.fromJson(json.decode(str));

/// Serializes a [MySchedules] object into a JSON string.
String mySchedulesToJson(MySchedules data) => json.encode(data.toJson());

/// Represents a collection of schedules.
class MySchedules {
  /// Creates a new [MySchedules] instance.
  MySchedules({this.success, this.message, this.data});

  /// Creates a new [MySchedules] instance from a JSON map.
  factory MySchedules.fromJson(Map<String, dynamic> json) => MySchedules(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null
        ? <Datum>[]
        : List<Datum>.from(json['data']!.map((x) => Datum.fromJson(x))),
  );

  /// Indicates whether the request was successful.
  final bool? success;

  /// A message providing details about the request status.
  final String? message;

  /// A list of schedule data.
  final List<Datum>? data;

  /// Creates a copy of this [MySchedules] with the given fields replaced
  /// with the new values.
  MySchedules copyWith({bool? success, String? message, List<Datum>? data}) =>
      MySchedules(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  /// Converts this [MySchedules] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data == null
        ? <dynamic>[]
        : List<dynamic>.from(data!.map((Datum x) => x.toJson())),
  };
}

/// Represents a single schedule data item.
class Datum {
  /// Creates a new [Datum] instance.
  Datum({
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
    this.teacher,
    this.subjects,
  });

  /// Creates a new [Datum] instance from a JSON map.
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['_id'],
    teacherId: json['teacherId'],
    subject: json['subject'],
    schoolId: json['schoolId'],
    scheduleType: json['scheduleType'],
    isDeleted: json['isDeleted'],
    datumClass: json['class'],
    medium: mediumValues.map[json['medium']]!,
    board: boardValues.map[json['board']]!,
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
    teacher: json['teacher'] == null
        ? <Teacher>[]
        : List<Teacher>.from(json['teacher']!.map((x) => Teacher.fromJson(x))),
    subjects: json['subjects'] == null
        ? null
        : Subjects.fromJson(json['subjects']),
  );

  /// The unique identifier for the schedule data.
  final String? id;

  /// The ID of the teacher.
  final String? teacherId;

  /// The subject of the schedule.
  final String? subject;

  /// The ID of the school.
  final String? schoolId;

  /// The type of the schedule.
  final String? scheduleType;

  /// Indicates whether the schedule is deleted.
  final bool? isDeleted;

  /// The class for the schedule.
  final int? datumClass;

  /// The medium of the schedule.
  final Medium? medium;

  /// The board of the schedule.
  final Board? board;

  /// Other class information.
  final String? otherClass;

  /// The topic of the schedule.
  final String? topic;

  /// The sub-topic of the schedule.
  final String? subTopic;

  /// The ID of the lesson.
  final String? lessonId;

  /// The date and time of the schedule.
  final List<ScheduleDateTime>? scheduleDateTime;

  /// The date and time when the schedule was created.
  final DateTime? createdAt;

  /// The date and time when the schedule was last updated.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// The teacher associated with the schedule.
  final List<Teacher>? teacher;

  /// The subjects associated with the schedule.
  final Subjects? subjects;

  /// Creates a copy of this [Datum] with the given fields replaced
  /// with the new values.
  Datum copyWith({
    String? id,
    String? teacherId,
    String? subject,
    String? schoolId,
    String? scheduleType,
    bool? isDeleted,
    int? datumClass,
    Medium? medium,
    Board? board,
    String? otherClass,
    String? topic,
    String? subTopic,
    String? lessonId,
    List<ScheduleDateTime>? scheduleDateTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    List<Teacher>? teacher,
    Subjects? subjects,
  }) => Datum(
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
    teacher: teacher ?? this.teacher,
    subjects: subjects ?? this.subjects,
  );

  /// Converts this [Datum] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'teacherId': teacherId,
    'subject': subject,
    'schoolId': schoolId,
    'scheduleType': scheduleType,
    'isDeleted': isDeleted,
    'class': datumClass,
    'medium': mediumValues.reverse[medium],
    'board': boardValues.reverse[board],
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
    'teacher': teacher == null
        ? <dynamic>[]
        : List<dynamic>.from(teacher!.map((Teacher x) => x.toJson())),
    'subjects': subjects?.toJson(),
  };
}

/// Represents the board.
enum Board {
  /// Karnataka Secondary Education Examination Board.
  KSEEB,
}

/// A map of board values.
final EnumValues<Board> boardValues = EnumValues(<String, Board>{
  'KSEEB': Board.KSEEB,
});

/// Represents the medium of instruction.
enum Medium {
  /// English medium.
  ENGLISH,
}

/// A map of medium values.
final EnumValues<Medium> mediumValues = EnumValues(<String, Medium>{
  'english': Medium.ENGLISH,
});

/// Represents the date and time of a schedule.
class ScheduleDateTime {
  /// Creates a new [ScheduleDateTime] instance.
  ScheduleDateTime({this.date, this.fromTime, this.toTime, this.id});

  /// Creates a new [ScheduleDateTime] instance from a JSON map.
  factory ScheduleDateTime.fromJson(Map<String, dynamic> json) =>
      ScheduleDateTime(
        date: json['date'] == null ? null : DateTime.parse(json['date']),
        fromTime: json['fromTime'],
        toTime: json['toTime'],
        id: json['_id'],
      );

  /// The date of the schedule.
  final DateTime? date;

  /// The start time of the schedule.
  final String? fromTime;

  /// The end time of the schedule.
  final String? toTime;

  /// The unique identifier for the schedule date and time.
  final String? id;

  /// Creates a copy of this [ScheduleDateTime] with the given fields replaced
  /// with the new values.
  ScheduleDateTime copyWith({
    DateTime? date,
    String? fromTime,
    String? toTime,
    String? id,
  }) => ScheduleDateTime(
    date: date ?? this.date,
    fromTime: fromTime ?? this.fromTime,
    toTime: toTime ?? this.toTime,
    id: id ?? this.id,
  );

  /// Converts this [ScheduleDateTime] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'date': date?.toIso8601String().split('T').first,
    'fromTime': fromTime,
    'toTime': toTime,
    if (id != null) '_id': id,
  };
}

/// Represents a subject.
class Subjects {
  /// Creates a new [Subjects] instance.
  Subjects({
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

  /// Creates a new [Subjects] instance from a JSON map.
  factory Subjects.fromJson(Map<String, dynamic> json) => Subjects(
    id: json['_id'],
    subjectName: json['subjectName'],
    name: nameValues.map[json['name']]!,
    sem: json['sem'],
    boards: json['boards'] == null
        ? <Board>[]
        : List<Board>.from(json['boards']!.map((x) => boardValues.map[x]!)),
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

  /// The name of the subject.
  final Name? name;

  /// The semester of the subject.
  final int? sem;

  /// A list of boards for the subject.
  final List<Board>? boards;

  /// Indicates whether the subject is deleted.
  final bool? isDeleted;

  /// The date and time when the subject was created.
  final DateTime? createdAt;

  /// The date and time when the subject was last updated.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// Creates a copy of this [Subjects] with the given fields replaced
  /// with the new values.
  Subjects copyWith({
    String? id,
    String? subjectName,
    Name? name,
    int? sem,
    List<Board>? boards,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Subjects(
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

  /// Converts this [Subjects] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subjectName': subjectName,
    'name': nameValues.reverse[name],
    'sem': sem,
    'boards': boards == null
        ? <dynamic>[]
        : List<dynamic>.from(boards!.map((Board x) => boardValues.reverse[x])),
    'isDeleted': isDeleted,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

/// Represents the name of a subject.
enum Name {
  /// Environmental Science.
  EVS,

  /// Science.
  SCIENCE,
}

/// A map of subject name values.
final EnumValues<Name> nameValues = EnumValues(<String, Name>{
  'Evs': Name.EVS,
  'Science': Name.SCIENCE,
});

/// Represents a teacher.
class Teacher {
  /// Creates a new [Teacher] instance.
  Teacher({
    this.id,
    this.name,
    this.state,
    this.zone,
    this.district,
    this.block,
    this.phone,
    this.role,
    this.school,
    this.preferredLanguage,
    this.facilities,
    this.isProfileCompleted,
    this.profileImage,
    this.profileImageExpiresIn,
    this.isDeleted,
    this.rememberMeToken,
    this.isLoginAllowed,
    this.classes,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.otp,
  });

  /// Creates a new [Teacher] instance from a JSON map.
  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json['_id'],
    name: json['name'],
    state: json['state'],
    zone: json['zone'],
    district: json['district'],
    block: json['block'],
    phone: json['phone'],
    role: json['role'] == null
        ? <String>[]
        : List<String>.from(json['role']!.map((x) => x)),
    school: json['school'],
    preferredLanguage: json['preferredLanguage'],
    facilities: json['facilities'] == null
        ? <Facility>[]
        : List<Facility>.from(
            json['facilities']!.map((x) => Facility.fromJson(x)),
          ),
    isProfileCompleted: json['isProfileCompleted'],
    profileImage: json['profileImage'],
    profileImageExpiresIn: json['profileImageExpiresIn'],
    isDeleted: json['isDeleted'],
    rememberMeToken: json['rememberMeToken'],
    isLoginAllowed: json['isLoginAllowed'],
    classes: json['classes'] == null
        ? <Class>[]
        : List<Class>.from(json['classes']!.map((x) => Class.fromJson(x))),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
    otp: json['otp'],
  );

  /// The unique identifier for the teacher.
  final String? id;

  /// The name of the teacher.
  final String? name;

  /// The state of the teacher.
  final String? state;

  /// The zone of the teacher.
  final String? zone;

  /// The district of the teacher.
  final String? district;

  /// The block of the teacher.
  final String? block;

  /// The phone number of the teacher.
  final String? phone;

  /// The role of the teacher.
  final List<String>? role;

  /// The school of the teacher.
  final String? school;

  /// The preferred language of the teacher.
  final String? preferredLanguage;

  /// The facilities available to the teacher.
  final List<Facility>? facilities;

  /// Indicates whether the teacher's profile is complete.
  final bool? isProfileCompleted;

  /// The profile image of the teacher.
  final String? profileImage;

  /// The expiration time of the profile image.
  final int? profileImageExpiresIn;

  /// Indicates whether the teacher is deleted.
  final bool? isDeleted;

  /// The remember me token for the teacher.
  final bool? rememberMeToken;

  /// Indicates whether login is allowed for the teacher.
  final bool? isLoginAllowed;

  /// The classes taught by the teacher.
  final List<Class>? classes;

  /// The date and time when the teacher was created.
  final DateTime? createdAt;

  /// The date and time when the teacher was last updated.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// The one-time password for the teacher.
  final String? otp;

  /// Creates a copy of this [Teacher] with the given fields replaced
  /// with the new values.
  Teacher copyWith({
    String? id,
    String? name,
    String? state,
    String? zone,
    String? district,
    String? block,
    String? phone,
    List<String>? role,
    String? school,
    String? preferredLanguage,
    List<Facility>? facilities,
    bool? isProfileCompleted,
    String? profileImage,
    int? profileImageExpiresIn,
    bool? isDeleted,
    bool? rememberMeToken,
    bool? isLoginAllowed,
    List<Class>? classes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? otp,
  }) => Teacher(
    id: id ?? this.id,
    name: name ?? this.name,
    state: state ?? this.state,
    zone: zone ?? this.zone,
    district: district ?? this.district,
    block: block ?? this.block,
    phone: phone ?? this.phone,
    role: role ?? this.role,
    school: school ?? this.school,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    facilities: facilities ?? this.facilities,
    isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
    profileImage: profileImage ?? this.profileImage,
    profileImageExpiresIn: profileImageExpiresIn ?? this.profileImageExpiresIn,
    isDeleted: isDeleted ?? this.isDeleted,
    rememberMeToken: rememberMeToken ?? this.rememberMeToken,
    isLoginAllowed: isLoginAllowed ?? this.isLoginAllowed,
    classes: classes ?? this.classes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    otp: otp ?? this.otp,
  );

  /// Converts this [Teacher] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'state': state,
    'zone': zone,
    'district': district,
    'block': block,
    'phone': phone,
    'role': role == null
        ? <dynamic>[]
        : List<dynamic>.from(role!.map((String x) => x)),
    'school': school,
    'preferredLanguage': preferredLanguage,
    'facilities': facilities == null
        ? <dynamic>[]
        : List<dynamic>.from(facilities!.map((Facility x) => x.toJson())),
    'isProfileCompleted': isProfileCompleted,
    'profileImage': profileImage,
    'profileImageExpiresIn': profileImageExpiresIn,
    'isDeleted': isDeleted,
    'rememberMeToken': rememberMeToken,
    'isLoginAllowed': isLoginAllowed,
    'classes': classes == null
        ? <dynamic>[]
        : List<dynamic>.from(classes!.map((Class x) => x.toJson())),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'otp': otp,
  };
}

/// Represents a class.
class Class {
  /// Creates a new [Class] instance.
  Class({
    this.board,
    this.classClass,
    this.medium,
    this.subject,
    this.name,
    this.sem,
    this.id,
  });

  /// Creates a new [Class] instance from a JSON map.
  factory Class.fromJson(Map<String, dynamic> json) => Class(
    board: json['board'],
    classClass: json['class'],
    medium: json['medium'],
    subject: json['subject'],
    name: json['name'],
    sem: json['sem'],
    id: json['_id'],
  );

  /// The board of the class.
  final String? board;

  /// The class number.
  final int? classClass;

  /// The medium of the class.
  final String? medium;

  /// The subject of the class.
  final String? subject;

  /// The name of the class.
  final String? name;

  /// The semester of the class.
  final int? sem;

  /// The unique identifier for the class.
  final String? id;

  /// Creates a copy of this [Class] with the given fields replaced
  /// with the new values.
  Class copyWith({
    String? board,
    int? classClass,
    String? medium,
    String? subject,
    String? name,
    int? sem,
    String? id,
  }) => Class(
    board: board ?? this.board,
    classClass: classClass ?? this.classClass,
    medium: medium ?? this.medium,
    subject: subject ?? this.subject,
    name: name ?? this.name,
    sem: sem ?? this.sem,
    id: id ?? this.id,
  );

  /// Converts this [Class] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'board': board,
    'class': classClass,
    'medium': medium,
    'subject': subject,
    'name': name,
    'sem': sem,
    '_id': id,
  };
}

/// Represents a facility.
class Facility {
  /// Creates a new [Facility] instance.
  Facility({
    this.type,
    this.details,
    this.otherType,
    this.typeChipSet,
    this.detailsChipSet,
  });

  /// Creates a new [Facility] instance from a JSON map.
  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
    type: json['type'],
    details: json['details'] == null
        ? <String>[]
        : List<String>.from(json['details']!.map((x) => x)),
    otherType: json['otherType'],
    typeChipSet: json['typeChipSet'],
    detailsChipSet: json['detailsChipSet'],
  );

  /// The type of the facility.
  final String? type;

  /// Details about the facility.
  final List<String>? details;

  /// Other type of facility.
  final String? otherType;

  /// The type chip set for the facility.
  final bool? typeChipSet;

  /// The details chip set for the facility.
  final bool? detailsChipSet;

  /// Creates a copy of this [Facility] with the given fields replaced
  /// with the new values.
  Facility copyWith({
    String? type,
    List<String>? details,
    String? otherType,
    bool? typeChipSet,
    bool? detailsChipSet,
  }) => Facility(
    type: type ?? this.type,
    details: details ?? this.details,
    otherType: otherType ?? this.otherType,
    typeChipSet: typeChipSet ?? this.typeChipSet,
    detailsChipSet: detailsChipSet ?? this.detailsChipSet,
  );

  /// Converts this [Facility] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'details': details == null
        ? <dynamic>[]
        : List<dynamic>.from(details!.map((String x) => x)),
    'otherType': otherType,
    'typeChipSet': typeChipSet,
    'detailsChipSet': detailsChipSet,
  };
}

/// A utility class for mapping enum values.
class EnumValues<T> {
  /// Creates a new [EnumValues] instance.
  EnumValues(this.map);

  /// The map of enum values.
  Map<String, T> map;

  /// The reverse map of enum values.
  late Map<T, String> reverseMap;

  /// Returns the reverse map of enum values.
  Map<T, String> get reverse {
    reverseMap = map.map((String k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
