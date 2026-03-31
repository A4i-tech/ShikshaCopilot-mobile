// To parse this JSON data, do
//
//     final lessonPlanTemplateModel = lessonPlanTemplateModelFromJson(jsonString);

import 'dart:convert';

/// A function to convert a JSON string into a [LessonPlanTemplateModel] object.
LessonPlanTemplateModel lessonPlanTemplateModelFromJson(String str) =>
    LessonPlanTemplateModel.fromJson(json.decode(str));

/// A function to convert a [LessonPlanTemplateModel] object into a JSON string.
String lessonPlanTemplateModelToJson(LessonPlanTemplateModel data) =>
    json.encode(data.toJson());

/// A model class that represents the response from the lesson plan template API.
class LessonPlanTemplateModel {
  /// Creates a [LessonPlanTemplateModel] object.
  LessonPlanTemplateModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [LessonPlanTemplateModel] object from a JSON map.
  factory LessonPlanTemplateModel.fromJson(Map<String, dynamic> json) =>
      LessonPlanTemplateModel(
        success: json['success'],
        message: json['message'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );

  /// Whether the request was successful.
  bool success;

  /// A message describing the result of the request.
  String message;

  /// The data returned by the API.
  List<Datum> data;

  /// Converts the [LessonPlanTemplateModel] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': List<dynamic>.from(data.map((Datum x) => x.toJson())),
  };
}

/// A model class that represents a single lesson plan template.
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

  /// The ID of the template.
  String id;

  /// The name of the template.
  String name;

  /// The ID of the workflow associated with the template.
  String workFlowId;

  /// The model used by the template.
  String model;

  /// A description of the template.
  String description;

  /// The boards for which the template is intended.
  List<String> boards;

  /// The mediums of instruction for which the template is intended.
  List<String> mediums;

  /// The classes for which the template is intended.
  List<int> classes;

  /// The subjects for which the template is intended.
  List<String> subjects;

  /// The type of the template.
  String type;

  /// The sections of the template.
  List<Section> sections;

  /// Whether the template is active.
  bool isActive;

  /// The status of the template.
  String status;

  /// The user who approved the template.
  String approvedBy;

  /// The date and time when the template was approved.
  DateTime approvedAt;

  /// The date and time when the template was created.
  DateTime createdAt;

  /// The date and time when the template was last updated.
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

/// A model class that represents a section of a template.
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
    // required this.mode,
  });

  /// Creates a [Section] object from a JSON map.
  factory Section.fromJson(Map<String, dynamic> json) => Section(
    sectionId: json['id'],
    title: json['title'],
    description: json['description'],
    outputFormat: outputFormatValues.map[json['outputFormat']]!,
    textbookContent: json['textbookContent'],
    dependencies: List<Dependency>.from(
      json['dependencies'].map((x) => Dependency.fromJson(x)),
    ),
    id: json['_id'],
    //  mode: modeValues.map[json['mode']]!,
  );

  /// The ID of the section.
  String sectionId;

  /// The title of the section.
  String title;

  /// A description of the section.
  String description;

  /// The output format of the section.
  OutputFormat outputFormat;

  /// Whether the section includes textbook content.
  bool textbookContent;

  /// The dependencies of the section.
  List<Dependency> dependencies;

  /// The ID of the section.
  String id;
  // Mode mode;

  /// Converts the [Section] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': sectionId,
    'title': title,
    'description': description,
    'outputFormat': outputFormatValues.reverse[outputFormat],
    'textbookContent': textbookContent,
    'dependencies': List<dynamic>.from(
      dependencies.map((Dependency x) => x.toJson()),
    ),
    '_id': id,
    //   'mode': modeValues.reverse[mode],
  };
}

/// A model class that represents a dependency of a template section.
class Dependency {
  /// Creates a [Dependency] object.
  Dependency({required this.sectionId});

  /// Creates a [Dependency] object from a JSON map.
  factory Dependency.fromJson(Map<String, dynamic> json) =>
      Dependency(sectionId: json['section_id']);

  /// The ID of the section on which this section depends.
  String sectionId;

  /// Converts the [Dependency] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{'section_id': sectionId};
}

/// An enum that represents the mode of a template section.
enum Mode {
  /// The RAG mode.
  RAG,
}

/// A class that provides a mapping between strings and [Mode] values.
final EnumValues<Mode> modeValues = EnumValues(<String, Mode>{'rag': Mode.RAG});

/// An enum that represents the output format of a template section.
enum OutputFormat {
  /// A JSON checklist in the 5E format.
  JSON_5_E_CHECKLIST,

  /// Plain text.
  PLAIN_TEXT,
}

/// A class that provides a mapping between strings and [OutputFormat] values.
final EnumValues<OutputFormat> outputFormatValues =
    EnumValues(<String, OutputFormat>{
      'json_5E_checklist': OutputFormat.JSON_5_E_CHECKLIST,
      'plain_text': OutputFormat.PLAIN_TEXT,
    });

/// A generic class for mapping between enum values and strings.
class EnumValues<T> {
  /// Creates an [EnumValues] object.
  EnumValues(this.map);

  /// The map from strings to enum values.
  Map<String, T> map;

  /// The map from enum values to strings.
  late Map<T, String> reverseMap;

  /// Returns the reverse map.
  Map<T, String> get reverse {
    reverseMap = map.map((String k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
