import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

/// A binding for the Auth module, responsible for injecting the [AuthController]
/// into the GetX dependency injection system.
class AuthBinding extends Bindings {
  /// Declares the dependencies for the Auth module.
  ///
  /// This method uses [Get.lazyPut] to make [AuthController] available
  /// only when it's first used, optimizing resource usage.
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}
