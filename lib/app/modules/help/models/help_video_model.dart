// To parse this JSON data, do
//
//     final helpVideoModel = helpVideoModelFromJson(jsonString);

import 'dart:convert';

/// Parses a JSON string and returns a [HelpVideoModel] object.
HelpVideoModel helpVideoModelFromJson(String str) =>
    HelpVideoModel.fromJson(json.decode(str) as Map<String, dynamic>);

/// Converts a [HelpVideoModel] object to a JSON string.
String helpVideoModelToJson(HelpVideoModel data) => json.encode(data.toJson());

/// A model class for help videos.
///
/// This class represents the response from the help videos API.
class HelpVideoModel {
  /// Creates a new [HelpVideoModel] instance.
  HelpVideoModel({this.success, this.data});

  /// Creates a new [HelpVideoModel] instance from a JSON map.
  factory HelpVideoModel.fromJson(Map<String, dynamic> json) => HelpVideoModel(
    success: json['success'] as bool?,
    data: json['data'] == null
        ? <Datum>[]
        : List<Datum>.from(
            (json['data'] as List<dynamic>? ?? <dynamic>[]).map(
              (dynamic x) => Datum.fromJson(x as Map<String, dynamic>),
            ),
          ),
  );

  /// A boolean indicating whether the API request was successful.
  final bool? success;

  /// A list of [Datum] objects representing the help videos.
  final List<Datum>? data;

  /// Creates a new [HelpVideoModel] instance with the given values.
  HelpVideoModel copyWith({bool? success, List<Datum>? data}) =>
      HelpVideoModel(success: success ?? this.success, data: data ?? this.data);

  /// Converts this [HelpVideoModel] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'data': data == null
        ? <dynamic>[]
        : List<dynamic>.from((data ?? <Datum>[]).map((Datum x) => x.toJson())),
  };
}

/// A model class for a single help video.
class Datum {
  /// Creates a new [Datum] instance.
  Datum({
    this.id,
    this.title,
    this.link,
    this.state,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a new [Datum] instance from a JSON map.
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['_id'] as String?,
    title: json['title'] as String?,
    link: json['link'] as String?,
    state: json['state'] as String?,
    v: json['__v'] as int?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  );

  /// The unique identifier of the help video.
  final String? id;

  /// The title of the help video.
  final String? title;

  /// The link to the help video.
  final String? link;

  /// The state of the help video.
  final String? state;

  /// The version of the help video.
  final int? v;

  /// The date and time when the help video was created.
  final DateTime? createdAt;

  /// The date and time when the help video was last updated.
  final DateTime? updatedAt;

  /// Creates a new [Datum] instance with the given values.
  Datum copyWith({
    String? id,
    String? title,
    String? link,
    String? state,
    int? v,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Datum(
    id: id ?? this.id,
    title: title ?? this.title,
    link: link ?? this.link,
    state: state ?? this.state,
    v: v ?? this.v,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Converts this [Datum] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'title': title,
    'link': link,
    'state': state,
    '__v': v,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
