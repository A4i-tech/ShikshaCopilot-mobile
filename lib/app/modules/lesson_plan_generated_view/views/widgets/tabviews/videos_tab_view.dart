import 'package:sikshana/app/modules/lesson_plan_generated_view/models/view_lesson_plan_model.dart';
import 'package:sikshana/app/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';

/// A tab view that displays all videos associated with a lesson plan.
///
/// ## Purpose
/// This widget shows a list of videos that belong to:
/// - The **saved lesson**, when coming from `FromPage.view`
/// - The **generated lesson**, when coming from `FromPage.generate`
///
/// Each video is displayed using a [VideoCard] widget.
/// When no videos exist, the view displays a **No Videos Found** placeholder.
///
/// ## Behavior
/// - Dynamically reacts to data changes due to GetX's `Obx`
/// - Launches external YouTube links using `url_launcher`
///
/// ## Controller Used
/// - [LessonPlanGeneratedViewController]
///
/// ## Navigation Argument Required
/// - `'from_page'`: A [FromPage] enum determining whether to load saved or generated lesson data.
class VideosTabView extends GetView<LessonPlanGeneratedViewController> {
  const VideosTabView({Key? key}) : super(key: key);

  /// Builds the video list UI.
  ///
  /// ## Returns
  /// A scrollable list of videos or a placeholder when no videos are available.
  @override
  Widget build(BuildContext context) {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    LessonPlanGenerationDetailsController? generationDetailsController;

    // Only required when coming from a generated lesson
    if (fromPage == FromPage.generate) {
      generationDetailsController =
          Get.find<LessonPlanGenerationDetailsController>();
    }

    return Obx(() {
      /// Holds either saved or generated video list.
      List<dynamic> videoList = [];

      // Load saved lesson video list
      if (fromPage == FromPage.view) {
        videoList = controller.lessonPlan.value?.data.lesson.videos ?? [];
      }
      // Load generated lesson video list
      else if (fromPage == FromPage.generate &&
          generationDetailsController != null) {
        videoList =
            generationDetailsController
                .generatedLessonResponse
                .value
                ?.data
                ?.first
                ?.videos ??
            [];
      }

      // When there are no videos
      if (videoList.isEmpty) {
        return noVideosSection(context);
      }

      // Display video list
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            24.verticalSpace,

            /// Build each video card
            ...videoList.map(
              (video) => VideoCard(
                video: video,
                onPlay: () async {
                  final Uri uri = Uri.parse(video.url);

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not open video link'),
                      ),
                    );
                  }
                },
              ),
            ),

            24.verticalSpace,
          ],
        ),
      );
    });
  }

  /// Displays a placeholder UI when no videos are found.
  ///
  /// ## Parameters
  /// - [context]: Build context needed for layout sizing
  ///
  /// ## Returns
  /// A styled container with an icon and message indicating no videos exist.
  Widget noVideosSection(BuildContext context) => Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.25,
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.kEBEBEB, width: 1.3),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// Circular illustration
        Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            color: AppColors.kEDF6FE,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              AppImages.videoNotFound,
              width: 40,
              height: 40,
            ),
          ),
        ),

        20.verticalSpace,

        /// Text message
        Text(
          LocaleKeys.videosNotFound.tr,
          style: AppTextStyle.lato(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.k5F6165,
          ),
        ),
      ],
    ),
  );
}

/// A reusable card widget that displays a single lesson video.
///
/// ## Features
/// - Shows the YouTube thumbnail (auto-extracted from URL)
/// - Displays the video title
/// - Tapping the thumbnail triggers [onPlay]
///
/// ## Parameters
/// - [video]: The [Video] model containing title & URL
/// - [onPlay]: Callback invoked when user taps the thumbnail
class VideoCard extends StatelessWidget {
  const VideoCard({required this.video, required this.onPlay, Key? key})
    : super(key: key);

  /// The lesson video model containing `title`, `url`, etc.
  final Video video;

  /// Triggered when user taps on the video thumbnail.
  final VoidCallback onPlay;

  /// Extracts a YouTube thumbnail URL from a YouTube video link.
  ///
  /// ## How it works
  /// Searches for:
  /// ```
  /// v=VIDEO_ID
  /// ```
  /// and returns:
  /// ```
  /// https://img.youtube.com/vi/VIDEO_ID/0.jpg
  /// ```
  ///
  /// ## Parameters
  /// - [url]: The YouTube video link
  ///
  /// ## Returns
  /// - A thumbnail image URL if match found
  /// - Empty string otherwise
  String getYoutubeThumbnail(String url) {
    final RegExp regExp = RegExp(r'(?<=v=)[^&]+');
    final RegExpMatch? match = regExp.firstMatch(url);

    if (match != null) {
      return 'https://img.youtube.com/vi/${match.group(0)}/0.jpg';
    }
    return '';
  }

  /// Builds the visual layout for the video card.
  ///
  /// Includes:
  /// - Thumbnail (network image)
  /// - Play button overlay
  /// - Video title
  ///
  /// ## Returns
  /// A styled container representing the video entry.
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(vertical: 16),
    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
    decoration: BoxDecoration(
      color: AppColors.kF3F4F6,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: const Color(0xFFE0E0E0)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        /// Video thumbnail with play overlay
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipRRect(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  getYoutubeThumbnail(video.url),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) => Container(
                        color: Colors.black12,
                        child: const Icon(Icons.video_library, size: 80),
                      ),
                ),
              ),
            ),

            /// Play button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: onPlay,
                child: Image.asset(AppImages.youtube),
              ),
            ),
          ],
        ),

        /// Video title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            video.title,
            textAlign: TextAlign.center,
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.k171A1F,
            ),
          ),
        ),
      ],
    ),
  );
}
