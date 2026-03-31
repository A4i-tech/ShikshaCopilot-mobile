import 'package:get/get.dart';

import '../controllers/help_controller.dart';

/// A binding class for the HelpView.
///
/// This class sets up the dependencies for the [HelpController]
/// by using GetX's dependency injection system.
class HelpBinding extends Bindings {
  /// Sets up the dependencies for the [HelpController].
  @override
  void dependencies() {
    Get.lazyPut<HelpController>(
      () => HelpController(),
    );
  }
}
