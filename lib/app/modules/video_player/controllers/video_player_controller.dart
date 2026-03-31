import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sikshana/app/data/config/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart' as vp;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Controller for playing videos, supporting both YouTube and generic URLs.
class VideoPlayerController extends GetxController {
  /// The title of the video.
  late String title;

  /// The URL link of the video.
  late String link;

  /// The hero tag for animated transitions.
  late String heroTag;

  /// Controller for the YouTube player, if the video is from YouTube.
  YoutubePlayerController? youtubePlayerController;

  /// Controller for the network video player.
  vp.VideoPlayerController? videoController;

  /// Controller for the Chewie player.
  ChewieController? chewieController;

  /// Reactive boolean to indicate if the video is a YouTube video.
  RxBool isYoutubeVideo = false.obs;

  /// Reactive boolean to indicate if network video fails to play
  RxBool isVideoPlayerError = false.obs;

  @override
  /// Called when the controller is initialized.
  /// Retrieves arguments and initializes the YouTube player if applicable.
  void onInit() {
    super.onInit();

    title = Get.arguments['title'];
    link = Get.arguments['link'];
    heroTag = Get.arguments['heroTag'];

    final String? videoId = YoutubePlayer.convertUrlToId(link);

    if (videoId != null) {
      isYoutubeVideo.value = true;
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          controlsVisibleAtStart: true,
        ),
      );
    } else {
      _initializeVideoPlayer();
    }
  }

  ///convert google drive video to playable link
  String convertToDirectDriveUrl(String url) {
    final RegExp regExp = RegExp(r'/d/([^/]+)/');
    final RegExpMatch? match = regExp.firstMatch(url);
    final String? id = match != null ? match.group(1) : null;

    if (id != null) {
      return 'https://drive.google.com/uc?export=download&id=$id';
    }
    return url;
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      videoController = vp.VideoPlayerController.networkUrl(
        Uri.parse(convertToDirectDriveUrl(link)),
      );
      await videoController!.initialize();
      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: true,
        aspectRatio: videoController!.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          handleColor: AppColors.k46A0F1,
          playedColor: AppColors.k46A0F1,
        ),
      );
    } catch (e) {
      isVideoPlayerError.value = true;
    }
    update();
  }

  /// Launches non-YouTube video URLs using the `url_launcher` package.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the URL is launched.
  Future<void> launchNonYoutubeVideo() async {
    final Uri uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  /// Called when the controller is closed.
  /// Disposes the YouTube player controller and restores portrait orientation.
  void onClose() {
    youtubePlayerController?.dispose();
    videoController?.dispose();
    chewieController?.dispose();

    // restore portrait orientation
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.onClose();
  }
}
