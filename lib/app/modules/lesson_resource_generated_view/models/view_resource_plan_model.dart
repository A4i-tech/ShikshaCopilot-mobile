// To parse this JSON data, do
//
//     final viewResourcePlanModel = viewResourcePlanModelFromJson(jsonString);

import 'dart:convert';

/// Creates a [ViewResourcePlanModel] from a JSON string.
ViewResourcePlanModel viewResourcePlanModelFromJson(String str) =>
    ViewResourcePlanModel.fromJson(json.decode(str));

/// Converts a [ViewResourcePlanModel] to a JSON string.
String viewResourcePlanModelToJson(ViewResourcePlanModel data) =>
    json.encode(data.toJson());

/// A model representing the view of a resource plan.
class ViewResourcePlanModel {
  /// Creates a [ViewResourcePlanModel].
  ViewResourcePlanModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [ViewResourcePlanModel] from a JSON map.
  factory ViewResourcePlanModel.fromJson(Map<String, dynamic> json) =>
      ViewResourcePlanModel(
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

  /// Converts this [ViewResourcePlanModel] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// A model representing the data of a resource plan view.
class Data {
  /// Creates a [Data] object.
  Data({
    required this.id,
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
    required this.learningOutcomes,
    required this.instructionSet,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.resource,
    required this.template,
    this.feedback,
    this.videos,
  });

  /// Creates a [Data] object from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['_id'],
    teacherId: json['teacherId'],
    resourceId: json['resourceId'],
    isLesson: json['isLesson'],
    status: json['status'],
    isGenerated: json['isGenerated'],
    resources: List<ResourceElement>.from(
      json['resources'].map((x) => ResourceElement.fromJson(x)),
    ),
    additionalResources: List<dynamic>.from(
      json['additionalResources'].map((x) => x),
    ),
    isCompleted: json['isCompleted'],
    isDeleted: json['isDeleted'],
    isVideoSelected: json['isVideoSelected'],
    sections: List<dynamic>.from(json['sections'].map((x) => x)),
    learningOutcomes: List<dynamic>.from(
      json['learningOutcomes'].map((x) => x),
    ),
    instructionSet: List<dynamic>.from(json['instructionSet'].map((x) => x)),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    v: json['__v'],
    resource: PurpleResource.fromJson(json['resource']),
    template: Template.fromJson(json['template']),
    feedback: json['feedback'] == null
        ? null
        : Feedback.fromJson(json['feedback']),
    videos: json['videos'] == null
        ? null
        : List<Video>.from(json['videos'].map((x) => Video.fromJson(x))),
  );

  /// The ID of the resource plan.
  String id;

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
  List<ResourceElement> resources;

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

  /// The resource details.
  PurpleResource resource;

  /// The template used for the resource plan.
  Template template;

  /// The feedback for the resource plan.
  Feedback? feedback;

  /// A list of videos associated with the resource plan.
  List<Video>? videos;

  /// Converts this [Data] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'teacherId': teacherId,
    'resourceId': resourceId,
    'isLesson': isLesson,
    'status': status,
    'isGenerated': isGenerated,
    'resources': List<dynamic>.from(
      resources.map((ResourceElement x) => x.toJson()),
    ),
    'additionalResources': List<dynamic>.from(
      additionalResources.map((x) => x),
    ),
    'isCompleted': isCompleted,
    'isDeleted': isDeleted,
    'isVideoSelected': isVideoSelected,
    'sections': List<dynamic>.from(sections.map((x) => x)),
    'learningOutcomes': List<dynamic>.from(learningOutcomes.map((x) => x)),
    'instructionSet': List<dynamic>.from(instructionSet.map((x) => x)),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
    'resource': resource.toJson(),
    'template': template.toJson(),
    'feedback': feedback?.toJson(),
    'videos': videos == null
        ? null
        : List<dynamic>.from(videos!.map((Video x) => x.toJson())),
  };
}

/// A model representing feedback.
class Feedback {
  /// Creates a [Feedback] object.
  Feedback({
    required this.id,
    required this.feedback,
    required this.createdAt,
    required this.updatedAt,
    this.overallFeedbackReason,
  });

  /// Creates a [Feedback] object from a JSON map.
  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    id: json['_id'],
    feedback: json['feedback'],
    overallFeedbackReason: json['overallFeedbackReason'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  /// The ID of the feedback.
  String id;

  /// The feedback content.
  String feedback;

  /// The reason for the overall feedback.
  String? overallFeedbackReason;

  /// The date and time when the feedback was created.
  DateTime createdAt;

  /// The date and time when the feedback was last updated.
  DateTime updatedAt;

  /// Converts this [Feedback] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'feedback': feedback,
    'overallFeedbackReason': overallFeedbackReason,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// A model representing a video.
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

  /// Indicates whether the video is selected.
  bool selected;

  /// The ID of the video.
  String id;

  /// Converts this [Video] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'url': url,
    'selected': selected,
    '_id': id,
  };
}

/// A model representing the purple resource.
class PurpleResource {
  /// Creates a [PurpleResource] object.
  PurpleResource({
    required this.id,
    required this.lessonName,
    required this.medium,
    this.lessonId,
    required this.resourceClass,
    required this.isAll,
    required this.board,
    required this.subject,
    required this.subTopics,
    required this.learningOutcomes,
    required this.templateId,
    required this.chapter,
    required this.subjects,
  });

  /// Creates a [PurpleResource] object from a JSON map.
  factory PurpleResource.fromJson(Map<String, dynamic> json) => PurpleResource(
    id: json['_id'],
    lessonName: json['lessonName'],
    medium: json['medium'],
    lessonId: json['lessonId'],
    resourceClass: json['class'],
    isAll: json['isAll'],
    board: json['board'],
    subject: json['subject'],
    subTopics: List<String>.from(json['subTopics'].map((x) => x)),
    learningOutcomes: List<String>.from(json['learningOutcomes'].map((x) => x)),
    templateId: json['templateId'],
    chapter: Chapter.fromJson(json['chapter']),
    subjects: Subjects.fromJson(json['subjects']),
  );

  /// The ID of the resource.
  String id;

  /// The name of the lesson.
  String lessonName;

  /// The medium of the lesson.
  String medium;

  /// The ID of the lesson.
  String? lessonId;

  /// The class of the resource.
  int resourceClass;

  /// Indicates whether this is for all.
  bool isAll;

  /// The board of the lesson.
  String board;

  /// The subject of the lesson.
  String subject;

  /// A list of sub-topics.
  List<String> subTopics;

  /// A list of learning outcomes.
  List<String> learningOutcomes;

  /// The ID of the template.
  String templateId;

  /// The chapter details.
  Chapter chapter;

  /// The subjects details.
  Subjects subjects;

  /// Converts this [PurpleResource] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'lessonName': lessonName,
    'medium': medium,
    'lessonId': lessonId,
    'class': resourceClass,
    'isAll': isAll,
    'board': board,
    'subject': subject,
    'subTopics': List<dynamic>.from(subTopics.map((String x) => x)),
    'learningOutcomes': List<dynamic>.from(
      learningOutcomes.map((String x) => x),
    ),
    'templateId': templateId,
    'chapter': chapter.toJson(),
    'subjects': subjects.toJson(),
  };
}

/// A model representing a chapter.
class Chapter {
  /// Creates a [Chapter] object.
  Chapter({
    required this.id,
    required this.topics,
    required this.subTopics,
    required this.medium,
    required this.board,
    required this.orderNumber,
  });

  /// Creates a [Chapter] object from a JSON map.
  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json['_id'],
    topics: json['topics'],
    subTopics: List<String>.from(json['subTopics'].map((x) => x)),
    medium: json['medium'],
    board: json['board'],
    orderNumber: json['orderNumber'],
  );

  /// The ID of the chapter.
  String id;

  /// The topics of the chapter.
  String topics;

  /// A list of sub-topics.
  List<String> subTopics;

  /// The medium of the chapter.
  String medium;

  /// The board of the chapter.
  String board;

  /// The order number of the chapter.
  int orderNumber;

  /// Converts this [Chapter] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'topics': topics,
    'subTopics': List<dynamic>.from(subTopics.map((String x) => x)),
    'medium': medium,
    'board': board,
    'orderNumber': orderNumber,
  };
}

/// A model representing subjects.
class Subjects {
  /// Creates a [Subjects] object.
  Subjects({required this.name, required this.sem});

  /// Creates a [Subjects] object from a JSON map.
  factory Subjects.fromJson(Map<String, dynamic> json) =>
      Subjects(name: json['name'], sem: json['sem']);

  /// The name of the subject.
  String name;

  /// The semester of the subject.
  int sem;

  /// Converts this [Subjects] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'sem': sem};
}

/// A model representing a resource element.
class ResourceElement {
  /// Creates a [ResourceElement] object.
  ResourceElement({
    required this.id,
    required this.title,
    required this.content,
    required this.outputFormat,
  });

  /// Creates a [ResourceElement] object from a JSON map.
  factory ResourceElement.fromJson(Map<String, dynamic> json) =>
      ResourceElement(
        id: json['id'],
        title: json['title'],
        content: List<ResourceContent>.from(
          json['content'].map((x) => ResourceContent.fromJson(x)),
        ),
        outputFormat: json['outputFormat'],
      );

  /// The ID of the resource element.
  String id;

  /// The title of the resource element.
  String title;

  /// The content of the resource element.
  List<ResourceContent> content;

  /// The output format of the resource element.
  String outputFormat;

  /// Converts this [ResourceElement] object to a JSON map.
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

  /// A list of media items.
  List<Media>? media;

  Rating? rating;
  AggregateRating? aggregateRating;

  /// Converts this [ResourceContent] object to a JSON map.
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

/// A model representing individual activity rating.
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

/// A model representing a media item.
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

  /// The ID of the media item.
  String? id;

  /// The type of the media item.
  String? type;

  /// The link to the media item.
  String? link;

  /// The upload date of the media item.
  String? uploadedAt;

  /// Converts this [Media] object to a JSON map.
  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "link": link,
    "uploadedAt": uploadedAt,
  };
}

/// A model representing a content item.
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

  /// The question.
  String? question;

  /// The description.
  String? description;

  /// Converts this [ContentContent] object to a JSON map.
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

  /// Converts this [Question] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'question': question,
    'options': options == null
        ? <dynamic>[]
        : List<dynamic>.from(options!.map((String x) => x)),
  };
}

/// A model representing a template.
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

  /// The model used for the template.
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

  /// A list of sections in the template.
  List<Section> sections;

  /// Indicates whether the template is active.
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

  /// Converts this [Template] object to a JSON map.
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

/// A model representing a section.
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

  /// Indicates whether the section has textbook content.
  bool textbookContent;

  /// A list of dependencies.
  List<dynamic> dependencies;

  /// The ID of the section.
  String id;

  /// The mode of the section.
  String mode;

  /// Converts this [Section] object to a JSON map.
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
