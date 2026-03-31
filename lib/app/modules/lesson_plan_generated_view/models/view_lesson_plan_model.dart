// To parse this JSON data, do
//
//     final viewLessonPlanModel = viewLessonPlanModelFromJson(jsonString);

import 'dart:convert';

import 'package:sikshana/app/modules/lesson_plan_generation_details/models/generate_lesson_response_model.dart';

/// Converts a JSON string into a [ViewLessonPlanModel] instance.
///
/// - [str]: The JSON string returned from API.
/// - Returns: Parsed [ViewLessonPlanModel].
ViewLessonPlanModel viewLessonPlanModelFromJson(String str) =>
    ViewLessonPlanModel.fromJson(json.decode(str));

/// Converts a [ViewLessonPlanModel] instance into a JSON string.
///
/// Useful for logging, caching, or debugging.
String viewLessonPlanModelToJson(ViewLessonPlanModel data) =>
    json.encode(data.toJson());

/// Represents the complete response returned when fetching a lesson plan.
///
/// Contains:
/// - A success indicator
/// - A message
/// - A detailed [Data] object with lesson plan metadata, content, resources, etc.
class ViewLessonPlanModel {
  /// Creates a new instance of [ViewLessonPlanModel].
  ViewLessonPlanModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates an instance from a JSON map.
  factory ViewLessonPlanModel.fromJson(Map<String, dynamic> json) =>
      ViewLessonPlanModel(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  /// Indicates whether the fetch request was successful.
  bool success;

  /// Message returned from the server.
  String message;

  /// The complete lesson plan data.
  Data data;

  /// Converts this model into JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// Represents detailed lesson plan data:
///
/// Includes:
/// - Learning outcomes
/// - Sections (Engage, Explore, Explain, etc.)
/// - Resources & media
/// - Template info
/// - Lesson-level metadata
/// - Feedback (if available)
class Data {
  /// Creates a [Data] object holding lesson details.
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
    required this.lesson,
    required this.template,
    this.feedback,
  });

  /// Creates a [Data] object from JSON.
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
    sections: List<DatumSection>.from(
      json['sections'].map((x) => DatumSection.fromJson(x)),
    ),
    resources: List<dynamic>.from(json['resources'].map((x) => x)),
    additionalResources: List<dynamic>.from(
      json['additionalResources'].map((x) => x),
    ),
    instructionSet: List<dynamic>.from(json['instructionSet'].map((x) => x)),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
    lesson: Lesson.fromJson(json['lesson']),
    template: Template.fromJson(json['template']),
    feedback: json['feedback'] == null
        ? null
        : Feedback.fromJson(json['feedback']),
  );

  /// Document ID for this saved lesson.
  String id;

  /// Teacher associated with this lesson.
  String teacherId;

  /// The lesson ID associated with this plan.
  String lessonId;

  /// Whether this structure represents a lesson entity.
  bool isLesson;

  /// Current status (e.g., draft, active).
  String status;

  /// Whether the lesson was AI-generated.
  bool isGenerated;

  /// List of learning outcomes tied to this lesson.
  List<String> learningOutcomes;

  /// Whether the teacher completed the lesson plan.
  bool isCompleted;

  /// Indicates whether the lesson is deleted.
  bool isDeleted;

  /// Whether the lesson contains selected video content.
  bool isVideoSelected;

  /// Main lesson plan sections (structured as [DatumSection]).
  List<DatumSection> sections;

  /// Main learning resources.
  List<dynamic> resources;

  /// Additional external resources.
  List<dynamic> additionalResources;

  /// Instruction steps for the lesson.
  List<dynamic> instructionSet;

  /// Created timestamp.
  DateTime createdAt;

  /// Last updated timestamp.
  DateTime updatedAt;

  /// MongoDB version key.
  int v;

  /// The lesson metadata such as name, subject, class.
  Lesson lesson;

  /// Template used to generate the lesson.
  Template template;

  /// Optional teacher feedback.
  Feedback? feedback;

  /// Converts this class into JSON.
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
    'sections': List<dynamic>.from(
      sections.map((DatumSection x) => x.toJson()),
    ),
    'resources': List<dynamic>.from(resources.map((x) => x)),
    'additionalResources': List<dynamic>.from(
      additionalResources.map((x) => x),
    ),
    'instructionSet': List<dynamic>.from(instructionSet.map((x) => x)),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
    'lesson': lesson.toJson(),
    'template': template.toJson(),
    "feedback": feedback?.toJson(),
  };
}

/// Represents user feedback on a lesson plan.
///
/// Contains:
/// - Feedback category (good/bad/etc)
/// - Optional reason
/// - Creation & update timestamps
class Feedback {
  /// Creates a new feedback entry.
  Feedback({
    required this.id,
    required this.feedback,
    required this.createdAt,
    required this.updatedAt,
    this.overallFeedbackReason,
  });

  /// Parses feedback details from JSON.
  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    id: json['_id'],
    feedback: json['feedback'],
    overallFeedbackReason: json['overallFeedbackReason'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  /// Document ID for feedback.
  String id;

  /// "Positive", "Negative", or similar feedback value.
  String feedback;

  /// Optional user-written feedback reason.
  String? overallFeedbackReason;

  /// Created timestamp.
  DateTime createdAt;

  /// Updated timestamp.
  DateTime updatedAt;

  /// Converts this to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'feedback': feedback,
    'overallFeedbackReason': overallFeedbackReason,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// Represents lesson metadata such as:
/// - Name
/// - Class
/// - Subject
/// - Subtopics
/// - Teaching model
/// - Learning outcomes
/// - Videos
class Lesson {
  Lesson({
    required this.id,
    required this.name,
    required this.lessonClass,
    required this.isAll,
    required this.subject,
    required this.subTopics,
    required this.teachingModel,
    required this.learningOutcomes,
    required this.templateId,
    required this.chapter,
    required this.subjects,
    required this.videos,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['_id'],
    name: json['name'],
    lessonClass: json['class'],
    isAll: json['isAll'],
    subject: json['subject'],
    subTopics: List<String>.from(json['subTopics'].map((x) => x)),
    teachingModel: List<dynamic>.from(json['teachingModel'].map((x) => x)),
    learningOutcomes: List<String>.from(json['learningOutcomes'].map((x) => x)),
    templateId: json['templateId'],
    chapter: Chapter.fromJson(json['chapter']),
    subjects: Subjects.fromJson(json['subjects']),
    videos: List<Video>.from(json['videos'].map((x) => Video.fromJson(x))),
  );

  String id;
  String name;
  int lessonClass;
  bool isAll;
  String subject;
  List<String> subTopics;
  List<dynamic> teachingModel;
  List<String> learningOutcomes;
  String templateId;
  Chapter chapter;
  Subjects subjects;
  List<Video> videos;

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'class': lessonClass,
    'isAll': isAll,
    'subject': subject,
    'subTopics': List<dynamic>.from(subTopics.map((x) => x)),
    'teachingModel': List<dynamic>.from(teachingModel.map((x) => x)),
    'learningOutcomes': List<dynamic>.from(learningOutcomes.map((x) => x)),
    'templateId': templateId,
    'chapter': chapter.toJson(),
    'subjects': subjects.toJson(),
    'videos': List<dynamic>.from(videos.map((x) => x.toJson())),
  };
}

/// Represents the chapter metadata associated with a lesson.
class Chapter {
  Chapter({
    required this.id,
    required this.topics,
    required this.subTopics,
    required this.medium,
    required this.board,
    required this.orderNumber,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json['_id'],
    topics: json['topics'],
    subTopics: List<String>.from(json['subTopics'].map((x) => x)),
    medium: json['medium'],
    board: json['board'],
    orderNumber: json['orderNumber'],
  );

  String id;
  String topics;
  List<String> subTopics;
  String medium;
  String board;
  int orderNumber;

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'topics': topics,
    'subTopics': List<dynamic>.from(subTopics.map((x) => x)),
    'medium': medium,
    'board': board,
    'orderNumber': orderNumber,
  };
}

/// Represents subject data inside lesson metadata.
class Subjects {
  Subjects({required this.name, required this.sem});

  factory Subjects.fromJson(Map<String, dynamic> json) =>
      Subjects(name: json['name'], sem: json['sem']);

  String name;
  int sem;

  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'sem': sem};
}

/// Represents video resources inside a lesson.
class Video {
  Video({
    required this.title,
    required this.url,
    required this.selected,
    required this.id,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    title: json['title'],
    url: json['url'],
    selected: json['selected'],
    id: json['_id'],
  );

  String title;
  String url;
  bool selected;
  String id;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'url': url,
    'selected': selected,
    '_id': id,
  };
}

/// Represents 5E model content blocks.
class ContentClass {
  ContentClass({
    required this.engage,
    required this.explore,
    required this.explain,
    required this.elaborate,
    required this.evaluate,
  });

  factory ContentClass.fromJson(Map<String, dynamic> json) => ContentClass(
    engage: Elaborate.fromJson(json['engage']),
    explore: Elaborate.fromJson(json['explore']),
    explain: Elaborate.fromJson(json['explain']),
    elaborate: Elaborate.fromJson(json['elaborate']),
    evaluate: Elaborate.fromJson(json['evaluate']),
  );

  Elaborate engage;
  Elaborate explore;
  Elaborate explain;
  Elaborate elaborate;
  Elaborate evaluate;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'engage': engage.toJson(),
    'explore': explore.toJson(),
    'explain': explain.toJson(),
    'elaborate': elaborate.toJson(),
    'evaluate': evaluate.toJson(),
  };
}

/// Represents activity & material details for the 5E phases.
class Elaborate {
  Elaborate({required this.activity, required this.materials});

  factory Elaborate.fromJson(Map<String, dynamic> json) =>
      Elaborate(activity: json['activity'], materials: json['materials']);

  String activity;
  String materials;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'activity': activity,
    'materials': materials,
  };
}

/// Represents the template used to generate a lesson plan.
///
/// Includes:
/// - Template name
/// - Boards & mediums supported
/// - Sections definition
/// - Approval metadata
class Template {
  Template({
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

  factory Template.fromJson(Map<String, dynamic> json) => Template(
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
    sections: List<TemplateSection>.from(
      json['sections'].map((x) => TemplateSection.fromJson(x)),
    ),
    isActive: json['isActive'],
    status: json['status'],
    approvedBy: json['approvedBy'],
    approvedAt: DateTime.parse(json['approvedAt']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  String id;
  String name;
  String workFlowId;
  String model;
  String description;
  List<String> boards;
  List<String> mediums;
  List<int> classes;
  List<String> subjects;
  String type;
  List<TemplateSection> sections;
  bool isActive;
  String status;
  String approvedBy;
  DateTime approvedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'workFlowId': workFlowId,
    'model': model,
    'description': description,
    'boards': List<dynamic>.from(boards.map((x) => x)),
    'mediums': List<dynamic>.from(mediums.map((x) => x)),
    'classes': List<dynamic>.from(classes.map((x) => x)),
    'subjects': List<dynamic>.from(subjects.map((x) => x)),
    'type': type,
    'sections': List<dynamic>.from(sections.map((x) => x.toJson())),
    'isActive': isActive,
    'status': status,
    'approvedBy': approvedBy,
    'approvedAt': approvedAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}

/// Represents a single template section such as:
/// - Engage
/// - Explore
/// - Explain
/// - Elaborate
/// - Evaluate
class TemplateSection {
  TemplateSection({
    required this.sectionId,
    required this.title,
    required this.description,
    required this.outputFormat,
    required this.textbookContent,
    required this.dependencies,
    required this.id,
    required this.mode,
  });

  factory TemplateSection.fromJson(Map<String, dynamic> json) =>
      TemplateSection(
        sectionId: json['id'],
        title: json['title'],
        description: json['description'],
        outputFormat: json['outputFormat'],
        textbookContent: json['textbookContent'],
        dependencies: List<Dependency>.from(
          json['dependencies'].map((x) => Dependency.fromJson(x)),
        ),
        id: json['_id'],
        mode: json['mode'],
      );

  String sectionId;
  String title;
  String description;
  String outputFormat;
  bool textbookContent;
  List<Dependency> dependencies;
  String id;
  String mode;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': sectionId,
    'title': title,
    'description': description,
    'outputFormat': outputFormat,
    'textbookContent': textbookContent,
    'dependencies': List<dynamic>.from(dependencies.map((x) => x.toJson())),
    '_id': id,
    'mode': mode,
  };
}

/// Represents a dependency between lesson template sections.
class Dependency {
  Dependency({required this.sectionId});

  factory Dependency.fromJson(Map<String, dynamic> json) =>
      Dependency(sectionId: json['section_id']);

  /// ID of dependent section.
  String sectionId;

  Map<String, dynamic> toJson() => <String, dynamic>{'section_id': sectionId};
}
