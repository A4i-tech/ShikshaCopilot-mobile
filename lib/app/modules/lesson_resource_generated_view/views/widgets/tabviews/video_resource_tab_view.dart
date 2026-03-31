import 'package:sikshana/app/modules/lesson_plan_generated_view/models/view_lesson_plan_model.dart';
import 'package:sikshana/app/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';

/// A tab view widget that displays a list of video resources.
class VideoResourceTabView
    extends GetView<LessonResourceGeneratedViewController> {
  /// Creates a [VideoResourceTabView].
  const VideoResourceTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    LessonResourceGenerationDetailsController? generationDetailsController;
    if (fromPage == FromPage.generate) {
      generationDetailsController =
          Get.find<LessonResourceGenerationDetailsController>();
    }

    return Obx(() {
      List<dynamic> videoList = [];
      if (fromPage == FromPage.view) {
        videoList = controller.lessonResource.value?.data.videos ?? [];
      } else if (fromPage == FromPage.generate &&
          generationDetailsController != null) {
        videoList =
            generationDetailsController
                .generatedResourceResponse
                .value
                ?.data
                ?.first
                ?.videos ??
            [];
      }

      if (videoList.isEmpty) {
        return noVideosSection(context);
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            24.verticalSpace,
            ...videoList
                .map(
                  (video) => VideoCard(
                    video: video,
                    onPlay: () async {
                      final uri = Uri.parse(video.url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not open video link'),
                          ),
                        );
                      }
                    },
                  ),
                )
                .toList(),
            24.verticalSpace,
          ],
        ),
      );
    });
  }

  /// Builds a section to display when no videos are found.
  ///
  /// The [context] is the build context.
  /// Returns a [Widget] displaying the no videos message.
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
  ).paddingSymmetric(horizontal: 24, vertical: 18);
}

/// A widget that displays a video card.
class VideoCard extends StatelessWidget {
  /// The video data to display.
  final Video video;

  /// A callback function to be called when the play button is pressed.
  final VoidCallback onPlay;

  /// Creates a [VideoCard].
  const VideoCard({required this.video, required this.onPlay, Key? key})
    : super(key: key);

  /// Extracts the YouTube thumbnail URL from a given YouTube video URL.
  ///
  /// The [url] is the YouTube video URL.
  /// Returns a [String] representing the thumbnail URL, or an empty string if not found.
  String getYoutubeThumbnail(String url) {
    final RegExp regExp = RegExp(r'(?<=v=)[^&]+');
    final RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return 'https://img.youtube.com/vi/${match.group(0)}/0.jpg';
    }
    return '';
  }

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
