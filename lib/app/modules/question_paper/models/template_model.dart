import 'dart:convert';

/// Parses a JSON string into a [TemplateModel] object.
TemplateModel templateModelFromJson(String str) =>
    TemplateModel.fromJson(json.decode(str));

/// Converts a [TemplateModel] object to a JSON string.
String templateModelToJson(TemplateModel data) => json.encode(data.toJson());

/// Model representing a template response.
class TemplateModel {
  /// Constructs a [TemplateModel].
  TemplateModel({this.success, this.message, this.data});

  /// Factory constructor to create a [TemplateModel] from JSON.
  factory TemplateModel.fromJson(Map<String, dynamic> json) => TemplateModel(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null
        ? <TemplateData>[]
        : List<TemplateData>.from(
            json['data']!.map((x) => TemplateData.fromJson(x)),
          ),
  );

  /// Indicates if the API call was successful.
  final bool? success;

  /// A message from the API.
  final String? message;

  /// The list of template data.
  final List<TemplateData>? data;

  /// Creates a copy of this [TemplateModel] with optional new values.
  TemplateModel copyWith({
    bool? success,
    String? message,
    List<TemplateData>? data,
  }) => TemplateModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  /// Converts this [TemplateModel] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data == null
        ? <dynamic>[]
        : List<dynamic>.from(data!.map((TemplateData x) => x.toJson())),
  };
}

/// Represents the data for a single question paper template.
class TemplateData {
  /// Constructs a [TemplateData].
  TemplateData({
    this.type,
    this.numberOfQuestions,
    this.marksPerQuestion,
    this.questionDistribution,
    this.description,
  });

  /// Factory constructor to create a [TemplateData] from JSON.
  factory TemplateData.fromJson(Map<String, dynamic> json) => TemplateData(
    type: json['type'],
    numberOfQuestions: json['number_of_questions'],
    marksPerQuestion: json['marks_per_question'],
    questionDistribution: json['question_distribution'] == null
        ? null
        : List<QuestionDistribution>.from(
            json['question_distribution']!.map(
              (x) => QuestionDistribution.fromJson(x),
            ),
          ),
    description: json['description'],
  );

  /// The type of question.
  final String? type;

  /// The number of questions of this type.
  final int? numberOfQuestions;

  /// The marks allocated per question.
  final int? marksPerQuestion;

  /// The distribution of questions across units and objectives.
  final List<QuestionDistribution>? questionDistribution;

  /// The description of the template.
  final String? description;

  /// Creates a copy of this [TemplateData] with optional new values.
  TemplateData copyWith({
    String? type,
    int? numberOfQuestions,
    int? marksPerQuestion,
    List<QuestionDistribution>? questionDistribution,
    String? description,
  }) => TemplateData(
    type: type ?? this.type,
    numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
    marksPerQuestion: marksPerQuestion ?? this.marksPerQuestion,
    questionDistribution: questionDistribution ?? this.questionDistribution,
    description: description ?? this.description,
  );

  /// Converts this [TemplateData] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'number_of_questions': numberOfQuestions,
    'marks_per_question': marksPerQuestion,
    'question_distribution': questionDistribution == null
        ? null
        : List<dynamic>.from(
            questionDistribution!.map((QuestionDistribution x) => x.toJson()),
          ),
  };
}

/// Represents the distribution of a question within a template.
class QuestionDistribution {
  /// Constructs a [QuestionDistribution].
  QuestionDistribution({this.unitName, this.objective});

  /// Factory constructor to create a [QuestionDistribution] from JSON.
  factory QuestionDistribution.fromJson(Map<String, dynamic> json) =>
      QuestionDistribution(
        unitName: json['unit_name'],
        objective: json['objective'],
      );

  /// The name of the unit.
  final String? unitName;

  /// The learning objective.
  final String? objective;

  /// Creates a copy of this [QuestionDistribution] with optional new values.
  QuestionDistribution copyWith({String? unitName, String? objective}) =>
      QuestionDistribution(
        unitName: unitName ?? this.unitName,
        objective: objective ?? this.objective,
      );

  /// Converts this [QuestionDistribution] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'unit_name': unitName,
    'objective': objective,
  };
}
