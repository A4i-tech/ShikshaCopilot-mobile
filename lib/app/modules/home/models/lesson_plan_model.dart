// To parse this JSON data, do
//
//     final lessonPlan = lessonPlanFromJson(jsonString);

import 'dart:convert';

/// Deserializes a JSON string into a [LessonPlan] object.
LessonPlan lessonPlanFromJson(String str) =>
    LessonPlan.fromJson(json.decode(str));

/// Serializes a [LessonPlan] object into a JSON string.
String lessonPlanToJson(LessonPlan data) => json.encode(data.toJson());

/// Represents a lesson plan.
class LessonPlan {
  /// Creates a new [LessonPlan] instance.
  LessonPlan({this.success, this.message, this.data});

  /// Creates a new [LessonPlan] instance from a JSON map.
  factory LessonPlan.fromJson(Map<String, dynamic> json) => LessonPlan(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null
        ? <Plan>[]
        : List<Plan>.from(json['data']!.map((x) => Plan.fromJson(x))),
  );
  /// Indicates whether the request was successful.
  final bool? success;
  /// A message providing details about the request status.
  final String? message;
  /// A list of plans.
  final List<Plan>? data;

  /// Creates a copy of this [LessonPlan] with the given fields replaced
  /// with the new values.
  LessonPlan copyWith({bool? success, String? message, List<Plan>? data}) =>
      LessonPlan(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  /// Converts this [LessonPlan] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data == null
        ? <dynamic>[]
        : List<dynamic>.from(data!.map((Plan x) => x.toJson())),
  };
}

/// Represents a single plan within a lesson plan.
class Plan {
  /// Creates a new [Plan] instance.
  Plan({
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
    this.resource,
  });

  /// Creates a new [Plan] instance from a JSON map.
  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json['_id'],
    isLesson: json['isLesson'],
    status: json['status'],
    isGenerated: json['isGenerated'],
    learningOutcomes: json['learningOutcomes'] == null
        ? <String>[]
        : List<String>.from(json['learningOutcomes']!.map((x) => x)),
    isCompleted: json['isCompleted'],
    resources: json['resources'] == null
        ? <ResourceElement>[]
        : List<ResourceElement>.from(
            json['resources']!.map((x) => ResourceElement.fromJson(x)),
          ),
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
    resource: json['resource'] == null
        ? null
        : PurpleResource.fromJson(json['resource']),
  );
  /// The unique identifier for the plan.
  final String? id;
  /// Indicates whether this is a lesson plan.
  final bool? isLesson;
  /// The status of the plan.
  final String? status;
  /// Indicates whether the plan has been generated.
  final bool? isGenerated;
  /// A list of learning outcomes.
  final List<String>? learningOutcomes;
  /// Indicates whether the plan is completed.
  final bool? isCompleted;
  /// A list of resources for the plan.
  final List<ResourceElement>? resources;
  /// A list of additional resources.
  final List<dynamic>? additionalResources;
  /// A list of instruction sets.
  final List<dynamic>? instructionSet;
  /// The date and time when the plan was created.
  final DateTime? createdAt;
  /// The date and time when the plan was last updated.
  final DateTime? updatedAt;
  /// The lesson associated with the plan.
  final Lesson? lesson;
  /// The month when the plan was created.
  final int? createdMonth;
  /// The resource associated with the plan.
  final PurpleResource? resource;

  /// Creates a copy of this [Plan] with the given fields replaced
  /// with the new values.
  Plan copyWith({
    String? id,
    bool? isLesson,
    String? status,
    bool? isGenerated,
    List<String>? learningOutcomes,
    bool? isCompleted,
    List<ResourceElement>? resources,
    List<dynamic>? additionalResources,
    List<dynamic>? instructionSet,
    DateTime? createdAt,
    DateTime? updatedAt,
    Lesson? lesson,
    int? createdMonth,
    PurpleResource? resource,
  }) => Plan(
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
    resource: resource ?? this.resource,
  );

  /// Converts this [Plan] to a JSON map.
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
        : List<dynamic>.from(resources!.map((ResourceElement x) => x.toJson())),
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
    'resource': resource?.toJson(),
  };
}

/// Represents a lesson.
class Lesson {
  /// Creates a new [Lesson] instance.
  Lesson({
    this.id,
    this.name,
    this.lessonClass,
    this.isAll,
    this.subject,
    this.subTopics,
    this.teachingModel,
    this.learningOutcomes,
    this.templateId,
    this.chapter,
    this.subjects,
    this.videos,
  });

  /// Creates a new [Lesson] instance from a JSON map.
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
    templateId: json['templateId'],
    chapter: json['chapter'] == null ? null : Chapter.fromJson(json['chapter']),
    subjects: json['subjects'] == null
        ? null
        : Subjects.fromJson(json['subjects']),
    videos: json['videos'] == null
        ? <dynamic>[]
        : List<dynamic>.from(json['videos']!.map((x) => x)),
  );
  /// The unique identifier for the lesson.
  final String? id;
  /// The name of the lesson.
  final String? name;
  /// The class the lesson is for.
  final int? lessonClass;
  /// Indicates whether the lesson is for all subjects.
  final bool? isAll;
  /// The subject of the lesson.
  final String? subject;
  /// A list of sub-topics for the lesson.
  final List<String>? subTopics;
  /// A list of teaching models for the lesson.
  final List<dynamic>? teachingModel;
  /// A list of learning outcomes for the lesson.
  final List<String>? learningOutcomes;
  /// The ID of the template used for the lesson.
  final String? templateId;
  /// The chapter associated with the lesson.
  final Chapter? chapter;
  /// The subjects associated with the lesson.
  final Subjects? subjects;
  /// A list of videos for the lesson.
  final List<dynamic>? videos;

  /// Creates a copy of this [Lesson] with the given fields replaced
  /// with the new values.
  Lesson copyWith({
    String? id,
    String? name,
    int? lessonClass,
    bool? isAll,
    String? subject,
    List<String>? subTopics,
    List<dynamic>? teachingModel,
    List<String>? learningOutcomes,
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
    templateId: templateId ?? this.templateId,
    chapter: chapter ?? this.chapter,
    subjects: subjects ?? this.subjects,
    videos: videos ?? this.videos,
  );

  /// Converts this [Lesson] to a JSON map.
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
    'templateId': templateId,
    'chapter': chapter?.toJson(),
    'subjects': subjects?.toJson(),
    'videos': videos == null
        ? <dynamic>[]
        : List<dynamic>.from(videos!.map((x) => x)),
  };
}

/// Represents a chapter.
class Chapter {
  /// Creates a new [Chapter] instance.
  Chapter({
    this.id,
    this.topics,
    this.subTopics,
    this.medium,
    this.board,
    this.orderNumber,
  });

  /// Creates a new [Chapter] instance from a JSON map.
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
  /// The unique identifier for the chapter.
  final String? id;
  /// The topics in the chapter.
  final String? topics;
  /// A list of sub-topics in the chapter.
  final List<String>? subTopics;
  /// The medium of the chapter.
  final String? medium;
  /// The board of the chapter.
  final String? board;
  /// The order number of the chapter.
  final int? orderNumber;

  /// Creates a copy of this [Chapter] with the given fields replaced
  /// with the new values.
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

  /// Converts this [Chapter] to a JSON map.
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

/// Represents a subject.
class Subjects {
  /// Creates a new [Subjects] instance.
  Subjects({this.name, this.sem});

  /// Creates a new [Subjects] instance from a JSON map.
  factory Subjects.fromJson(Map<String, dynamic> json) =>
      Subjects(name: json['name'], sem: json['sem']);
  /// The name of the subject.
  final String? name;
  /// The semester of the subject.
  final int? sem;

  /// Creates a copy of this [Subjects] with the given fields replaced
  /// with the new values.
  Subjects copyWith({String? name, int? sem}) =>
      Subjects(name: name ?? this.name, sem: sem ?? this.sem);

  /// Converts this [Subjects] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'sem': sem};
}

/// Represents a resource (purple variant).
class PurpleResource {
  /// Creates a new [PurpleResource] instance.
  PurpleResource({
    this.id,
    this.lessonName,
    this.medium,
    this.lessonId,
    this.resourceClass,
    this.isAll,
    this.board,
    this.subject,
    this.subTopics,
    this.learningOutcomes,
    this.templateId,
    this.chapter,
    this.subjects,
  });

  /// Creates a new [PurpleResource] instance from a JSON map.
  factory PurpleResource.fromJson(Map<String, dynamic> json) => PurpleResource(
    id: json['_id'],
    lessonName: json['lessonName'],
    medium: json['medium'],
    lessonId: json['lessonId'],
    resourceClass: json['class'],
    isAll: json['isAll'],
    board: json['board'],
    subject: json['subject'],
    subTopics: json['subTopics'] == null
        ? <String>[]
        : List<String>.from(json['subTopics']!.map((x) => x)),
    learningOutcomes: json['learningOutcomes'] == null
        ? <String>[]
        : List<String>.from(json['learningOutcomes']!.map((x) => x)),
    templateId: json['templateId'],
    chapter: json['chapter'] == null ? null : Chapter.fromJson(json['chapter']),
    subjects: json['subjects'] == null
        ? null
        : Subjects.fromJson(json['subjects']),
  );
  /// The unique identifier for the resource.
  final String? id;
  /// The name of the lesson.
  final String? lessonName;
  /// The medium of the resource.
  final String? medium;
  /// The ID of the lesson.
  final String? lessonId;
  /// The class the resource is for.
  final int? resourceClass;
  /// Indicates whether the resource is for all subjects.
  final bool? isAll;
  /// The board of the resource.
  final String? board;
  /// The subject of the resource.
  final String? subject;
  /// A list of sub-topics for the resource.
  final List<String>? subTopics;
  /// A list of learning outcomes for the resource.
  final List<String>? learningOutcomes;
  /// The ID of the template used for the resource.
  final String? templateId;
  /// The chapter associated with the resource.
  final Chapter? chapter;
  /// The subjects associated with the resource.
  final Subjects? subjects;

  /// Creates a copy of this [PurpleResource] with the given fields replaced
  /// with the new values.
  PurpleResource copyWith({
    String? id,
    String? lessonName,
    String? medium,
    String? lessonId,
    int? resourceClass,
    bool? isAll,
    String? board,
    String? subject,
    List<String>? subTopics,
    List<String>? learningOutcomes,
    String? templateId,
    Chapter? chapter,
    Subjects? subjects,
  }) => PurpleResource(
    id: id ?? this.id,
    lessonName: lessonName ?? this.lessonName,
    medium: medium ?? this.medium,
    lessonId: lessonId ?? this.lessonId,
    resourceClass: resourceClass ?? this.resourceClass,
    isAll: isAll ?? this.isAll,
    board: board ?? this.board,
    subject: subject ?? this.subject,
    subTopics: subTopics ?? this.subTopics,
    learningOutcomes: learningOutcomes ?? this.learningOutcomes,
    templateId: templateId ?? this.templateId,
    chapter: chapter ?? this.chapter,
    subjects: subjects ?? this.subjects,
  );

  /// Converts this [PurpleResource] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'lessonName': lessonName,
    'medium': medium,
    'lessonId': lessonId,
    'class': resourceClass,
    'isAll': isAll,
    'board': board,
    'subject': subject,
    'subTopics': subTopics == null
        ? <dynamic>[]
        : List<dynamic>.from(subTopics!.map((String x) => x)),
    'learningOutcomes': learningOutcomes == null
        ? <dynamic>[]
        : List<dynamic>.from(learningOutcomes!.map((String x) => x)),
    'templateId': templateId,
    'chapter': chapter?.toJson(),
    'subjects': subjects?.toJson(),
  };
}

/// Represents a resource element.
class ResourceElement {
  /// Creates a new [ResourceElement] instance.
  ResourceElement({this.id, this.title, this.content, this.outputFormat});

  /// Creates a new [ResourceElement] instance from a JSON map.
  factory ResourceElement.fromJson(Map<String, dynamic> json) =>
      ResourceElement(
        id: json['id'],
        title: json['title'],
        content: json['content'] == null
            ? <ResourceContent>[]
            : List<ResourceContent>.from(
                json['content']!.map((x) => ResourceContent.fromJson(x)),
              ),
        outputFormat: json['outputFormat'],
      );
  /// The unique identifier for the resource element.
  final String? id;
  /// The title of the resource element.
  final String? title;
  /// The content of the resource element.
  final List<ResourceContent>? content;
  /// The output format of the resource element.
  final String? outputFormat;

  /// Creates a copy of this [ResourceElement] with the given fields replaced
  /// with the new values.
  ResourceElement copyWith({
    String? id,
    String? title,
    List<ResourceContent>? content,
    String? outputFormat,
  }) => ResourceElement(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    outputFormat: outputFormat ?? this.outputFormat,
  );

  /// Converts this [ResourceElement] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title': title,
    'content': content == null
        ? <dynamic>[]
        : List<dynamic>.from(content!.map((ResourceContent x) => x.toJson())),
    'outputFormat': outputFormat,
  };
}

/// Represents the content of a resource.
class ResourceContent {
  /// Creates a new [ResourceContent] instance.
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

  /// Creates a new [ResourceContent] instance from a JSON map.
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
  /// The difficulty of the resource content.
  final String? difficulty;
  /// The content of the resource.
  final List<ContentContent>? content;
  /// The unique identifier for the resource content.
  final String? id;
  /// The title of the resource content.
  final String? title;
  /// The preparation instructions for the resource.
  final String? preparation;
  /// The required materials for the resource.
  final String? requiredMaterials;
  /// Instructions for obtaining materials for the resource.
  final String? obtainingMaterials;
  /// A recap of the resource content.
  final String? recap;

  /// Creates a copy of this [ResourceContent] with the given fields replaced
  /// with the new values.
  ResourceContent copyWith({
    String? difficulty,
    List<ContentContent>? content,
    String? id,
    String? title,
    String? preparation,
    String? requiredMaterials,
    String? obtainingMaterials,
    String? recap,
  }) => ResourceContent(
    difficulty: difficulty ?? this.difficulty,
    content: content ?? this.content,
    id: id ?? this.id,
    title: title ?? this.title,
    preparation: preparation ?? this.preparation,
    requiredMaterials: requiredMaterials ?? this.requiredMaterials,
    obtainingMaterials: obtainingMaterials ?? this.obtainingMaterials,
    recap: recap ?? this.recap,
  );

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

/// Represents the content within resource content.
class ContentContent {

  /// Creates a new [ContentContent] instance.
  ContentContent({
    this.type,
    this.questions,
    this.title,
    this.question,
    this.description,
  });
  /// Creates a new [ContentContent] instance from a JSON map.
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
  final String? type;
  /// A list of questions.
  final List<Question>? questions;
  /// The title of the content.
  final String? title;
  /// The question.
  final String? question;
  /// The description of the content.
  final String? description;

  /// Creates a copy of this [ContentContent] with the given fields replaced
  /// with the new values.
  ContentContent copyWith({
    String? type,
    List<Question>? questions,
    String? title,
    String? question,
    String? description,
  }) => ContentContent(
    type: type ?? this.type,
    questions: questions ?? this.questions,
    title: title ?? this.title,
    question: question ?? this.question,
    description: description ?? this.description,
  );

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

/// Represents a question.
class Question {
  /// Creates a new [Question] instance.
  Question({this.question, this.options});

  /// Creates a new [Question] instance from a JSON map.
  factory Question.fromJson(Map<String, dynamic> json) => Question(
    question: json['question'],
    options: json['options'] == null
        ? <String>[]
        : List<String>.from(json['options']!.map((x) => x)),
  );
  /// The question text.
  final String? question;
  /// A list of options for the question.
  final List<String>? options;

  /// Creates a copy of this [Question] with the given fields replaced
  /// with the new values.
  Question copyWith({String? question, List<String>? options}) => Question(
    question: question ?? this.question,
    options: options ?? this.options,
  );

  /// Converts this [Question] to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'question': question,
    'options': options == null
        ? <dynamic>[]
        : List<dynamic>.from(options!.map((String x) => x)),
  };
}
