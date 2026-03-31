// To parse this JSON data, do
//
//     final regenerateResponseModel = regenerateResponseModelFromJson(jsonString);

import 'dart:convert';

/// Converts a raw JSON string into a [RegenerateResponseModel] instance.
///
/// - [str]: JSON string returned from the backend.
/// - Returns: A parsed [RegenerateResponseModel] object.
RegenerateResponseModel regenerateResponseModelFromJson(String str) =>
    RegenerateResponseModel.fromJson(json.decode(str));

/// Converts a [RegenerateResponseModel] instance into a JSON string.
///
/// Useful for logging, caching, or re-sending data.
///
/// - [data]: Model instance to convert.
/// - Returns: JSON-encoded string.
String regenerateResponseModelToJson(RegenerateResponseModel data) =>
    json.encode(data.toJson());

/// Represents the API response for initiating a lesson plan regeneration request.
///
/// This response typically includes:
/// - A `success` flag indicating whether the call was accepted
/// - A server `message`
/// - A [Data] object containing workflow / instance details needed to track regeneration status
class RegenerateResponseModel {
  /// Creates a new [RegenerateResponseModel] instance.
  ///
  /// All fields are required because the server guarantees their presence.
  RegenerateResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Factory constructor to create a [RegenerateResponseModel] from a JSON map.
  ///
  /// - [json]: Parsed JSON map.
  factory RegenerateResponseModel.fromJson(Map<String, dynamic> json) =>
      RegenerateResponseModel(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  /// Whether the regeneration request was successfully triggered.
  bool success;

  /// A descriptive message from the server (e.g., “Regeneration started”).
  String message;

  /// Contains identifiers required to query regeneration status.
  Data data;

  /// Converts this model into a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// Contains workflow identifiers returned by the regeneration API.
///
/// Typically used to:
/// - Track execution of asynchronous regeneration workflows
/// - Poll status endpoints to check progress
class Data {
  /// Creates a [Data] instance containing the workflow tracking details.
  ///
  /// - [instanceId]: Unique identifier of the regeneration workflow instance.
  /// - [statusQueryGetUri]: URI to query the regeneration job status.
  Data({required this.instanceId, required this.statusQueryGetUri});

  /// Factory constructor to parse a JSON map into a [Data] instance.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    instanceId: json['instance_id'],
    statusQueryGetUri: json['status_query_get_uri'],
  );

  /// The unique ID used to track the regeneration process.
  String instanceId;

  /// Endpoint URL used to query the regeneration status (polling).
  String statusQueryGetUri;

  /// Converts this model into a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'instance_id': instanceId,
    'status_query_get_uri': statusQueryGetUri,
  };
}
