// To parse this JSON data, do
//
//     final questionBankListModel = questionBankListModelFromJson(jsonString);

import 'dart:convert';

/// Parses the JSON string into a [QuestionBankListModel] object.
QuestionBankListModel questionBankListModelFromJson(String str) =>
    QuestionBankListModel.fromJson(json.decode(str));

/// Converts a [QuestionBankListModel] object to a JSON string.
String questionBankListModelToJson(QuestionBankListModel data) =>
    json.encode(data.toJson());

/// Model representing a list of question banks.
class QuestionBankListModel {
  /// Constructs a [QuestionBankListModel].
  QuestionBankListModel({this.success, this.message, this.data});

  /// Factory constructor to create a [QuestionBankListModel] from JSON.
  factory QuestionBankListModel.fromJson(Map<String, dynamic> json) =>
      QuestionBankListModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] == null ? null : DataRes.fromJson(json['data']),
      );

  /// Indicates if the API call was successful.
  final bool? success;

  /// A message from the API.
  final String? message;

  /// The data containing the list of question banks.
  final DataRes? data;

  /// Creates a copy of this [QuestionBankListModel] with optional new values.
  QuestionBankListModel copyWith({
    bool? success,
    String? message,
    DataRes? data,
  }) => QuestionBankListModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  /// Converts this [QuestionBankListModel] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

/// Data structure for the response containing a paginated list of question banks.
class DataRes {
  /// Constructs a [DataRes].
  DataRes({this.page, this.totalItems, this.limit, this.results});

  /// Factory constructor to create a [DataRes] from JSON.
  factory DataRes.fromJson(Map<String, dynamic> json) => DataRes(
    page: json['page'],
    totalItems: json['totalItems'],
    limit: json['limit'],
    results: json['results'] == null
        ? <ResultQB>[]
        : List<ResultQB>.from(
            json['results']!.map((x) => ResultQB.fromJson(x)),
          ),
  );

  /// The current page number.
  final int? page;

  /// The total number of items.
  final int? totalItems;

  /// The number of items per page.
  final int? limit;

  /// The list of question bank results.
  final List<ResultQB>? results;

  /// Creates a copy of this [DataRes] with optional new values.
  DataRes copyWith({
    int? page,
    int? totalItems,
    int? limit,
    List<ResultQB>? results,
  }) => DataRes(
    page: page ?? this.page,
    totalItems: totalItems ?? this.totalItems,
    limit: limit ?? this.limit,
    results: results ?? this.results,
  );

  /// Converts this [DataRes] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'page': page,
    'totalItems': totalItems,
    'limit': limit,
    'results': results == null
        ? <dynamic>[]
        : List<dynamic>.from(results!.map((ResultQB x) => x.toJson())),
  };
}

/// Represents a single question bank item.
class ResultQB {
  /// Constructs a [ResultQB].
  ResultQB({
    this.id,
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
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Factory constructor to create a [ResultQB] from JSON.
  factory ResultQB.fromJson(Map<String, dynamic> json) => ResultQB(
    id: json['_id'],
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
        ? <Template>[]
        : List<Template>.from(
            json['questionBankTemplate']!.map((x) => Template.fromJson(x)),
          ),
    bluePrintTemplate: json['bluePrintTemplate'] == null
        ? <Template>[]
        : List<Template>.from(
            json['bluePrintTemplate']!.map((x) => Template.fromJson(x)),
          ),
    questionBank: json['questionBank'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The unique identifier of the question bank.
  final String? id;

  /// The ID of the teacher who created the question bank.
  final String? teacherId;

  /// The board associated with the question bank.
  final String? board;

  /// The medium of instruction.
  final String? medium;

  /// The grade/class level.
  final int? grade;

  /// The subject of the question bank.
  final String? subject;

  /// The name of the examination.
  final String? examinationName;

  /// List of chapter IDs included in the question bank.
  final List<String>? chapterIds;

  /// List of topics included in the question bank.
  final List<String>? topics;

  /// Indicates if the question bank covers multiple chapters.
  final bool? isMultiChapter;

  /// The total marks for the question paper.
  final int? totalMarks;

  /// Distribution of marks across topics.
  final List<MarksDistribution>? marksDistribution;

  /// Distribution of marks across objectives.
  final List<ObjectiveDistribution>? objectiveDistribution;

  /// Template used for the question bank.
  final List<Template>? questionBankTemplate;

  /// Blueprint template used for the question bank.
  final List<Template>? bluePrintTemplate;

  /// The generated question bank content.
  final String? questionBank;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// Creates a copy of this [ResultQB] with optional new values.
  ResultQB copyWith({
    String? id,
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
    List<Template>? questionBankTemplate,
    List<Template>? bluePrintTemplate,
    String? questionBank,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => ResultQB(
    id: id ?? this.id,
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
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  /// Converts this [ResultQB] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
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
            questionBankTemplate!.map((Template x) => x.toJson()),
          ),
    'bluePrintTemplate': bluePrintTemplate == null
        ? <dynamic>[]
        : List<dynamic>.from(
            bluePrintTemplate!.map((Template x) => x.toJson()),
          ),
    'questionBank': questionBank,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

/// Represents a template for question types.
class Template {
  /// Constructs a [Template].
  Template({
    this.type,
    this.numberOfQuestions,
    this.marksPerQuestion,
    this.questionDistribution,
    this.id,
  });

  /// Factory constructor to create a [Template] from JSON.
  factory Template.fromJson(Map<String, dynamic> json) => Template(
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
  );

  /// The type of question (e.g., MCQ, Short Answer).
  final String? type;

  /// The number of questions of this type.
  final int? numberOfQuestions;

  /// The marks allocated per question of this type.
  final int? marksPerQuestion;

  /// Distribution of questions based on unit and objective.
  final List<QuestionDistribution>? questionDistribution;

  /// The unique identifier for the template.
  final String? id;

  /// Creates a copy of this [Template] with optional new values.
  Template copyWith({
    String? type,
    int? numberOfQuestions,
    int? marksPerQuestion,
    List<QuestionDistribution>? questionDistribution,
    String? id,
  }) => Template(
    type: type ?? this.type,
    numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
    marksPerQuestion: marksPerQuestion ?? this.marksPerQuestion,
    questionDistribution: questionDistribution ?? this.questionDistribution,
    id: id ?? this.id,
  );

  /// Converts this [Template] object to JSON.
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
  };
}

/// Represents the distribution of questions within a template.
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

  /// The objective of the question.
  final String? objective;

  /// The unique identifier for the question distribution.
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

/// Represents the distribution of marks for a specific unit.
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

  /// The marks allocated to this unit.
  final int? marks;

  /// The percentage distribution of marks for this unit.
  final int? percentageDistribution;

  /// The unique identifier for the marks distribution.
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

/// Represents the distribution of marks for a specific objective.
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

  /// The objective (e.g., Knowledge, Understanding).
  final String? objective;

  /// The percentage distribution of marks for this objective.
  final int? percentageDistribution;

  /// The unique identifier for the objective distribution.
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
