// To parse this JSON data, do
//
//     final generateResourceResponseModel = generateResourceResponseModelFromJson(jsonString);

import 'dart:convert';

/// A function to convert a JSON string to a [GenerateResourceResponseModel] object.
GenerateResourceResponseModel generateResourceResponseModelFromJson(
  String str,
) => GenerateResourceResponseModel.fromJson(json.decode(str));

/// A function to convert a [GenerateResourceResponseModel] object to a JSON string.
String generateResourceResponseModelToJson(
  GenerateResourceResponseModel data,
) => json.encode(data.toJson());

/// A model class for the response of the generate resource API.
class GenerateResourceResponseModel {
  /// Creates a [GenerateResourceResponseModel] object.
  GenerateResourceResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [GenerateResourceResponseModel] object from a JSON map.
  factory GenerateResourceResponseModel.fromJson(Map<String, dynamic> json) =>
      GenerateResourceResponseModel(
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

  /// Converts the [GenerateResourceResponseModel] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': List<dynamic>.from(data.map((Datum x) => x.toJson())),
  };
}

/// A model class for the data object in the generate resource response.
class Datum {
  /// Creates a [Datum] object.
  Datum({
    required this.id,
    required this.lessonName,
    required this.medium,
    this.lessonId,
    required this.datumClass,
    required this.isAll,
    required this.board,
    required this.subject,
    required this.semester,
    required this.chapterId,
    required this.subTopics,
    required this.learningOutcomes,
    required this.resources,
    required this.additionalResources,
    required this.v,
    required this.templateId,
    required this.chapter,
    required this.subjects,
    required this.template,
    this.videos,
  });

  /// Creates a [Datum] object from a JSON map.
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['_id'],
    lessonName: json['lessonName'],
    medium: json['medium'],
    lessonId: json['lessonId'],
    datumClass: json['class'],
    isAll: json['isAll'],
    board: json['board'],
    subject: json['subject'],
    semester: json['semester'],
    chapterId: json['chapterId'],
    subTopics: List<String>.from(json['subTopics'].map((x) => x)),
    learningOutcomes: List<String>.from(json['learningOutcomes'].map((x) => x)),
    resources: List<Resource>.from(
      json['resources'].map((x) => Resource.fromJson(x)),
    ),
    additionalResources:
        json['additionalResources']?.map((x) => x).toList() ?? [],

    v: json['__v'],
    templateId: json['templateId'],
    chapter: Chapter.fromJson(json['chapter']),
    subjects: Subjects.fromJson(json['subjects']),
    template: Template.fromJson(json['template']),
    videos: json['videos'] == null
        ? null
        : List<Video>.from(json['videos'].map((x) => Video.fromJson(x))),
  );

  /// The ID of the data object.
  String id;

  /// The name of the lesson.
  String lessonName;

  /// The medium of the lesson.
  String medium;

  /// The ID of the lesson.
  String? lessonId;

  /// The class of the lesson.
  int datumClass;

  /// Whether this data object is for all subtopics.
  bool isAll;

  /// The board of the lesson.
  String board;

  /// The subject of the lesson.
  String subject;

  /// The semester of the lesson.
  String semester;

  /// The ID of the chapter.
  String chapterId;

  /// A list of subtopics.
  List<String> subTopics;

  /// A list of learning outcomes.
  List<String> learningOutcomes;

  /// A list of resources.
  List<Resource> resources;

  /// A list of additional resources.
  List<dynamic> additionalResources;

  /// The version of the data object.
  int v;

  /// The ID of the template.
  String templateId;

  /// The chapter object.
  Chapter chapter;

  /// The subjects object.
  Subjects subjects;

  /// The template object.
  Template template;

  /// A list of videos.
  List<Video>? videos;

  /// Converts the [Datum] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'lessonName': lessonName,
    'medium': medium,
    'lessonId': lessonId,
    'class': datumClass,
    'isAll': isAll,
    'board': board,
    'subject': subject,
    'semester': semester,
    'chapterId': chapterId,
    'subTopics': List<dynamic>.from(subTopics.map((String x) => x)),
    'learningOutcomes': List<dynamic>.from(
      learningOutcomes.map((String x) => x),
    ),
    'resources': List<dynamic>.from(resources.map((Resource x) => x.toJson())),
    'additionalResources': List<dynamic>.from(
      additionalResources.map((x) => x),
    ),
    '__v': v,
    'templateId': templateId,
    'chapter': chapter.toJson(),
    'subjects': subjects.toJson(),
    'template': template.toJson(),
    'videos': videos == null
        ? null
        : List<dynamic>.from(videos!.map((Video x) => x.toJson())),
  };
}

/// A model class for a video object.
class Video {
  /// Creates a [Video] object.
  Video({
    required this.title,
    required this.url,
    required this.selected,
    required this.id,
  });

  /// Creates a [Video] object from a JSON map.
  factory Video.fromJson(Map<String, dynamic> json) => Video(
    title: json['title'],
    url: json['url'],
    selected: json['selected'],
    id: json['_id'],
  );

  /// The title of the video.
  String title;

  /// The URL of the video.
  String url;

  /// Whether the video is selected.
  bool selected;

  /// The ID of the video.
  String id;

  /// Converts the [Video] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'url': url,
    'selected': selected,
    '_id': id,
  };
}

/// A model class for a chapter object.
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
    required this.indexPath,
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
    indexPath: json['indexPath'],
    learningOutcomes: json['learningOutcomes'] == null
        ? []
        : List<String>.from(json['learningOutcomes'].map((x) => x)),
    topicsLearningOutcomes:
        (json['topicsLearningOutcomes'] as List<dynamic>?)
            ?.map(
              (x) => TopicsLearningOutcome.fromJson(x as Map<String, dynamic>),
            )
            .toList() ??
        [],
  );

  /// The ID of the chapter.
  String id;

  /// The ID of the subject.
  String subjectId;

  /// The topics of the chapter.
  String topics;

  /// A list of subtopics.
  List<String> subTopics;

  /// The medium of the chapter.
  String medium;

  /// The standard of the chapter.
  int standard;

  /// The board of the chapter.
  String board;

  /// The order number of the chapter.
  int orderNumber;

  /// Whether the chapter is deleted.
  bool isDeleted;

  /// The creation date of the chapter.
  DateTime createdAt;

  /// The last update date of the chapter.
  DateTime updatedAt;

  /// The version of the chapter.
  int v;

  /// The index path of the chapter.
  String indexPath;

  /// A list of learning outcomes.
  List<String> learningOutcomes;

  /// A list of topics learning outcomes.
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
    'indexPath': indexPath,
    'learningOutcomes': List<dynamic>.from(
      learningOutcomes.map((String x) => x),
    ),
    'topicsLearningOutcomes': List<dynamic>.from(
      topicsLearningOutcomes.map((TopicsLearningOutcome x) => x.toJson()),
    ),
  };
}

/// A model class for a topics learning outcome object.
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

  /// The title of the topics learning outcome.
  String title;

  /// A list of learning outcomes.
  List<String> learningOutcomes;

  /// The ID of the topics learning outcome.
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

/// A model class for a resource object.
class Resource {
  /// Creates a [Resource] object.
  Resource({
    required this.id,
    required this.title,
    required this.outputFormat,
    required this.content,
  });

  /// Creates a [Resource] object from a JSON map.
  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json['id'],
    title: json['title'],
    outputFormat: json['outputFormat'],
    content: List<ResourceContent>.from(
      json['content'].map((x) => ResourceContent.fromJson(x)),
    ),
  );

  /// The ID of the resource.
  String id;

  /// The title of the resource.
  String title;

  /// The output format of the resource.
  String outputFormat;

  /// A list of resource content.
  List<ResourceContent> content;

  /// Converts the [Resource] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title': title,
    'outputFormat': outputFormat,
    'content': List<dynamic>.from(
      content.map((ResourceContent x) => x.toJson()),
    ),
  };
}

/// A model class for a resource content object.
class ResourceContent {
  /// Creates a [ResourceContent] object.
  ResourceContent({
    this.difficulty,
    this.content,
    this.id,
    this.title,
    this.preparation,
    this.requiredMaterials,
    this.obtainingMaterials,
    this.recap,
    this.media,
    this.rating,
    this.aggregateRating,
  });

  /// Creates a [ResourceContent] object from a JSON map.
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
        media: json['media'] == null
            ? null
            : List<Media>.from(json['media'].map((x) => Media.fromJson(x))),
        rating: json['rating'] == null ? null : Rating.fromJson(json['rating']),
        aggregateRating: json['aggregateRating'] == null
            ? null
            : AggregateRating.fromJson(json['aggregateRating']),
      );

  /// The difficulty of the resource content.
  String? difficulty;

  /// A list of content.
  List<ContentContent>? content;

  /// The ID of the resource content.
  String? id;

  /// The title of the resource content.
  String? title;

  /// The preparation instructions.
  String? preparation;

  /// The required materials.
  String? requiredMaterials;

  /// The instructions for obtaining materials.
  String? obtainingMaterials;

  /// The recap of the resource content.
  String? recap;

  /// A list of media.
  List<Media>? media;

  Rating? rating;
  AggregateRating? aggregateRating;

  /// Converts the [ResourceContent] object to a JSON map.
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
    'media': media == null
        ? null
        : List<dynamic>.from(media!.map((x) => x.toJson())),
    'rating': rating?.toJson(),
    'aggregateRating': aggregateRating?.toJson(),
  };
}

class Rating {
  /// Creates a [Rating] object.
  Rating({
    required this.performed,
    required this.engagement,
    required this.alignment,
    required this.application,
    this.notPerformedReason,
    required this.stars,
    required this.updatedAt,
  });

  /// Creates a [Rating] object from a JSON map.
  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    performed: json['performed'],
    engagement: json['engagement'],
    alignment: json['alignment'],
    application: json['application'],
    notPerformedReason: json['notPerformedReason'],
    stars: json['stars'],
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  /// Indicates whether the activity was performed.
  bool performed;

  /// Engagement level of the activity.
  String engagement;

  /// Alignment with learning outcomes.
  String alignment;

  /// Application relevance.
  String application;

  /// Reason if not performed.
  String? notPerformedReason;

  /// Star rating (1-5).
  int stars;

  /// Last updated timestamp.
  DateTime updatedAt;

  /// Converts this [Rating] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'performed': performed,
    'engagement': engagement,
    'alignment': alignment,
    'application': application,
    'notPerformedReason': notPerformedReason,
    'stars': stars,
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// A model representing aggregate ratings for an activity.
class AggregateRating {
  /// Creates an [AggregateRating] object.
  AggregateRating({
    required this.averageStars,
    required this.totalReviews,
    required this.engagementCounts,
    required this.alignmentCounts,
    required this.applicationCounts,
    required this.notPerformedCounts,
  });

  /// Creates an [AggregateRating] object from a JSON map.
  factory AggregateRating.fromJson(Map<String, dynamic> json) =>
      AggregateRating(
        averageStars: (json['averageStars'] ?? 0).toDouble(),
        totalReviews: json['totalReviews'],
        engagementCounts: Map<String, int>.from(json['engagementCounts']),
        alignmentCounts: Map<String, int>.from(json['alignmentCounts']),
        applicationCounts: Map<String, int>.from(json['applicationCounts']),
        notPerformedCounts: Map<String, int>.from(json['notPerformedCounts']),
      );

  /// Average star rating across all reviews.
  double averageStars;

  /// Total number of reviews.
  int totalReviews;

  /// Engagement level counts.
  Map<String, int> engagementCounts;

  /// Alignment level counts.
  Map<String, int> alignmentCounts;

  /// Application relevance counts.
  Map<String, int> applicationCounts;

  /// Not performed reason counts.
  Map<String, int> notPerformedCounts;

  /// Converts this [AggregateRating] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'averageStars': averageStars,
    'totalReviews': totalReviews,
    'engagementCounts': engagementCounts,
    'alignmentCounts': alignmentCounts,
    'applicationCounts': applicationCounts,
    'notPerformedCounts': notPerformedCounts,
  };
}

/// A model class for a media object.
class Media {
  /// Creates a [Media] object.
  Media({this.id, this.type, this.link, this.uploadedAt});

  /// Creates a [Media] object from a JSON map.
  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["_id"],
    type: json["type"],
    link: json["link"],
    uploadedAt: json["uploadedAt"],
  );

  /// The ID of the media.
  String? id;

  /// The type of the media.
  String? type;

  /// The link of the media.
  String? link;

  /// The upload date of the media.
  String? uploadedAt;

  /// Converts the [Media] object to a JSON map.
  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "link": link,
    "uploadedAt": uploadedAt,
  };
}

/// A model class for a content object.
class ContentContent {
  /// Creates a [ContentContent] object.
  ContentContent({
    this.type,
    this.questions,
    this.title,
    this.question,
    this.description,
  });

  /// Creates a [ContentContent] object from a JSON map.
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

  /// The question of the content.
  String? question;

  /// The description of the content.
  String? description;

  /// Converts the [ContentContent] object to a JSON map.
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

/// A model class for a question object.
class Question {
  /// Creates a [Question] object.
  Question({required this.question, this.options});

  /// Creates a [Question] object from a JSON map.
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

  /// Converts the [Question] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'question': question,
    'options': options == null
        ? <dynamic>[]
        : List<dynamic>.from(options!.map((String x) => x)),
  };
}

/// A model class for a subjects object.
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

  /// The ID of the subjects object.
  String id;

  /// The name of the subject.
  String subjectName;

  /// The name of the subject.
  String name;

  /// The semester of the subject.
  int sem;

  /// A list of boards.
  List<String> boards;

  /// Whether the subject is deleted.
  bool isDeleted;

  /// The creation date of the subject.
  DateTime createdAt;

  /// The last update date of the subject.
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

/// A model class for a template object.
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
