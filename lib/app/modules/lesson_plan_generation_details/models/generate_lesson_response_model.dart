// To parse this JSON data, do
//
//     final generateLessonResponseModel = generateLessonResponseModelFromJson(jsonString);

import 'dart:convert';

/// A function to convert a JSON string into a [GenerateLessonResponseModel] object.
GenerateLessonResponseModel generateLessonResponseModelFromJson(String str) =>
    GenerateLessonResponseModel.fromJson(json.decode(str));

/// A function to convert a [GenerateLessonResponseModel] object into a JSON string.
String generateLessonResponseModelToJson(GenerateLessonResponseModel data) =>
    json.encode(data.toJson());

/// A model class that represents the response from the lesson generation API.
class GenerateLessonResponseModel {
  /// Creates a [GenerateLessonResponseModel] object.
  GenerateLessonResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [GenerateLessonResponseModel] object from a JSON map.
  factory GenerateLessonResponseModel.fromJson(Map<String, dynamic> json) =>
      GenerateLessonResponseModel(
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

  /// Converts the [GenerateLessonResponseModel] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': List<dynamic>.from(data.map((Datum x) => x.toJson())),
  };
}

/// A model class that represents a single lesson plan.
class Datum {
  /// Creates a [Datum] object.
  Datum({
    required this.id,
    required this.name,
    required this.datumClass,
    required this.isAll,
    required this.board,
    required this.medium,
    required this.semester,
    required this.subject,
    required this.chapterId,
    required this.isRegenerated,
    required this.subTopics,
    required this.teachingModel,
    required this.learningOutcomes,
    required this.extractedResources,
    required this.videos,
    required this.documents,
    required this.interactOutput,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.templateId,
    required this.sections,
    required this.chapter,
    required this.subjects,
    required this.template,
  });

  /// Creates a [Datum] object from a JSON map.
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['_id'],
    name: json['name'],
    datumClass: json['class'],
    isAll: json['isAll'],
    board: json['board'],
    medium: json['medium'],
    semester: json['semester'],
    subject: json['subject'],
    chapterId: json['chapterId'],
    isRegenerated: json['isRegenerated'],
    subTopics: List<String>.from(json['subTopics'].map((x) => x)),
    teachingModel: List<dynamic>.from(json['teachingModel'].map((x) => x)),
    learningOutcomes: List<String>.from(json['learningOutcomes'].map((x) => x)),
    extractedResources: List<dynamic>.from(
      json['extractedResources'].map((x) => x),
    ),
    videos: List<dynamic>.from(json['videos'].map((x) => x)),
    documents: List<dynamic>.from(json['documents'].map((x) => x)),
    interactOutput: List<String>.from(json['interactOutput'].map((x) => x)),
    isDeleted: json['isDeleted'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
    templateId: json['templateId'],
    sections: List<DatumSection>.from(
      json['sections'].map((x) => DatumSection.fromJson(x)),
    ),
    chapter: Chapter.fromJson(json['chapter']),
    subjects: Subjects.fromJson(json['subjects']),
    template: Template.fromJson(json['template']),
  );

  /// The ID of the lesson plan.
  String id;

  /// The name of the lesson plan.
  String name;

  /// The class for which the lesson plan is intended.
  int datumClass;

  /// Whether the lesson plan is for all sub-topics.
  bool isAll;

  /// The board for which the lesson plan is intended.
  String board;

  /// The medium of instruction for the lesson plan.
  String medium;

  /// The semester for which the lesson plan is intended.
  String semester;

  /// The subject for which the lesson plan is intended.
  String subject;

  /// The ID of the chapter to which the lesson plan belongs.
  String chapterId;

  /// Whether the lesson plan has been regenerated.
  bool isRegenerated;

  /// The sub-topics covered in the lesson plan.
  List<String> subTopics;

  /// The teaching model used in the lesson plan.
  List<dynamic> teachingModel;

  /// The learning outcomes of the lesson plan.
  List<String> learningOutcomes;

  /// The resources extracted for the lesson plan.
  List<dynamic> extractedResources;

  /// The videos included in the lesson plan.
  List<dynamic> videos;

  /// The documents included in the lesson plan.
  List<dynamic> documents;

  /// The interactive output of the lesson plan.
  List<String> interactOutput;

  /// Whether the lesson plan has been deleted.
  bool isDeleted;

  /// The date and time when the lesson plan was created.
  DateTime createdAt;

  /// The date and time when the lesson plan was last updated.
  DateTime updatedAt;

  /// The version of the lesson plan.
  int v;

  /// The ID of the template used for the lesson plan.
  String templateId;

  /// The sections of the lesson plan.
  List<DatumSection> sections;

  /// The chapter to which the lesson plan belongs.
  Chapter chapter;

  /// The subjects covered in the lesson plan.
  Subjects subjects;

  /// The template used for the lesson plan.
  Template template;

  /// Converts the [Datum] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'class': datumClass,
    'isAll': isAll,
    'board': board,
    'medium': medium,
    'semester': semester,
    'subject': subject,
    'chapterId': chapterId,
    'isRegenerated': isRegenerated,
    'subTopics': List<dynamic>.from(subTopics.map((String x) => x)),
    'teachingModel': List<dynamic>.from(teachingModel.map((x) => x)),
    'learningOutcomes': List<dynamic>.from(
      learningOutcomes.map((String x) => x),
    ),
    'extractedResources': List<dynamic>.from(extractedResources.map((x) => x)),
    'videos': List<dynamic>.from(videos.map((x) => x)),
    'documents': List<dynamic>.from(documents.map((x) => x)),
    'interactOutput': List<dynamic>.from(interactOutput.map((String x) => x)),
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
    'templateId': templateId,
    'sections': List<dynamic>.from(
      sections.map((DatumSection x) => x.toJson()),
    ),
    'chapter': chapter.toJson(),
    'subjects': subjects.toJson(),
    'template': template.toJson(),
  };
}

/// A model class that represents a chapter.
class Chapter {
  /// Creates a [Chapter] object.
  Chapter({
    required this.id,
    required this.subjectId,
    required this.topics,
    required this.subTopics,
    required this.medium,
    required this.standard,
    required this.board,
    required this.orderNumber,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    // required this.indexPath,
    required this.learningOutcomes,
    required this.topicsLearningOutcomes,
  });

  /// Creates a [Chapter] object from a JSON map.
  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json['_id'],
    subjectId: json['subjectId'],
    topics: json['topics'],
    subTopics: List<String>.from(json['subTopics'].map((x) => x)),
    medium: json['medium'],
    standard: json['standard'],
    board: json['board'],
    orderNumber: json['orderNumber'],
    isDeleted: json['isDeleted'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
    //  indexPath: json['indexPath'],
    learningOutcomes: List<String>.from(json['learningOutcomes'].map((x) => x)),
    topicsLearningOutcomes: List<TopicsLearningOutcome>.from(
      json['topicsLearningOutcomes'].map(
        (x) => TopicsLearningOutcome.fromJson(x),
      ),
    ),
  );

  /// The ID of the chapter.
  String id;

  /// The ID of the subject to which the chapter belongs.
  String subjectId;

  /// The topics in the chapter.
  String topics;

  /// The sub-topics in the chapter.
  List<String> subTopics;

  /// The medium of instruction for the chapter.
  String medium;

  /// The standard of the chapter.
  int standard;

  /// The board to which the chapter belongs.
  String board;

  /// The order number of the chapter.
  int orderNumber;

  /// Whether the chapter has been deleted.
  bool isDeleted;

  /// The date and time when the chapter was created.
  DateTime createdAt;

  /// The date and time when the chapter was last updated.
  DateTime updatedAt;

  /// The version of the chapter.
  int v;

  /// The index path of the chapter.
  // String indexPath;
  /// The learning outcomes of the chapter.
  List<String> learningOutcomes;

  /// The learning outcomes for each topic in the chapter.
  List<TopicsLearningOutcome> topicsLearningOutcomes;

  /// Converts the [Chapter] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subjectId': subjectId,
    'topics': topics,
    'subTopics': List<dynamic>.from(subTopics.map((String x) => x)),
    'medium': medium,
    'standard': standard,
    'board': board,
    'orderNumber': orderNumber,
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
    // 'indexPath': indexPath,
    'learningOutcomes': List<dynamic>.from(
      learningOutcomes.map((String x) => x),
    ),
    'topicsLearningOutcomes': List<dynamic>.from(
      topicsLearningOutcomes.map((TopicsLearningOutcome x) => x.toJson()),
    ),
  };
}

/// A model class that represents the learning outcomes for a topic.
class TopicsLearningOutcome {
  /// Creates a [TopicsLearningOutcome] object.
  TopicsLearningOutcome({
    required this.title,
    required this.learningOutcomes,
    required this.id,
  });

  /// Creates a [TopicsLearningOutcome] object from a JSON map.
  factory TopicsLearningOutcome.fromJson(Map<String, dynamic> json) =>
      TopicsLearningOutcome(
        title: json['title'],
        learningOutcomes: List<String>.from(
          json['learningOutcomes'].map((x) => x),
        ),
        id: json['_id'],
      );

  /// The title of the topic.
  String title;

  /// The learning outcomes for the topic.
  List<String> learningOutcomes;

  /// The ID of the topic.
  String id;

  /// Converts the [TopicsLearningOutcome] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'learningOutcomes': List<dynamic>.from(
      learningOutcomes.map((String x) => x),
    ),
    '_id': id,
  };
}

/// A model class that represents a section of a lesson plan.
class DatumSection {
  // String id;
  /// The ID of the section.
  String id;

  /// The title of the section.
  String title;

  /// The content of the section.
  dynamic content;

  /// The output format of the section.
  String outputFormat;

  /// The media included in the section.
  List<Media>? media;

  /// Creates a [DatumSection] object.
  DatumSection({
    //required this.id,
    required this.id,
    required this.title,
    required this.content,
    required this.outputFormat,
    this.media,
  });

  /// Creates a [DatumSection] object from a JSON map.
  factory DatumSection.fromJson(Map<String, dynamic> json) => DatumSection(
    //  id: json["_id"],
    id: json["id"],
    title: json["title"],
    content: json["content"],
    outputFormat: json["outputFormat"],
    media: json["media"] != null
        ? List<Media>.from(json["media"].map((x) => Media.fromJson(x)))
        : null, // Only map if present, else null
  );

  /// Converts the [DatumSection] object to a JSON map.
  Map<String, dynamic> toJson() => {
    //  "_id": id,
    "id": id,
    "title": title,
    "content": content,
    "outputFormat": outputFormat,
    "media": media != null
        ? List<dynamic>.from(media!.map((x) => x.toJson()))
        : null, // Only output if present
  };
}

/// A model class that represents a media item.
class Media {
  /// The title of the media item.
  String title;

  /// The type of the media item.
  String type;

  /// The link to the media item.
  String link;

  /// The ID of the media item.
  String id;

  /// The date and time when the media item was uploaded.
  DateTime uploadedAt;

  /// Creates a [Media] object.
  Media({
    required this.title,
    required this.type,
    required this.link,
    required this.id,
    required this.uploadedAt,
  });

  /// Creates a [Media] object from a JSON map.
  factory Media.fromJson(Map<String, dynamic> json) => Media(
    title: json["title"],
    type: json["type"],
    link: json["link"],
    id: json["_id"],
    uploadedAt: DateTime.parse(json["uploadedAt"]),
  );

  /// Converts the [Media] object to a JSON map.
  Map<String, dynamic> toJson() => {
    "title": title,
    "type": type,
    "link": link,
    "_id": id,
    "uploadedAt": uploadedAt.toIso8601String(),
  };
}

/// A model class that represents the content of a lesson plan.
class ContentClass {
  /// Creates a [ContentClass] object.
  ContentClass({
    required this.engage,
    required this.explore,
    required this.explain,
    required this.elaborate,
    required this.evaluate,
  });

  /// Creates a [ContentClass] object from a JSON map.
  factory ContentClass.fromJson(Map<String, dynamic> json) => ContentClass(
    engage: Elaborate.fromJson(json['engage']),
    explore: Elaborate.fromJson(json['explore']),
    explain: Elaborate.fromJson(json['explain']),
    elaborate: Elaborate.fromJson(json['elaborate']),
    evaluate: Elaborate.fromJson(json['evaluate']),
  );

  /// The engage section of the lesson plan.
  Elaborate engage;

  /// The explore section of the lesson plan.
  Elaborate explore;

  /// The explain section of the lesson plan.
  Elaborate explain;

  /// The elaborate section of the lesson plan.
  Elaborate elaborate;

  /// The evaluate section of the lesson plan.
  Elaborate evaluate;

  /// Converts the [ContentClass] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'engage': engage.toJson(),
    'explore': explore.toJson(),
    'explain': explain.toJson(),
    'elaborate': elaborate.toJson(),
    'evaluate': evaluate.toJson(),
  };
}

/// A model class that represents the elaborate section of a lesson plan.
class Elaborate {
  /// Creates an [Elaborate] object.
  Elaborate({required this.activity, required this.materials});

  /// Creates an [Elaborate] object from a JSON map.
  factory Elaborate.fromJson(Map<String, dynamic> json) =>
      Elaborate(activity: json['activity'], materials: json['materials']);

  /// The activity for the elaborate section.
  String activity;

  /// The materials for the elaborate section.
  String materials;

  /// Converts the [Elaborate] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'activity': activity,
    'materials': materials,
  };
}

/// A model class that represents a subject.
class Subjects {
  /// Creates a [Subjects] object.
  Subjects({
    required this.id,
    required this.subjectName,
    required this.name,
    required this.sem,
    required this.boards,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// Creates a [Subjects] object from a JSON map.
  factory Subjects.fromJson(Map<String, dynamic> json) => Subjects(
    id: json['_id'],
    subjectName: json['subjectName'],
    name: json['name'],
    sem: json['sem'],
    boards: List<String>.from(json['boards'].map((x) => x)),
    isDeleted: json['isDeleted'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The ID of the subject.
  String id;

  /// The name of the subject.
  String subjectName;

  /// The name of the subject.
  String name;

  /// The semester in which the subject is taught.
  int sem;

  /// The boards to which the subject belongs.
  List<String> boards;

  /// Whether the subject has been deleted.
  bool isDeleted;

  /// The date and time when the subject was created.
  DateTime createdAt;

  /// The date and time when the subject was last updated.
  DateTime updatedAt;

  /// The version of the subject.
  int v;

  /// Converts the [Subjects] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subjectName': subjectName,
    'name': name,
    'sem': sem,
    'boards': List<dynamic>.from(boards.map((String x) => x)),
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}

/// A model class that represents a template.
class Template {
  /// Creates a [Template] object.
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

  /// Creates a [Template] object from a JSON map.
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
  List<TemplateSection> sections;

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

  /// Converts the [Template] object to a JSON map.
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
    'sections': List<dynamic>.from(
      sections.map((TemplateSection x) => x.toJson()),
    ),
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
class TemplateSection {
  /// Creates a [TemplateSection] object.
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

  /// Creates a [TemplateSection] object from a JSON map.
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

  /// The ID of the section.
  String sectionId;

  /// The title of the section.
  String title;

  /// A description of the section.
  String description;

  /// The output format of the section.
  String outputFormat;

  /// Whether the section includes textbook content.
  bool textbookContent;

  /// The dependencies of the section.
  List<Dependency> dependencies;

  /// The ID of the section.
  String id;

  /// The mode of the section.
  String mode;

  /// Converts the [TemplateSection] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': sectionId,
    'title': title,
    'description': description,
    'outputFormat': outputFormat,
    'textbookContent': textbookContent,
    'dependencies': List<dynamic>.from(
      dependencies.map((Dependency x) => x.toJson()),
    ),
    '_id': id,
    'mode': mode,
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
