import 'package:dio/dio.dart';
import 'package:sikshana/app/utils/exports.dart';

/// APIWrapper class is a helper class to handle API calls.
class APIWrapper {
  /// Handle API call
  static Future<T?> handleApiCall<T>(Future<T?> apiCall) async {
    try {
      final T? result = await apiCall;
      if (result != null) {
        return result;
      }
    } on DioException catch (e, t) {
      logE('APIWrapper:  ${e.response?.data}  $e  $t');
      rethrow;
    }

    return null;
  }
}
