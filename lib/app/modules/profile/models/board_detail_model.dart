// To parse this JSON data, do
//
//     final boardDetailModel = boardDetailModelFromJson(jsonString);

import 'dart:convert';

/// Parses a JSON string into a [BoardDetailModel] object.
BoardDetailModel boardDetailModelFromJson(String str) =>
    BoardDetailModel.fromJson(json.decode(str));

/// Converts a [BoardDetailModel] object to a JSON string.
String boardDetailModelToJson(BoardDetailModel data) =>
    json.encode(data.toJson());

/// Represents the model for board details.
class BoardDetailModel {
  /// Constructs a [BoardDetailModel].
  BoardDetailModel({this.success, this.message, this.data});

  /// Factory constructor to create a [BoardDetailModel] from JSON.
  factory BoardDetailModel.fromJson(Map<String, dynamic> json) =>
      BoardDetailModel(
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

  /// The list of board data.
  final List<Datum>? data;

  /// Creates a copy of this [BoardDetailModel] with optional new values.
  BoardDetailModel copyWith({
    bool? success,
    String? message,
    List<Datum>? data,
  }) => BoardDetailModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  /// Converts this [BoardDetailModel] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data == null
        ? <dynamic>[]
        : List<dynamic>.from(data!.map((Datum x) => x.toJson())),
  };
}

/// Represents a single board data item.
class Datum {
  /// Constructs a [Datum].
  Datum({this.id, this.medium, this.subjects});

  /// Factory constructor to create a [Datum] from JSON.
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['_id'],
    medium: json['medium'] == null
        ? <Medium>[]
        : List<Medium>.from(json['medium']!.map((x) => Medium.fromJson(x))),
    subjects: json['subjects'] == null
        ? <DatumSubject>[]
        : List<DatumSubject>.from(
            json['subjects']!.map((x) => DatumSubject.fromJson(x)),
          ),
  );

  /// The unique identifier of the board.
  final String? id;

  /// The list of mediums available for this board.
  final List<Medium>? medium;

  /// The list of subjects available for this board.
  final List<DatumSubject>? subjects;

  /// Creates a copy of this [Datum] with optional new values.
  Datum copyWith({
    String? id,
    List<Medium>? medium,
    List<DatumSubject>? subjects,
  }) => Datum(
    id: id ?? this.id,
    medium: medium ?? this.medium,
    subjects: subjects ?? this.subjects,
  );

  /// Converts this [Datum] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'medium': medium == null
        ? <dynamic>[]
        : List<dynamic>.from(medium!.map((Medium x) => x.toJson())),
    'subjects': subjects == null
        ? <dynamic>[]
        : List<dynamic>.from(subjects!.map((DatumSubject x) => x.toJson())),
  };
}

/// Represents a medium of instruction.
class Medium {
  /// Constructs a [Medium].
  Medium({
    this.id,
    this.medium,
    this.start,
    this.end,
    this.classDetails,
    this.schoolId,
    this.isDeleted,
  });

  /// Factory constructor to create a [Medium] from JSON.
  factory Medium.fromJson(Map<String, dynamic> json) => Medium(
    id: json['_id'],
    medium: json['medium'],
    start: json['start'],
    end: json['end'],
    classDetails: json['classDetails'] == null
        ? <ClassDet>[]
        : List<ClassDet>.from(
            json['classDetails']!.map((x) => ClassDet.fromJson(x)),
          ),
    schoolId: json['schoolId'],
    isDeleted: json['isDeleted'],
  );

  /// The unique identifier of the medium.
  final String? id;

  /// The name of the medium.
  final String? medium;

  /// The starting class for this medium.
  final int? start;

  /// The ending class for this medium.
  final int? end;

  /// The details of the classes in this medium.
  final List<ClassDet>? classDetails;

  /// The ID of the school.
  final String? schoolId;

  /// Indicates if the medium is deleted.
  final bool? isDeleted;

  /// Creates a copy of this [Medium] with optional new values.
  Medium copyWith({
    String? id,
    String? medium,
    int? start,
    int? end,
    List<ClassDet>? classDetails,
    String? schoolId,
    bool? isDeleted,
  }) => Medium(
    id: id ?? this.id,
    medium: medium ?? this.medium,
    start: start ?? this.start,
    end: end ?? this.end,
    classDetails: classDetails ?? this.classDetails,
    schoolId: schoolId ?? this.schoolId,
    isDeleted: isDeleted ?? this.isDeleted,
  );

  /// Converts this [Medium] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'medium': medium,
    'start': start,
    'end': end,
    'classDetails': classDetails == null
        ? <dynamic>[]
        : List<dynamic>.from(classDetails!.map((ClassDet x) => x.toJson())),
    'schoolId': schoolId,
    'isDeleted': isDeleted,
  };
}

/// Represents the details of a class.
class ClassDet {
  /// Constructs a [ClassDet].
  ClassDet({
    this.section,
    this.standard,
    this.girlsStrength,
    this.boysStrength,
    this.totalStrength,
    this.id,
  });

  /// Factory constructor to create a [ClassDet] from JSON.
  factory ClassDet.fromJson(Map<String, dynamic> json) => ClassDet(
    section: json['section'],
    standard: json['standard'],
    girlsStrength: json['girlsStrength'],
    boysStrength: json['boysStrength'],
    totalStrength: json['totalStrength'],
    id: json['_id'],
  );

  /// The section of the class.
  final String? section;

  /// The standard/grade of the class.
  final int? standard;

  /// The number of girls in the class.
  final int? girlsStrength;

  /// The number of boys in the class.
  final int? boysStrength;

  /// The total strength of the class.
  final int? totalStrength;

  /// The unique identifier of the class detail.
  final String? id;

  /// Creates a copy of this [ClassDet] with optional new values.
  ClassDet copyWith({
    String? section,
    int? standard,
    int? girlsStrength,
    int? boysStrength,
    int? totalStrength,
    String? id,
  }) => ClassDet(
    section: section ?? this.section,
    standard: standard ?? this.standard,
    girlsStrength: girlsStrength ?? this.girlsStrength,
    boysStrength: boysStrength ?? this.boysStrength,
    totalStrength: totalStrength ?? this.totalStrength,
    id: id ?? this.id,
  );

  /// Converts this [ClassDet] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'section': section,
    'standard': standard,
    'girlsStrength': girlsStrength,
    'boysStrength': boysStrength,
    'totalStrength': totalStrength,
    '_id': id,
  };
}

/// Represents a subject for a datum.
class DatumSubject {
  /// Constructs a [DatumSubject].
  DatumSubject({this.id, this.subjects});

  /// Factory constructor to create a [DatumSubject] from JSON.
  factory DatumSubject.fromJson(Map<String, dynamic> json) => DatumSubject(
    id: json['_id'],
    subjects: json['subjects'] == null
        ? <SubjectSubject>[]
        : List<SubjectSubject>.from(
            json['subjects']!.map((x) => SubjectSubject.fromJson(x)),
          ),
  );

  /// The unique identifier.
  final String? id;

  /// The list of subjects.
  final List<SubjectSubject>? subjects;

  /// Creates a copy of this [DatumSubject] with optional new values.
  DatumSubject copyWith({String? id, List<SubjectSubject>? subjects}) =>
      DatumSubject(id: id ?? this.id, subjects: subjects ?? this.subjects);

  /// Converts this [DatumSubject] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subjects': subjects == null
        ? <dynamic>[]
        : List<dynamic>.from(subjects!.map((SubjectSubject x) => x.toJson())),
  };
}

/// Represents a subject with its details.
class SubjectSubject {
  /// Constructs a [SubjectSubject].
  SubjectSubject({
    this.subjectName,
    this.boards,
    this.applicableClasses,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.sem,
    this.id,
  });

  /// Factory constructor to create a [SubjectSubject] from JSON.
  factory SubjectSubject.fromJson(Map<String, dynamic> json) => SubjectSubject(
    subjectName: json['subjectName'],
    boards: json['boards'] == null
        ? <String>[]
        : List<String>.from(json['boards']!.map((x) => x)),
    applicableClasses: json['applicableClasses'] == null
        ? <int>[]
        : List<int>.from(json['applicableClasses']!.map((x) => x)),
    isDeleted: json['isDeleted'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    sem: json['sem'],
    id: json['_id'],
  );

  /// The name of the subject.
  final String? subjectName;

  /// The list of boards where this subject is applicable.
  final List<String>? boards;

  /// The list of classes where this subject is applicable.
  final List<int>? applicableClasses;

  /// Indicates if the subject is deleted.
  final bool? isDeleted;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The semester number.
  final int? sem;

  /// The unique identifier.
  final String? id;

  /// Creates a copy of this [SubjectSubject] with optional new values.
  SubjectSubject copyWith({
    String? subjectName,
    List<String>? boards,
    List<int>? applicableClasses,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sem,
    String? id,
  }) => SubjectSubject(
    subjectName: subjectName ?? this.subjectName,
    boards: boards ?? this.boards,
    applicableClasses: applicableClasses ?? this.applicableClasses,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sem: sem ?? this.sem,
    id: id ?? this.id,
  );

  /// Converts this [SubjectSubject] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'subjectName': subjectName,
    'boards': boards == null
        ? <dynamic>[]
        : List<dynamic>.from(boards!.map((String x) => x)),
    'applicableClasses': applicableClasses == null
        ? <dynamic>[]
        : List<dynamic>.from(applicableClasses!.map((int x) => x)),
    'isDeleted': isDeleted,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'sem': sem,
    '_id': id,
  };
}
