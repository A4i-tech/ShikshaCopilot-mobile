import 'package:get/get.dart';
import '../controllers/video_player_controller.dart';

/// A binding for the VideoPlayer module.
class VideoPlayerBinding extends Bindings {
  @override
  /// Initializes the [VideoPlayerController] as a lazy put dependency.
  void dependencies() {
    Get.lazyPut<VideoPlayerController>(
      () => VideoPlayerController(),
    );
  }
}
