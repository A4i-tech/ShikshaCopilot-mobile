// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

/// Parses a JSON string into an [OtpModel].
OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

/// Converts an [OtpModel] to a JSON string.
String otpModelToJson(OtpModel data) => json.encode(data.toJson());

/// Represents the response model for OTP requests.
class OtpModel {
  /// Creates an [OtpModel] instance.
  ///
  /// Parameters:
  /// - `success`: Indicates if the OTP request was successful.
  /// - `message`: A message related to the OTP request.
  /// - `data`: Contains additional data related to the OTP, such as
  ///   whether the OTP was triggered.
  OtpModel({this.success, this.message, this.data});

  /// Creates an [OtpModel] from a JSON map.
  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
  );

  /// Indicates if the operation was successful.
  final bool? success;

  /// A message describing the result of the operation.
  final String? message;

  /// The data payload, which may contain user information or other details.
  final Data? data;

  /// Converts this [OtpModel] instance to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

/// Represents the data part of the OTP response.
class Data {
  /// Creates a [Data] instance.
  ///
  /// Parameters:
  /// - `user`: The user associated with the OTP request (can be null).
  /// - `otpTriggered`: Indicates if the OTP was successfully triggered.
  Data({this.user, this.otpTriggered});

  /// Creates a [Data] instance from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(user: json['user'], otpTriggered: json['otpTriggered']);

  /// The user ID or identifier (can be null).
  final String? user;

  /// A boolean indicating if the OTP was triggered successfully.
  final bool? otpTriggered;

  /// Converts this [Data] instance to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{'user': user, 'otpTriggered': otpTriggered};
}
