// To parse this JSON data, do
//
//     final lessonResourceTemplateModel = lessonResourceTemplateModelFromJson(jsonString);

import 'dart:convert';

/// A function to convert a JSON string to a [LessonResourceTemplateModel] object.
LessonResourceTemplateModel lessonResourceTemplateModelFromJson(String str) =>
    LessonResourceTemplateModel.fromJson(json.decode(str));

/// A function to convert a [LessonResourceTemplateModel] object to a JSON string.
String lessonResourceTemplateModelToJson(LessonResourceTemplateModel data) =>
    json.encode(data.toJson());

/// A model class for the lesson resource template.
class LessonResourceTemplateModel {

  /// Creates a [LessonResourceTemplateModel] object.
  LessonResourceTemplateModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [LessonResourceTemplateModel] object from a JSON map.
  factory LessonResourceTemplateModel.fromJson(Map<String, dynamic> json) =>
      LessonResourceTemplateModel(
        success: json['success'],
        message: json['message'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );
  /// Whether the request was successful.
  bool success;
  /// A message describing the result of the request.
  String message;
  /// A list of data objects.
  List<Datum> data;

  /// Converts the [LessonResourceTemplateModel] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': List<dynamic>.from(data.map((Datum x) => x.toJson())),
  };
}

/// A model class for the data object in the lesson resource template.
class Datum {

  /// Creates a [Datum] object.
  Datum({
    required this.id,
    required this.name,
    required this.workFlowId,
    required this.model,
    required this.description,
    required this.boards,
    required this.mediums,
    required this.classes,
    required this.subjects,
    required this.type,
    required this.sections,
    required this.isActive,
    required this.status,
    required this.approvedBy,
    required this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// Creates a [Datum] object from a JSON map.
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['_id'],
    name: json['name'],
    workFlowId: json['workFlowId'],
    model: json['model'],
    description: json['description'],
    boards: List<String>.from(json['boards'].map((x) => x)),
    mediums: List<String>.from(json['mediums'].map((x) => x)),
    classes: List<int>.from(json['classes'].map((x) => x)),
    subjects: List<String>.from(json['subjects'].map((x) => x)),
    type: json['type'],
    sections: List<Section>.from(
      json['sections'].map((x) => Section.fromJson(x)),
    ),
    isActive: json['isActive'],
    status: json['status'],
    approvedBy: json['approvedBy'],
    approvedAt: DateTime.parse(json['approvedAt']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );
  /// The ID of the data object.
  String id;
  /// The name of the template.
  String name;
  /// The ID of the workflow.
  String workFlowId;
  /// The model of the template.
  String model;
  /// The description of the template.
  String description;
  /// A list of boards.
  List<String> boards;
  /// A list of mediums.
  List<String> mediums;
  /// A list of classes.
  List<int> classes;
  /// A list of subjects.
  List<String> subjects;
  /// The type of the template.
  String type;
  /// A list of sections.
  List<Section> sections;
  /// Whether the template is active.
  bool isActive;
  /// The status of the template.
  String status;
  /// The user who approved the template.
  String approvedBy;
  /// The date of approval.
  DateTime approvedAt;
  /// The creation date of the template.
  DateTime createdAt;
  /// The last update date of the template.
  DateTime updatedAt;
  /// The version of the template.
  int v;

  /// Converts the [Datum] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'workFlowId': workFlowId,
    'model': model,
    'description': description,
    'boards': List<dynamic>.from(boards.map((String x) => x)),
    'mediums': List<dynamic>.from(mediums.map((String x) => x)),
    'classes': List<dynamic>.from(classes.map((int x) => x)),
    'subjects': List<dynamic>.from(subjects.map((String x) => x)),
    'type': type,
    'sections': List<dynamic>.from(sections.map((Section x) => x.toJson())),
    'isActive': isActive,
    'status': status,
    'approvedBy': approvedBy,
    'approvedAt': approvedAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}

/// A model class for a section object.
class Section {

  /// Creates a [Section] object.
  Section({
    required this.sectionId,
    required this.title,
    required this.description,
    required this.outputFormat,
    required this.textbookContent,
    required this.dependencies,
    required this.id,
    required this.mode,
  });

  /// Creates a [Section] object from a JSON map.
  factory Section.fromJson(Map<String, dynamic> json) => Section(
    sectionId: json['id'],
    title: json['title'],
    description: json['description'],
    outputFormat: json['outputFormat'],
    textbookContent: json['textbookContent'],
    dependencies: List<dynamic>.from(json['dependencies'].map((x) => x)),
    id: json['_id'],
    mode: json['mode'],
  );
  /// The ID of the section.
  String sectionId;
  /// The title of the section.
  String title;
  /// The description of the section.
  String description;
  /// The output format of the section.
  String outputFormat;
  /// Whether the section has textbook content.
  bool textbookContent;
  /// A list of dependencies.
  List<dynamic> dependencies;
  /// The ID of the section.
  String id;
  /// The mode of the section.
  String mode;

  /// Converts the [Section] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': sectionId,
    'title': title,
    'description': description,
    'outputFormat': outputFormat,
    'textbookContent': textbookContent,
    'dependencies': List<dynamic>.from(dependencies.map((x) => x)),
    '_id': id,
    'mode': mode,
  };
}
