import 'package:get/get.dart';

import '../controllers/home_controller.dart';

/// A binding class for the Home screen.
///
/// This class sets up the dependencies for the Home screen,
/// specifically the [HomeController].
class HomeBinding extends Bindings {
  /// Sets up the dependencies for the Home screen.
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
