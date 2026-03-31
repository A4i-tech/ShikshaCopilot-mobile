import 'dart:convert';

/// Parses a JSON string into a [FacilityModel] object.
FacilityModel facilityModelFromJson(String str) =>
    FacilityModel.fromJson(json.decode(str));

/// Converts a [FacilityModel] object to a JSON string.
String facilityModelToJson(FacilityModel data) => json.encode(data.toJson());

/// Represents the model for facility data.
class FacilityModel {
  /// Constructs a [FacilityModel].
  FacilityModel({this.success, this.message, this.data});

  /// Factory constructor to create a [FacilityModel] from JSON.
  factory FacilityModel.fromJson(Map<String, dynamic> json) => FacilityModel(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
  );

  /// Indicates if the API call was successful.
  final bool? success;

  /// A message from the API.
  final String? message;

  /// The facility data.
  final Data? data;

  /// Converts this [FacilityModel] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

/// Represents the data structure for facility information.
class Data {
  /// Constructs a [Data] object.
  Data({this.page, this.totalItems, this.limit, this.results});

  /// Factory constructor to create a [Data] object from JSON.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    page: json['page'],
    totalItems: json['totalItems'],
    limit: json['limit'],
    results: json['results'] == null
        ? <Result>[]
        : List<Result>.from(json['results']!.map((x) => Result.fromJson(x))),
  );

  /// The current page number.
  final int? page;

  /// The total number of items.
  final int? totalItems;

  /// The number of items per page.
  final int? limit;

  /// The list of facility results.
  final List<Result>? results;

  /// Converts this [Data] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'page': page,
    'totalItems': totalItems,
    'limit': limit,
    'results': results == null
        ? <dynamic>[]
        : List<dynamic>.from(results!.map((Result x) => x.toJson())),
  };
}

/// Represents a single facility item.
class Result {
  /// Constructs a [Result].
  Result({
    this.id,
    this.subject,
    this.type,
    this.facilities,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Factory constructor to create a [Result] from JSON.
  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json['_id'],
    subject: json['subject'],
    type: json['type'],
    facilities: json['facilities'] == null
        ? <String>[]
        : List<String>.from(json['facilities']!.map((x) => x)),
    isDeleted: json['isDeleted'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The unique identifier of the facility.
  final String? id;

  /// The subject associated with the facility.
  final String? subject;

  /// The type of facility.
  final String? type;

  /// The list of facilities.
  final List<String>? facilities;

  /// Indicates if the facility is deleted.
  final bool? isDeleted;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// Converts this [Result] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'subject': subject,
    'type': type,
    'facilities': facilities == null
        ? <dynamic>[]
        : List<dynamic>.from(facilities!.map((String x) => x)),
    'isDeleted': isDeleted,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}
