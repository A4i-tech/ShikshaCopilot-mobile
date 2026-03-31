// To parse this JSON data, do
//
//     final questionBankModel = questionBankModelFromJson(jsonString);

import 'dart:convert';

/// Parses a JSON string into a [QuestionBankModel] object.
QuestionBankModel questionBankModelFromJson(String str) =>
    QuestionBankModel.fromJson(json.decode(str));

/// Converts a [QuestionBankModel] object to a JSON string.
String questionBankModelToJson(QuestionBankModel data) =>
    json.encode(data.toJson());

/// Represents a question bank model.
class QuestionBankModel {
  /// Constructs a [QuestionBankModel].
  QuestionBankModel({this.success, this.message, this.data});

  /// Factory constructor to create a [QuestionBankModel] from JSON.
  factory QuestionBankModel.fromJson(Map<String, dynamic> json) =>
      QuestionBankModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  /// Indicates if the API call was successful.
  final bool? success;

  /// A message from the API.
  final String? message;

  /// The question bank data.
  final Data? data;

  /// Creates a copy of this [QuestionBankModel] with optional new values.
  QuestionBankModel copyWith({bool? success, String? message, Data? data}) =>
      QuestionBankModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  /// Converts this [QuestionBankModel] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

/// Represents the data of a question bank.
class Data {
  /// Constructs a [Data] object.
  Data({
    this.teacherId,
    this.board,
    this.medium,
    this.grade,
    this.subject,
    this.examinationName,
    this.chapterIds,
    this.topics,
    this.isMultiChapter,
    this.totalMarks,
    this.marksDistribution,
    this.objectiveDistribution,
    this.questionBankTemplate,
    this.bluePrintTemplate,
    this.questionBank,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Factory constructor to create a [Data] object from JSON.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    teacherId: json['teacherId'],
    board: json['board'],
    medium: json['medium'],
    grade: json['grade'],
    subject: json['subject'],
    examinationName: json['examinationName'],
    chapterIds: json['chapterIds'] == null
        ? <String>[]
        : List<String>.from(json['chapterIds']!.map((x) => x)),
    topics: json['topics'] == null
        ? <String>[]
        : List<String>.from(json['topics']!.map((x) => x)),
    isMultiChapter: json['isMultiChapter'],
    totalMarks: json['totalMarks'],
    marksDistribution: json['marksDistribution'] == null
        ? <MarksDistribution>[]
        : List<MarksDistribution>.from(
            json['marksDistribution']!.map(
              (x) => MarksDistribution.fromJson(x),
            ),
          ),
    objectiveDistribution: json['objectiveDistribution'] == null
        ? <ObjectiveDistribution>[]
        : List<ObjectiveDistribution>.from(
            json['objectiveDistribution']!.map(
              (x) => ObjectiveDistribution.fromJson(x),
            ),
          ),
    questionBankTemplate: json['questionBankTemplate'] == null
        ? <BluePrintTemplate>[]
        : List<BluePrintTemplate>.from(
            json['questionBankTemplate']!.map(
              (x) => BluePrintTemplate.fromJson(x),
            ),
          ),
    bluePrintTemplate: json['bluePrintTemplate'] == null
        ? <BluePrintTemplate>[]
        : List<BluePrintTemplate>.from(
            json['bluePrintTemplate']!.map(
              (x) => BluePrintTemplate.fromJson(x),
            ),
          ),
    questionBank: json['questionBank'] == null || json['questionBank'] is String
        ? null
        : QuestionBank.fromJson(json['questionBank']),
    id: json['_id'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The ID of the teacher.
  final String? teacherId;

  /// The board of education.
  final String? board;

  /// The medium of instruction.
  final String? medium;

  /// The grade or class level.
  final int? grade;

  /// The subject.
  final String? subject;

  /// The name of the examination.
  final String? examinationName;

  /// The IDs of the chapters included.
  final List<String>? chapterIds;

  /// The topics covered.
  final List<String>? topics;

  /// Whether the question bank spans multiple chapters.
  final bool? isMultiChapter;

  /// The total marks of the question paper.
  final int? totalMarks;

  /// The distribution of marks.
  final List<MarksDistribution>? marksDistribution;

  /// The distribution of objectives.
  final List<ObjectiveDistribution>? objectiveDistribution;

  /// The template for the question bank.
  final List<BluePrintTemplate>? questionBankTemplate;

  /// The blueprint template.
  final List<BluePrintTemplate>? bluePrintTemplate;

  /// The question bank itself.
  final QuestionBank? questionBank;

  /// The unique identifier.
  final String? id;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// Creates a copy of this [Data] with optional new values.
  Data copyWith({
    String? teacherId,
    String? board,
    String? medium,
    int? grade,
    String? subject,
    String? examinationName,
    List<String>? chapterIds,
    List<String>? topics,
    bool? isMultiChapter,
    int? totalMarks,
    List<MarksDistribution>? marksDistribution,
    List<ObjectiveDistribution>? objectiveDistribution,
    List<BluePrintTemplate>? questionBankTemplate,
    List<BluePrintTemplate>? bluePrintTemplate,
    QuestionBank? questionBank,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Data(
    teacherId: teacherId ?? this.teacherId,
    board: board ?? this.board,
    medium: medium ?? this.medium,
    grade: grade ?? this.grade,
    subject: subject ?? this.subject,
    examinationName: examinationName ?? this.examinationName,
    chapterIds: chapterIds ?? this.chapterIds,
    topics: topics ?? this.topics,
    isMultiChapter: isMultiChapter ?? this.isMultiChapter,
    totalMarks: totalMarks ?? this.totalMarks,
    marksDistribution: marksDistribution ?? this.marksDistribution,
    objectiveDistribution: objectiveDistribution ?? this.objectiveDistribution,
    questionBankTemplate: questionBankTemplate ?? this.questionBankTemplate,
    bluePrintTemplate: bluePrintTemplate ?? this.bluePrintTemplate,
    questionBank: questionBank ?? this.questionBank,
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  /// Converts this [Data] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'teacherId': teacherId,
    'board': board,
    'medium': medium,
    'grade': grade,
    'subject': subject,
    'examinationName': examinationName,
    'chapterIds': chapterIds == null
        ? <dynamic>[]
        : List<dynamic>.from(chapterIds!.map((String x) => x)),
    'topics': topics == null
        ? <dynamic>[]
        : List<dynamic>.from(topics!.map((String x) => x)),
    'isMultiChapter': isMultiChapter,
    'totalMarks': totalMarks,
    'marksDistribution': marksDistribution == null
        ? <dynamic>[]
        : List<dynamic>.from(
            marksDistribution!.map((MarksDistribution x) => x.toJson()),
          ),
    'objectiveDistribution': objectiveDistribution == null
        ? <dynamic>[]
        : List<dynamic>.from(
            objectiveDistribution!.map((ObjectiveDistribution x) => x.toJson()),
          ),
    'questionBankTemplate': questionBankTemplate == null
        ? <dynamic>[]
        : List<dynamic>.from(
            questionBankTemplate!.map((BluePrintTemplate x) => x.toJson()),
          ),
    'bluePrintTemplate': bluePrintTemplate == null
        ? <dynamic>[]
        : List<dynamic>.from(
            bluePrintTemplate!.map((BluePrintTemplate x) => x.toJson()),
          ),
    'questionBank': questionBank?.toJson(),
    '_id': id,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

/// Represents a blueprint template for a question type.
class BluePrintTemplate {
  /// Constructs a [BluePrintTemplate].
  BluePrintTemplate({
    this.type,
    this.numberOfQuestions,
    this.marksPerQuestion,
    this.questionDistribution,
    this.id,
    this.questions,
  });

  /// Factory constructor to create a [BluePrintTemplate] from JSON.
  factory BluePrintTemplate.fromJson(Map<String, dynamic> json) =>
      BluePrintTemplate(
        type: json['type'],
        numberOfQuestions: json['numberOfQuestions'],
        marksPerQuestion: json['marksPerQuestion'],
        questionDistribution: json['questionDistribution'] == null
            ? <QuestionDistribution>[]
            : List<QuestionDistribution>.from(
                json['questionDistribution']!.map(
                  (x) => QuestionDistribution.fromJson(x),
                ),
              ),
        id: json['_id'],
        questions: json['questions'] == null
            ? <Question>[]
            : List<Question>.from(
                json['questions']!.map((x) => Question.fromJson(x)),
              ),
      );

  /// The type of question.
  final String? type;

  /// The number of questions of this type.
  final int? numberOfQuestions;

  /// The marks per question.
  final int? marksPerQuestion;

  /// The distribution of questions.
  final List<QuestionDistribution>? questionDistribution;

  /// The unique identifier.
  final String? id;

  /// The list of questions.
  final List<Question>? questions;

  /// Creates a copy of this [BluePrintTemplate] with optional new values.
  BluePrintTemplate copyWith({
    String? type,
    int? numberOfQuestions,
    int? marksPerQuestion,
    List<QuestionDistribution>? questionDistribution,
    String? id,
    List<Question>? questions,
  }) => BluePrintTemplate(
    type: type ?? this.type,
    numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
    marksPerQuestion: marksPerQuestion ?? this.marksPerQuestion,
    questionDistribution: questionDistribution ?? this.questionDistribution,
    id: id ?? this.id,
    questions: questions ?? this.questions,
  );

  /// Converts this [BluePrintTemplate] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'numberOfQuestions': numberOfQuestions,
    'marksPerQuestion': marksPerQuestion,
    'questionDistribution': questionDistribution == null
        ? <dynamic>[]
        : List<dynamic>.from(
            questionDistribution!.map((QuestionDistribution x) => x.toJson()),
          ),
    '_id': id,
    'questions': questions == null
        ? <dynamic>[]
        : List<dynamic>.from(questions!.map((Question x) => x.toJson())),
  };
}

/// Represents the distribution of a question.
class QuestionDistribution {
  /// Constructs a [QuestionDistribution].
  QuestionDistribution({this.unitName, this.objective, this.id});

  /// Factory constructor to create a [QuestionDistribution] from JSON.
  factory QuestionDistribution.fromJson(Map<String, dynamic> json) =>
      QuestionDistribution(
        unitName: json['unitName'],
        objective: json['objective'],
        id: json['_id'],
      );

  /// The name of the unit.
  final String? unitName;

  /// The learning objective.
  final String? objective;

  /// The unique identifier.
  final String? id;

  /// Creates a copy of this [QuestionDistribution] with optional new values.
  QuestionDistribution copyWith({
    String? unitName,
    String? objective,
    String? id,
  }) => QuestionDistribution(
    unitName: unitName ?? this.unitName,
    objective: objective ?? this.objective,
    id: id ?? this.id,
  );

  /// Converts this [QuestionDistribution] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'unitName': unitName,
    'objective': objective,
    '_id': id,
  };
}

/// Represents a single question.
class Question {
  /// Constructs a [Question].
  Question({this.question, this.options, this.answer});

  /// Factory constructor to create a [Question] from JSON.
  factory Question.fromJson(Map<String, dynamic> json) => Question(
    question: json['question'],
    options: json['options'] == null
        ? <String>[]
        : List<String>.from(json['options']!.map((x) => x)),
    answer: json['answer'],
  );

  /// The question text.
  final String? question;

  /// The list of options for the question.
  final List<String>? options;

  /// The answer to the question.
  final String? answer;

  /// Creates a copy of this [Question] with optional new values.
  Question copyWith({
    String? question,
    List<String>? options,
    String? answer,
  }) => Question(
    question: question ?? this.question,
    options: options ?? this.options,
    answer: answer ?? this.answer,
  );

  /// Converts this [Question] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'question': question,
    'options': options == null
        ? <dynamic>[]
        : List<dynamic>.from(options!.map((String x) => x)),
    'answer': answer,
  };
}

/// Represents the distribution of marks.
class MarksDistribution {
  /// Constructs a [MarksDistribution].
  MarksDistribution({
    this.unitName,
    this.marks,
    this.percentageDistribution,
    this.id,
  });

  /// Factory constructor to create a [MarksDistribution] from JSON.
  factory MarksDistribution.fromJson(Map<String, dynamic> json) =>
      MarksDistribution(
        unitName: json['unitName'],
        marks: json['marks'],
        percentageDistribution: json['percentageDistribution'],
        id: json['_id'],
      );

  /// The name of the unit.
  final String? unitName;

  /// The marks allocated.
  final int? marks;

  /// The percentage distribution.
  final int? percentageDistribution;

  /// The unique identifier.
  final String? id;

  /// Creates a copy of this [MarksDistribution] with optional new values.
  MarksDistribution copyWith({
    String? unitName,
    int? marks,
    int? percentageDistribution,
    String? id,
  }) => MarksDistribution(
    unitName: unitName ?? this.unitName,
    marks: marks ?? this.marks,
    percentageDistribution:
        percentageDistribution ?? this.percentageDistribution,
    id: id ?? this.id,
  );

  /// Converts this [MarksDistribution] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'unitName': unitName,
    'marks': marks,
    'percentageDistribution': percentageDistribution,
    '_id': id,
  };
}

/// Represents the distribution of objectives.
class ObjectiveDistribution {
  /// Constructs an [ObjectiveDistribution].
  ObjectiveDistribution({this.objective, this.percentageDistribution, this.id});

  /// Factory constructor to create an [ObjectiveDistribution] from JSON.
  factory ObjectiveDistribution.fromJson(Map<String, dynamic> json) =>
      ObjectiveDistribution(
        objective: json['objective'],
        percentageDistribution: json['percentageDistribution'],
        id: json['_id'],
      );

  /// The learning objective.
  final String? objective;

  /// The percentage distribution.
  final int? percentageDistribution;

  /// The unique identifier.
  final String? id;

  /// Creates a copy of this [ObjectiveDistribution] with optional new values.
  ObjectiveDistribution copyWith({
    String? objective,
    int? percentageDistribution,
    String? id,
  }) => ObjectiveDistribution(
    objective: objective ?? this.objective,
    percentageDistribution:
        percentageDistribution ?? this.percentageDistribution,
    id: id ?? this.id,
  );

  /// Converts this [ObjectiveDistribution] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'objective': objective,
    'percentageDistribution': percentageDistribution,
    '_id': id,
  };
}

/// Represents a question bank.
class QuestionBank {
  /// Constructs a [QuestionBank].
  QuestionBank({
    this.metadata,
    this.feedback,
    this.id,
    this.questions,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Factory constructor to create a [QuestionBank] from JSON.
  factory QuestionBank.fromJson(Map<String, dynamic> json) => QuestionBank(
    metadata: json['metadata'] == null
        ? null
        : Metadata.fromJson(json['metadata']),
    feedback: json['feedback'] == null
        ? null
        : Feedback.fromJson(json['feedback']),
    id: json['_id'],
    questions: json['questions'] == null
        ? <BluePrintTemplate>[]
        : List<BluePrintTemplate>.from(
            json['questions']!.map((x) => BluePrintTemplate.fromJson(x)),
          ),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The metadata of the question bank.
  final Metadata? metadata;

  /// The feedback on the question bank.
  final Feedback? feedback;

  /// The unique identifier.
  final String? id;

  /// The list of questions.
  final List<BluePrintTemplate>? questions;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// Creates a copy of this [QuestionBank] with optional new values.
  QuestionBank copyWith({
    Metadata? metadata,
    Feedback? feedback,
    String? id,
    List<BluePrintTemplate>? questions,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => QuestionBank(
    metadata: metadata ?? this.metadata,
    feedback: feedback ?? this.feedback,
    id: id ?? this.id,
    questions: questions ?? this.questions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  /// Converts this [QuestionBank] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'metadata': metadata?.toJson(),
    'feedback': feedback?.toJson(),
    '_id': id,
    'questions': questions == null
        ? <dynamic>[]
        : List<dynamic>.from(
            questions!.map((BluePrintTemplate x) => x.toJson()),
          ),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

/// Represents feedback on a question bank.
class Feedback {
  /// Constructs a [Feedback].
  Feedback({this.question, this.feedback, this.overallFeedback});

  /// Factory constructor to create a [Feedback] from JSON.
  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    question: json['question'],
    feedback: json['feedback'],
    overallFeedback: json['overallFeedback'],
  );

  /// The feedback question.
  final String? question;

  /// The feedback provided.
  final String? feedback;

  /// Overall feedback.
  final String? overallFeedback;

  /// Creates a copy of this [Feedback] with optional new values.
  Feedback copyWith({
    String? question,
    String? feedback,
    String? overallFeedback,
  }) => Feedback(
    question: question ?? this.question,
    feedback: feedback ?? this.feedback,
    overallFeedback: overallFeedback ?? this.overallFeedback,
  );

  /// Converts this [Feedback] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'question': question,
    'feedback': feedback,
    'overallFeedback': overallFeedback,
  };
}

/// Represents metadata for a question bank.
class Metadata {
  /// Constructs a [Metadata].
  Metadata({this.schoolName});

  /// Factory constructor to create a [Metadata] from JSON.
  factory Metadata.fromJson(Map<String, dynamic> json) =>
      Metadata(schoolName: json['schoolName']);

  /// The name of the school.
  final String? schoolName;

  /// Creates a copy of this [Metadata] with an optional new school name.
  Metadata copyWith({String? schoolName}) =>
      Metadata(schoolName: schoolName ?? this.schoolName);

  /// Converts this [Metadata] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{'schoolName': schoolName};
}
