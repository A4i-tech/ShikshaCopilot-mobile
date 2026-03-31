import 'package:get_storage/get_storage.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Initialize all core functionalities
Future<void> initializeCoreApp({bool encryption = false}) async {
  //Activate logger
  initLogger();
  await GetStorage.init();
  APIService.initializeAPIService(
    encryptData: encryption,
    baseUrl: ApiConstants.baseUrl,
  );
}
