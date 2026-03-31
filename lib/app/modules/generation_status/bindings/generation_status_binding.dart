import 'package:get/get.dart';

import '../controllers/generation_status_controller.dart';

class GenerationStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerationStatusController>(
      () => GenerationStatusController(),
    );
  }
}
