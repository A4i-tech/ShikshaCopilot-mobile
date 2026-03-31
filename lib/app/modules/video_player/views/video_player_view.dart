import 'package:chewie/chewie.dart';
import '../controllers/video_player_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A view that displays a video, either from YouTube or a generic URL.
class VideoPlayerView extends GetView<VideoPlayerController> {
  /// Constructs a [VideoPlayerView].
  const VideoPlayerView({super.key});

  @override
  /// Builds the UI for the video player view.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the video player UI.
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return GetBuilder<VideoPlayerController>(
      builder: (c) {
        if (controller.isVideoPlayerError.value) {
          return Scaffold(
            appBar: CommonAppBar(
              scaffoldKey: scaffoldKey,
              title: controller.title,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to play video.', style: AppTextStyle.lato()),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: controller.link));
                      if (!Get.isSnackbarOpen) {
                        appSnackBar(
                          message: 'Copied to clipboard',
                          type: SnackBarType.top,
                          state: SnackBarState.success,
                        );
                      }
                    },
                    child: Text(
                      controller.link,
                      style: AppTextStyle.lato(
                        color: AppColors.k46A0F1,
                        fontSize: 12.sp,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.k46A0F1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      controller.launchNonYoutubeVideo();
                    },
                    child: Text(
                      'Open in browser',
                      style: AppTextStyle.lato(color: AppColors.k46A0F1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (!controller.isYoutubeVideo.value ||
            controller.youtubePlayerController == null) {
          return Scaffold(
            appBar: CommonAppBar(
              scaffoldKey: scaffoldKey,
              title: controller.title,
            ),
            body: Center(
              child:
                  controller.chewieController != null &&
                      controller
                          .chewieController!
                          .videoPlayerController
                          .value
                          .isInitialized
                  ? Chewie(controller: controller.chewieController!)
                  : const CircularProgressIndicator(),
            ),
          );
        }

        return YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: controller.youtubePlayerController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Theme.of(context).primaryColor,
            progressColors: ProgressBarColors(
              playedColor: Theme.of(context).primaryColor,
              handleColor: Theme.of(context).primaryColor,
            ),
          ),
          builder: (BuildContext context, Widget player) => Scaffold(
            appBar: AppBar(title: Text(controller.title)),
            body: Center(
              child: Hero(tag: controller.heroTag, child: player),
            ),
          ),
        );
      },
    );
  }
}
