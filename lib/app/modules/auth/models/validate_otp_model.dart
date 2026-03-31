// To parse this JSON data, do
//
//     final validateOtpModel = validateOtpModelFromJson(jsonString);

import 'dart:convert';

import 'package:sikshana/app/modules/profile/models/profile_model.dart';

/// Parses a JSON string into a [ValidateOtpModel].
ValidateOtpModel validateOtpModelFromJson(String str) =>
    ValidateOtpModel.fromJson(json.decode(str));

/// Converts a [ValidateOtpModel] to a JSON string.
String validateOtpModelToJson(ValidateOtpModel data) =>
    json.encode(data.toJson());

/// Represents the response model for validating an OTP.
class ValidateOtpModel {
  /// Creates a [ValidateOtpModel] instance.
  ///
  /// Parameters:
  /// - `success`: Indicates if the OTP validation was successful.
  /// - `message`: A message related to the OTP validation.
  /// - `data`: Contains additional data, including the user's profile and token.
  ValidateOtpModel({this.success, this.message, this.data});

  /// Creates a [ValidateOtpModel] from a JSON map.
  factory ValidateOtpModel.fromJson(Map<String, dynamic> json) =>
      ValidateOtpModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  /// Indicates if the operation was successful.
  final bool? success;

  /// A message describing the result of the operation.
  final String? message;

  /// The data payload, containing user profile and authentication token.
  final Data? data;

  /// Converts this [ValidateOtpModel] instance to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

/// Represents the data part of the OTP validation response.
class Data {
  /// Creates a [Data] instance.
  ///
  /// Parameters:
  /// - `user`: The [User] profile associated with the validated OTP.
  /// - `token`: The authentication token.
  Data({this.user, this.token});

  /// Creates a [Data] instance from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json['user'] == null ? null : User.fromJson(json['user']),
    token: json['token'],
  );

  /// The user profile.
  final User? user;

  /// The authentication token.
  final String? token;

  /// Converts this [Data] instance to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'user': user?.toJson(),
    'token': token,
  };
}
