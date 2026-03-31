// To parse this JSON data, do
//
//     final generationStatus = generationStatusFromJson(jsonString);

import 'dart:convert';

GenerationStatus generationStatusFromJson(String str) =>
    GenerationStatus.fromJson(json.decode(str));

String generationStatusToJson(GenerationStatus data) =>
    json.encode(data.toJson());

class GenerationStatus {
  GenerationStatus({this.success, this.message, this.data});

  factory GenerationStatus.fromJson(Map<String, dynamic> json) =>
      GenerationStatus(
        success: json['success'],
        message: json['message'],
        data: json['data'] == null
            ? <Datum>[]
            : List<Datum>.from(json['data']!.map((x) => Datum.fromJson(x))),
      );
  final bool? success;
  final String? message;
  final List<Datum>? data;

  GenerationStatus copyWith({
    bool? success,
    String? message,
    List<Datum>? data,
  }) => GenerationStatus(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data == null
        ? <dynamic>[]
        : List<dynamic>.from(data!.map((Datum x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.isLesson,
    this.status,
    this.isGenerated,
    this.learningOutcomes,
    this.isCompleted,
    this.resources,
    this.additionalResources,
    this.instructionSet,
    this.createdAt,
    this.updatedAt,
    this.lesson,
    this.createdMonth,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['_id'],
    isLesson: json['isLesson'],
    status: json['status'],
    isGenerated: json['isGenerated'],
    learningOutcomes: json['learningOutcomes'] == null
        ? <String>[]
        : List<String>.from(json['learningOutcomes']!.map((x) => x)),
    isCompleted: json['isCompleted'],
    resources: json['resources'] == null
        ? <dynamic>[]
        : List<dynamic>.from(json['resources']!.map((x) => x)),
    additionalResources: json['additionalResources'] == null
        ? <dynamic>[]
        : List<dynamic>.from(json['additionalResources']!.map((x) => x)),
    instructionSet: json['instructionSet'] == null
        ? <dynamic>[]
        : List<dynamic>.from(json['instructionSet']!.map((x) => x)),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    lesson: json['lesson'] == null ? null : Lesson.fromJson(json['lesson']),
    createdMonth: json['createdMonth'],
  );
  final String? id;
  final bool? isLesson;
  final String? status;
  final bool? isGenerated;
  final List<String>? learningOutcomes;
  final bool? isCompleted;
  final List<dynamic>? resources;
  final List<dynamic>? additionalResources;
  final List<dynamic>? instructionSet;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Lesson? lesson;
  final int? createdMonth;

  Datum copyWith({
    String? id,
    bool? isLesson,
    String? status,
    bool? isGenerated,
    List<String>? learningOutcomes,
    bool? isCompleted,
    List<dynamic>? resources,
    List<dynamic>? additionalResources,
    List<dynamic>? instructionSet,
    DateTime? createdAt,
    DateTime? updatedAt,
    Lesson? lesson,
    int? createdMonth,
  }) => Datum(
    id: id ?? this.id,
    isLesson: isLesson ?? this.isLesson,
    status: status ?? this.status,
    isGenerated: isGenerated ?? this.isGenerated,
    learningOutcomes: learningOutcomes ?? this.learningOutcomes,
    isCompleted: isCompleted ?? this.isCompleted,
    resources: resources ?? this.resources,
    additionalResources: additionalResources ?? this.additionalResources,
    instructionSet: instructionSet ?? this.instructionSet,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lesson: lesson ?? this.lesson,
    createdMonth: createdMonth ?? this.createdMonth,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'isLesson': isLesson,
    'status': status,
    'isGenerated': isGenerated,
    'learningOutcomes': learningOutcomes == null
        ? <dynamic>[]
        : List<dynamic>.from(learningOutcomes!.map((String x) => x)),
    'isCompleted': isCompleted,
    'resources': resources == null
        ? <dynamic>[]
        : List<dynamic>.from(resources!.map((x) => x)),
    'additionalResources': additionalResources == null
        ? <dynamic>[]
        : List<dynamic>.from(additionalResources!.map((x) => x)),
    'instructionSet': instructionSet == null
        ? <dynamic>[]
        : List<dynamic>.from(instructionSet!.map((x) => x)),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'lesson': lesson?.toJson(),
    'createdMonth': createdMonth,
  };
}

class Lesson {
  Lesson({
    this.id,
    this.name,
    this.lessonClass,
    this.isAll,
    this.subject,
    this.subTopics,
    this.teachingModel,
    this.learningOutcomes,
    this.checkList,
    this.templateId,
    this.chapter,
    this.subjects,
    this.videos,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['_id'],
    name: json['name'],
    lessonClass: json['class'],
    isAll: json['isAll'],
    subject: json['subject'],
    subTopics: json['subTopics'] == null
        ? <String>[]
        : List<String>.from(json['subTopics']!.map((x) => x)),
    teachingModel: json['teachingModel'] == null
        ? <dynamic>[]
        : List<dynamic>.from(json['teachingModel']!.map((x) => x)),
    learningOutcomes: json['learningOutcomes'] == null
        ? <String>[]
        : List<String>.from(json['learningOutcomes']!.map((x) => x)),
    checkList: json['checkList'] == null
        ? <dynamic>[]
        : List<dynamic>.from(json['checkList']!.map((x) => x)),
    templateId: json['templateId'],
    chapter: json['chapter'] == null ? null : Chapter.fromJson(json['chapter']),
    subjects: json['subjects'] == null
        ? null
        : Subjects.fromJson(json['subjects']),
    videos: json['videos'] == null
        ? <dynamic>[]
        : List<dynamic>.from(json['videos']!.map((x) => x)),
  );
  final String? id;
  final String? name;
  final int? lessonClass;
  final bool? isAll;
  final String? subject;
  final List<String>? subTopics;
  final List<dynamic>? teachingModel;
  final List<String>? learningOutcomes;
  final List<dynamic>? checkList;
  final String? templateId;
  final Chapter? chapter;
  final Subjects? subjects;
  final List<dynamic>? videos;

  Lesson copyWith({
    String? id,
    String? name,
    int? lessonClass,
    bool? isAll,
    String? subject,
    List<String>? subTopics,
    List<dynamic>? teachingModel,
    List<String>? learningOutcomes,
    List<dynamic>? checkList,
    String? templateId,
    Chapter? chapter,
    Subjects? subjects,
    List<dynamic>? videos,
  }) => Lesson(
    id: id ?? this.id,
    name: name ?? this.name,
    lessonClass: lessonClass ?? this.lessonClass,
    isAll: isAll ?? this.isAll,
    subject: subject ?? this.subject,
    subTopics: subTopics ?? this.subTopics,
    teachingModel: teachingModel ?? this.teachingModel,
    learningOutcomes: learningOutcomes ?? this.learningOutcomes,
    checkList: checkList ?? this.checkList,
    templateId: templateId ?? this.templateId,
    chapter: chapter ?? this.chapter,
    subjects: subjects ?? this.subjects,
    videos: videos ?? this.videos,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'class': lessonClass,
    'isAll': isAll,
    'subject': subject,
    'subTopics': subTopics == null
        ? <dynamic>[]
        : List<dynamic>.from(subTopics!.map((String x) => x)),
    'teachingModel': teachingModel == null
        ? <dynamic>[]
        : List<dynamic>.from(teachingModel!.map((x) => x)),
    'learningOutcomes': learningOutcomes == null
        ? <dynamic>[]
        : List<dynamic>.from(learningOutcomes!.map((String x) => x)),
    'checkList': checkList == null
        ? <dynamic>[]
        : List<dynamic>.from(checkList!.map((x) => x)),
    'templateId': templateId,
    'chapter': chapter?.toJson(),
    'subjects': subjects?.toJson(),
    'videos': videos == null
        ? <dynamic>[]
        : List<dynamic>.from(videos!.map((x) => x)),
  };
}

class Chapter {
  Chapter({
    this.id,
    this.topics,
    this.subTopics,
    this.medium,
    this.board,
    this.orderNumber,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json['_id'],
    topics: json['topics'],
    subTopics: json['subTopics'] == null
        ? <String>[]
        : List<String>.from(json['subTopics']!.map((x) => x)),
    medium: json['medium'],
    board: json['board'],
    orderNumber: json['orderNumber'],
  );
  final String? id;
  final String? topics;
  final List<String>? subTopics;
  final String? medium;
  final String? board;
  final int? orderNumber;

  Chapter copyWith({
    String? id,
    String? topics,
    List<String>? subTopics,
    String? medium,
    String? board,
    int? orderNumber,
  }) => Chapter(
    id: id ?? this.id,
    topics: topics ?? this.topics,
    subTopics: subTopics ?? this.subTopics,
    medium: medium ?? this.medium,
    board: board ?? this.board,
    orderNumber: orderNumber ?? this.orderNumber,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'topics': topics,
    'subTopics': subTopics == null
        ? <dynamic>[]
        : List<dynamic>.from(subTopics!.map((String x) => x)),
    'medium': medium,
    'board': board,
    'orderNumber': orderNumber,
  };
}

class Subjects {
  Subjects({this.name, this.sem});

  factory Subjects.fromJson(Map<String, dynamic> json) =>
      Subjects(name: json['name'], sem: json['sem']);
  final String? name;
  final int? sem;

  Subjects copyWith({String? name, int? sem}) =>
      Subjects(name: name ?? this.name, sem: sem ?? this.sem);

  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'sem': sem};
}
