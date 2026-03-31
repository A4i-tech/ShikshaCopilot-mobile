import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/auth/models/otp_model.dart';
import 'package:sikshana/app/modules/auth/models/validate_otp_model.dart';

/// Repository for handling authentication-related API calls.
class AuthApiRepo {
  /// Requests an OTP (One-Time Password) from the server.
  ///
  /// Parameters:
  /// - `phone`: The user's phone number to send the OTP to.
  /// - `rememberMe`: A boolean indicating whether the user wants to be remembered.
  /// - `forgotPassword`: A boolean indicating if the request is for a forgotten password flow.
  ///
  /// Returns:
  /// A [Future] that completes with an [OtpModel] if the request is successful,
  /// or `null` if an error occurs or the response is invalid.
  Future<OtpModel?> getOtp({
    required String phone,
    required bool rememberMe,
    bool forgotPassword = false,
  }) async {
    try {
      final Map<String, dynamic> body = <String, dynamic>{
        'phone': phone,
        'rememberMe': rememberMe,
      };
      if (forgotPassword) {
        body.addAll(<String, dynamic>{'forgotPassword': forgotPassword});
      }
      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.getOtp,
        params: <String, dynamic>{'type': 0},
        data: body,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return OtpModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      return e.response?.data['message'] != null
          ? OtpModel(message: e.response?.data['message'])
          : null;
    }
    return null;
  }

  /// Validates the provided OTP against the user's phone number.
  ///
  /// Parameters:
  /// - `phone`: The user's phone number.
  /// - `otp`: The OTP entered by the user.
  ///
  /// Returns:
  /// A [Future] that completes with a [ValidateOtpModel] if the OTP is valid,
  /// or `null` if an error occurs or the validation fails.
  Future<ValidateOtpModel?> validateOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.validateOtp,
        params: <String, dynamic>{'type': 0},
        data: <String, dynamic>{'phone': phone, 'otp': otp},
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return ValidateOtpModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }
}
