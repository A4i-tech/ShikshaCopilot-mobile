import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:sikshana/app/data/config/app_colors.dart';

import 'logger.dart';

/// To handle all the error app wide
void letMeHandleAllErrors(Object error, StackTrace? trace) {
  // logE(trace);
  // logI('ERROR FROM letMeHandleAllErrors\nERROR TYPE : ${error.runtimeType}');
  switch (error.runtimeType) {
    case DioException:
      final Response<dynamic>? res = (error as DioException).response;
      logE('Got error : ${res!.statusCode} -> ${res.statusMessage}');
      Get.snackbar(
        'Oops!',
        'Got error : ${res.statusCode} -> ${res.statusMessage}',
        backgroundColor: AppColors.kFF0000,
      );
      break;
    default:
      Get.snackbar('Oops!', 'Something went wrong');
      logE(error.toString());
      logE(trace);
      break;
  }
}
