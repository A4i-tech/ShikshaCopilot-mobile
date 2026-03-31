// To parse this JSON data, do
//
//     final saveLessonPlanModel = saveLessonPlanModelFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into a [SaveLessonPlanModel] instance.
///
/// - [str]: The raw JSON payload returned by the backend.
/// - Returns: Parsed [SaveLessonPlanModel] object.
SaveLessonPlanModel saveLessonPlanModelFromJson(String str) =>
    SaveLessonPlanModel.fromJson(json.decode(str));

/// Converts a [SaveLessonPlanModel] instance into a JSON string.
///
/// Useful for caching or re-sending data.
///
/// - [data]: The model instance to encode.
/// - Returns: JSON string.
String saveLessonPlanModelToJson(SaveLessonPlanModel data) =>
    json.encode(data.toJson());

/// Represents the response when saving a lesson plan.
///
/// Contains:
/// - A boolean status [success]
/// - A descriptive [message]
/// - A nested [Data] object representing the saved lesson state
class SaveLessonPlanModel {
  /// Constructs a [SaveLessonPlanModel] instance.
  SaveLessonPlanModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates an instance of [SaveLessonPlanModel] from a JSON map.
  factory SaveLessonPlanModel.fromJson(Map<String, dynamic> json) =>
      SaveLessonPlanModel(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  /// Indicates whether saving the lesson plan was successful.
  bool success;

  /// A message returned by the server.
  String message;

  /// Details of the saved lesson plan.
  Data data;

  /// Converts this model into a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// Represents the detailed lesson plan data returned after saving.
///
/// Includes:
/// - Lesson metadata (IDs, flags, status)
/// - Learning outcomes list
/// - Section data (structured as [Section] objects)
/// - Additional learning resources
/// - Instruction sets
/// - Timestamps
class Data {
  /// Creates a [Data] model to represent saved lesson details.
  Data({
    required this.id,
    required this.teacherId,
    required this.lessonId,
    required this.isLesson,
    required this.status,
    required this.isGenerated,
    required this.learningOutcomes,
    required this.isCompleted,
    required this.isDeleted,
    required this.isVideoSelected,
    required this.sections,
    required this.resources,
    required this.additionalResources,
    required this.instructionSet,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// Parses JSON into a [Data] instance.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['_id'],
    teacherId: json['teacherId'],
    lessonId: json['lessonId'],
    isLesson: json['isLesson'],
    status: json['status'],
    isGenerated: json['isGenerated'],
    learningOutcomes: List<String>.from(json['learningOutcomes'].map((x) => x)),
    isCompleted: json['isCompleted'],
    isDeleted: json['isDeleted'],
    isVideoSelected: json['isVideoSelected'],
    sections: List<Section>.from(
      json['sections'].map((x) => Section.fromJson(x)),
    ),
    resources: List<dynamic>.from(json['resources'].map((x) => x)),
    additionalResources: List<dynamic>.from(
      json['additionalResources'].map((x) => x),
    ),
    instructionSet: List<dynamic>.from(json['instructionSet'].map((x) => x)),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// Unique identifier for the saved instance.
  String id;

  /// Teacher ID associated with the lesson.
  String teacherId;

  /// ID of the lesson related to this saved data.
  String lessonId;

  /// Indicates whether this entity is a lesson-type record.
  bool isLesson;

  /// Status of the lesson (e.g., active, draft).
  String status;

  /// Indicates whether the lesson was generated via AI.
  bool isGenerated;

  /// List of learning outcomes associated with the lesson.
  List<String> learningOutcomes;

  /// Whether the lesson plan is complete.
  bool isCompleted;

  /// Whether the lesson plan is marked as deleted.
  bool isDeleted;

  /// Whether media/video is selected in the lesson.
  bool isVideoSelected;

  /// List of structured lesson sections.
  List<Section> sections;

  /// Primary learning resources.
  List<dynamic> resources;

  /// Additional learning resources.
  List<dynamic> additionalResources;

  /// Instructional steps for the lesson.
  List<dynamic> instructionSet;

  /// Creation timestamp.
  DateTime createdAt;

  /// Last update timestamp.
  DateTime updatedAt;

  /// Version key (used by MongoDB).
  int v;

  /// Converts this data model into a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'teacherId': teacherId,
    'lessonId': lessonId,
    'isLesson': isLesson,
    'status': status,
    'isGenerated': isGenerated,
    'learningOutcomes': List<dynamic>.from(
      learningOutcomes.map((String x) => x),
    ),
    'isCompleted': isCompleted,
    'isDeleted': isDeleted,
    'isVideoSelected': isVideoSelected,
    'sections': List<dynamic>.from(sections.map((Section x) => x.toJson())),
    'resources': List<dynamic>.from(resources.map((x) => x)),
    'additionalResources': List<dynamic>.from(
      additionalResources.map((x) => x),
    ),
    'instructionSet': List<dynamic>.from(instructionSet.map((x) => x)),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}

/// Represents an individual lesson plan section.
///
/// A section contains:
/// - An ID
/// - A title
/// - The content (text or structured data)
/// - The content output format (markdown, html, text, etc.)
class Section {
  /// Creates a [Section] instance.
  Section({
    required this.id,
    required this.title,
    required this.content,
    required this.outputFormat,
  });

  /// Converts JSON into a [Section] model.
  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    outputFormat: json['outputFormat'],
  );

  /// Section ID.
  String id;

  /// Title of the section (e.g., Engage, Explore, Explain).
  String title;

  /// Section content (may be text, HTML, or formatted content).
  dynamic content;

  /// The rendering format of the content.
  String outputFormat;

  /// Converts this section into a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title': title,
    'content': content,
    'outputFormat': outputFormat,
  };
}

/// Represents a structured content class following the 5E model.
///
/// Includes:
/// - Engage
/// - Explore
/// - Explain
/// - Elaborate
/// - Evaluate
///
/// Each field is parsed as an [Elaborate] structure.
class ContentClass {
  /// Constructs a 5E model content class.
  ContentClass({
    required this.engage,
    required this.explore,
    required this.explain,
    required this.elaborate,
    required this.evaluate,
  });

  /// Parses a JSON map into a [ContentClass] instance.
  factory ContentClass.fromJson(Map<String, dynamic> json) => ContentClass(
    engage: Elaborate.fromJson(json['engage']),
    explore: Elaborate.fromJson(json['explore']),
    explain: Elaborate.fromJson(json['explain']),
    elaborate: Elaborate.fromJson(json['elaborate']),
    evaluate: Elaborate.fromJson(json['evaluate']),
  );

  /// Activity/materials for Engage phase.
  Elaborate engage;

  /// Activity/materials for Explore phase.
  Elaborate explore;

  /// Activity/materials for Explain phase.
  Elaborate explain;

  /// Activity/materials for Elaborate phase.
  Elaborate elaborate;

  /// Activity/materials for Evaluate phase.
  Elaborate evaluate;

  /// Converts this content structure into JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'engage': engage.toJson(),
    'explore': explore.toJson(),
    'explain': explain.toJson(),
    'elaborate': elaborate.toJson(),
    'evaluate': evaluate.toJson(),
  };
}

/// Represents content for a single 5E phase.
///
/// Contains:
/// - [activity]: Activity description
/// - [materials]: Materials used in the phase
class Elaborate {
  /// Creates an [Elaborate] instance.
  Elaborate({required this.activity, required this.materials});

  /// Parses JSON into an [Elaborate] model.
  factory Elaborate.fromJson(Map<String, dynamic> json) =>
      Elaborate(activity: json['activity'], materials: json['materials']);

  /// Activity performed in this phase.
  String activity;

  /// Materials required for the activity.
  String materials;

  /// Converts this model to JSON format.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'activity': activity,
    'materials': materials,
  };
}
