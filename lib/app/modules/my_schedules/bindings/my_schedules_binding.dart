import 'package:get/get.dart';

import '../controllers/my_schedules_controller.dart';

/// A `Bindings` class for the MySchedules feature.
///
/// This class is responsible for setting up the dependencies required for the
/// MySchedules screen. It uses GetX's dependency injection mechanism to make
/// the `MySchedulesController` available to the view.
class MySchedulesBinding extends Bindings {
  /// Sets up the dependencies for the MySchedules feature.
  ///
  /// This method is called by GetX when the route is being prepared. It
  /// lazily puts `MySchedulesController`, which means the controller will be
  /// instantiated only when it is first accessed.
  @override
  void dependencies() {
    Get.lazyPut<MySchedulesController>(
      () => MySchedulesController(),
    );
  }
}
