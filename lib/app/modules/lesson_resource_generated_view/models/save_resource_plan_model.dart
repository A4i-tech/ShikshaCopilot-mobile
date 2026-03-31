// To parse this JSON data, do
//
//     final saveResourcePlanModel = saveResourcePlanModelFromJson(jsonString);

import 'dart:convert';

/// Creates a [SaveResourcePlanModel] from a JSON string.
SaveResourcePlanModel saveResourcePlanModelFromJson(String str) =>
    SaveResourcePlanModel.fromJson(json.decode(str));

/// Converts a [SaveResourcePlanModel] to a JSON string.
String saveResourcePlanModelToJson(SaveResourcePlanModel data) =>
    json.encode(data.toJson());

/// A model representing the response from saving a resource plan.
class SaveResourcePlanModel {
  /// Creates a [SaveResourcePlanModel].
  SaveResourcePlanModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [SaveResourcePlanModel] from a JSON map.
  factory SaveResourcePlanModel.fromJson(Map<String, dynamic> json) =>
      SaveResourcePlanModel(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  /// Indicates whether the request was successful.
  bool success;

  /// A message describing the result of the request.
  String message;

  /// The data returned by the request.
  Data data;

  /// Converts this [SaveResourcePlanModel] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// A model representing the data of a saved resource plan.
class Data {
  /// Creates a [Data] object.
  Data({
    required this.teacherId,
    required this.resourceId,
    required this.isLesson,
    required this.status,
    required this.isGenerated,
    required this.resources,
    required this.additionalResources,
    required this.isCompleted,
    required this.isDeleted,
    required this.isVideoSelected,
    required this.sections,
    required this.id,
    required this.learningOutcomes,
    required this.instructionSet,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// Creates a [Data] object from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    teacherId: json['teacherId'],
    resourceId: json['resourceId'],
    isLesson: json['isLesson'],
    status: json['status'],
    isGenerated: json['isGenerated'],
    resources: List<Resource>.from(
      json['resources'].map((x) => Resource.fromJson(x)),
    ),
    additionalResources: List<dynamic>.from(
      json['additionalResources'].map((x) => x),
    ),
    isCompleted: json['isCompleted'],
    isDeleted: json['isDeleted'],
    isVideoSelected: json['isVideoSelected'],
    sections: List<dynamic>.from(json['sections'].map((x) => x)),
    id: json['_id'],
    learningOutcomes: List<dynamic>.from(
      json['learningOutcomes'].map((x) => x),
    ),
    instructionSet: List<dynamic>.from(json['instructionSet'].map((x) => x)),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The ID of the teacher.
  String teacherId;

  /// The ID of the resource.
  String resourceId;

  /// Indicates whether this is a lesson.
  bool isLesson;

  /// The status of the resource plan.
  String status;

  /// Indicates whether the resource plan was generated.
  bool isGenerated;

  /// A list of resources in the plan.
  List<Resource> resources;

  /// A list of additional resources.
  List<dynamic> additionalResources;

  /// Indicates whether the resource plan is completed.
  bool isCompleted;

  /// Indicates whether the resource plan is deleted.
  bool isDeleted;

  /// Indicates whether a video is selected.
  bool isVideoSelected;

  /// A list of sections in the plan.
  List<dynamic> sections;

  /// The ID of the resource plan.
  String id;

  /// A list of learning outcomes.
  List<dynamic> learningOutcomes;

  /// A list of instruction sets.
  List<dynamic> instructionSet;

  /// The date and time when the resource plan was created.
  DateTime createdAt;

  /// The date and time when the resource plan was last updated.
  DateTime updatedAt;

  /// The version of the resource plan.
  int v;

  /// Converts this [Data] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'teacherId': teacherId,
    'resourceId': resourceId,
    'isLesson': isLesson,
    'status': status,
    'isGenerated': isGenerated,
    'resources': List<dynamic>.from(resources.map((Resource x) => x.toJson())),
    'additionalResources': List<dynamic>.from(
      additionalResources.map((x) => x),
    ),
    'isCompleted': isCompleted,
    'isDeleted': isDeleted,
    'isVideoSelected': isVideoSelected,
    'sections': List<dynamic>.from(sections.map((x) => x)),
    '_id': id,
    'learningOutcomes': List<dynamic>.from(learningOutcomes.map((x) => x)),
    'instructionSet': List<dynamic>.from(instructionSet.map((x) => x)),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}

/// A model representing a resource in the plan.
class Resource {
  /// Creates a [Resource].
  Resource({
    required this.id,
    required this.title,
    required this.content,
    required this.outputFormat,
  });

  /// Creates a [Resource] from a JSON map.
  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json['id'],
    title: json['title'],
    content: List<ResourceContent>.from(
      json['content'].map((x) => ResourceContent.fromJson(x)),
    ),
    outputFormat: json['outputFormat'],
  );

  /// The ID of the resource.
  String id;

  /// The title of the resource.
  String title;

  /// The content of the resource.
  List<ResourceContent> content;

  /// The output format of the resource.
  String outputFormat;

  /// Converts this [Resource] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title': title,
    'content': List<dynamic>.from(
      content.map((ResourceContent x) => x.toJson()),
    ),
    'outputFormat': outputFormat,
  };
}

/// A model representing the content of a resource.
class ResourceContent {
  /// Creates a [ResourceContent].
  ResourceContent({
    this.difficulty,
    this.content,
    this.id,
    this.title,
    this.preparation,
    this.requiredMaterials,
    this.obtainingMaterials,
    this.recap,
  });

  /// Creates a [ResourceContent] from a JSON map.
  factory ResourceContent.fromJson(Map<String, dynamic> json) =>
      ResourceContent(
        difficulty: json['difficulty'],
        content: json['content'] == null
            ? <ContentContent>[]
            : List<ContentContent>.from(
                json['content']!.map((x) => ContentContent.fromJson(x)),
              ),
        id: json['id'],
        title: json['title'],
        preparation: json['preparation'],
        requiredMaterials: json['required_materials'],
        obtainingMaterials: json['obtaining_materials'],
        recap: json['recap'],
      );

  /// The difficulty level of the content.
  String? difficulty;

  /// The list of content items.
  List<ContentContent>? content;

  /// The ID of the content.
  String? id;

  /// The title of the content.
  String? title;

  /// The preparation steps.
  String? preparation;

  /// The required materials.
  String? requiredMaterials;

  /// Instructions on how to obtain materials.
  String? obtainingMaterials;

  /// A recap of the content.
  String? recap;

  /// Converts this [ResourceContent] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'difficulty': difficulty,
    'content': content == null
        ? <dynamic>[]
        : List<dynamic>.from(content!.map((ContentContent x) => x.toJson())),
    'id': id,
    'title': title,
    'preparation': preparation,
    'required_materials': requiredMaterials,
    'obtaining_materials': obtainingMaterials,
    'recap': recap,
  };
}

/// A model representing a content item.
class ContentContent {
  /// Creates a [ContentContent].
  ContentContent({
    this.type,
    this.questions,
    this.title,
    this.question,
    this.description,
  });

  /// Creates a [ContentContent] from a JSON map.
  factory ContentContent.fromJson(Map<String, dynamic> json) => ContentContent(
    type: json['type'],
    questions: json['questions'] == null
        ? <Question>[]
        : List<Question>.from(
            json['questions']!.map((x) => Question.fromJson(x)),
          ),
    title: json['title'],
    question: json['question'],
    description: json['description'],
  );

  /// The type of the content.
  String? type;

  /// A list of questions.
  List<Question>? questions;

  /// The title of the content.
  String? title;

  /// The question.
  String? question;

  /// The description.
  String? description;

  /// Converts this [ContentContent] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'questions': questions == null
        ? <dynamic>[]
        : List<dynamic>.from(questions!.map((Question x) => x.toJson())),
    'title': title,
    'question': question,
    'description': description,
  };
}

/// A model representing a question.
class Question {
  /// Creates a [Question].
  Question({required this.question, this.options});

  /// Creates a [Question] from a JSON map.
  factory Question.fromJson(Map<String, dynamic> json) => Question(
    question: json['question'],
    options: json['options'] == null
        ? <String>[]
        : List<String>.from(json['options']!.map((x) => x)),
  );

  /// The question text.
  String question;

  /// A list of options for the question.
  List<String>? options;

  /// Converts this [Question] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'question': question,
    'options': options == null
        ? <dynamic>[]
        : List<dynamic>.from(options!.map((String x) => x)),
  };
}
