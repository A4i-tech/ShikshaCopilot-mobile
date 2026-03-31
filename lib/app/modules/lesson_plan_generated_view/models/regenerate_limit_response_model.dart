// To parse this JSON data, do
//
//     final regenerateLimitResponseModel = regenerateLimitResponseModelFromJson(jsonString);

import 'dart:convert';

/// Converts a raw JSON string into a [RegenerateLimitResponseModel] instance.
///
/// - [str]: JSON string received from the API.
/// - Returns: A parsed [RegenerateLimitResponseModel] object.
RegenerateLimitResponseModel regenerateLimitResponseModelFromJson(String str) =>
    RegenerateLimitResponseModel.fromJson(json.decode(str));

/// Converts a [RegenerateLimitResponseModel] instance into a JSON string.
///
/// Useful when sending or storing data.
///
/// - [data]: Model instance to encode.
/// - Returns: JSON string.
String regenerateLimitResponseModelToJson(RegenerateLimitResponseModel data) =>
    json.encode(data.toJson());

/// Represents the response received from the backend when checking
/// whether the user has reached the lesson plan regeneration limit.
///
/// Contains:
/// - A success flag
/// - A message describing the server response
/// - A [Data] object containing the limit status
class RegenerateLimitResponseModel {
  /// Creates a new [RegenerateLimitResponseModel] instance.
  ///
  /// All fields are required because the API guarantees their existence.
  RegenerateLimitResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Factory constructor to parse JSON into an instance of this class.
  ///
  /// - [json]: Parsed JSON map from API.
  factory RegenerateLimitResponseModel.fromJson(Map<String, dynamic> json) =>
      RegenerateLimitResponseModel(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  /// Whether the request was successful.
  bool success;

  /// A descriptive message returned by the server.
  String message;

  /// Contains the actual regeneration limit information.
  Data data;

  /// Converts this instance into a JSON map.
  ///
  /// Useful for encoding or sending to APIs.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// Contains whether the user has reached the regeneration limit.
///
/// This is typically used to determine:
/// - Should the "Regenerate" option be enabled?
/// - Should the user be shown a warning dialog?
class Data {
  /// Creates a [Data] instance representing the limit check result.
  Data({required this.regenerationLimitReached});

  /// Factory constructor to parse JSON into a [Data] object.
  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(regenerationLimitReached: json['regenerationLimitReached']);

  /// Indicates whether the user has reached the maximum allowed regenerations.
  bool regenerationLimitReached;

  /// Converts this model into a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'regenerationLimitReached': regenerationLimitReached,
  };
}
