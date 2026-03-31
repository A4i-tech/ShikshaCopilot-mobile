import 'package:cached_network_image/cached_network_image.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/generate_lesson_response_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/fullscale_image.dart';
import 'package:sikshana/app/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart'; // NEW

/// A card widget that displays media (image/video) attached to a lesson section.
class MediaCard extends StatelessWidget {
  const MediaCard({required this.media, Key? key, this.onDelete})
    : super(key: key);

  final Media media;
  final VoidCallback? onDelete;

  String getYoutubeThumbnail(String url) {
    final String? videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      return 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg';
    }
    final RegExp regExp = RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})');
    final RegExpMatch? match = regExp.firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return 'https://img.youtube.com/vi/${match.group(1)}/0.jpg';
    }
    return '';
  }

  bool _isGoogleDriveLink(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null &&
        (uri.host == 'drive.google.com' || uri.host == 'docs.google.com');
  }

  bool _isGoogleShareLink(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && uri.host == 'share.google';
  }

  String _getGoogleDriveDownloadLink(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return url;

    String? fileId;
    if (uri.pathSegments.length >= 3 &&
        uri.pathSegments[0] == 'file' &&
        uri.pathSegments[1] == 'd') {
      fileId = uri.pathSegments[2];
    } else if (uri.queryParameters.containsKey('id')) {
      fileId = uri.queryParameters['id'];
    }

    if (fileId != null && fileId.isNotEmpty) {
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }
    return url;
  }

  Future<void> _openLinkExternally() async {
    if (media.link.isEmpty) return;
    final Uri uri = Uri.parse(media.link);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Could not open link',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isVideo = media.type == 'video' && media.link.isNotEmpty;

    Widget preview;

    /// --- VIDEO PREVIEW HANDLING ---
    if (isVideo) {
      final String youtubeThumbnailUrl = getYoutubeThumbnail(media.link);

      if (youtubeThumbnailUrl.isNotEmpty) {
        preview = GestureDetector(
          onTap: () {
            Get.toNamed(
              Routes.VIDEO_PLAYER,
              arguments: <String, String>{
                'title': '',
                'link': media.link,
                'heroTag': youtubeThumbnailUrl,
              },
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Hero(
                tag: youtubeThumbnailUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: youtubeThumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                    placeholder: (BuildContext context, String url) =>
                        Container(
                          color: Colors.black12,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (BuildContext context, String url, Object error) =>
                            InkWell(
                              onTap: _openLinkExternally,
                              child: Container(
                                color: Colors.black12,
                                child: const Icon(Icons.open_in_new, size: 40),
                              ),
                            ),
                  ),
                ),
              ),
              const Icon(Icons.play_circle_fill, color: Colors.red, size: 48),
            ],
          ),
        );
      } else {
        preview = GestureDetector(
          onTap: () {
            Get.toNamed(
              Routes.VIDEO_PLAYER,
              arguments: <String, String>{
                'title': '',
                'link': media.link,
                'heroTag': '',
              },
            );
          },
          child: Container(
            height: 180,
            color: Colors.black12,
            alignment: Alignment.center,
            child: const Icon(Icons.video_library, size: 80),
          ),
        );
      }
    }
    /// --- IMAGE PREVIEW HANDLING ---
    else if (media.type == 'image' && media.link.isNotEmpty) {
      String imageUrl = media.link;

      if (_isGoogleDriveLink(media.link) || _isGoogleShareLink(media.link)) {
        imageUrl = _getGoogleDriveDownloadLink(media.link);
      }

      preview = GestureDetector(
        onTap: () {
          Get.to(
            () => FullScreenImage(url: imageUrl),
            transition: Transition.fadeIn,
          );
        },
        onScaleStart: (_) {
          Get.to(
            () => FullScreenImage(url: imageUrl),
            transition: Transition.fadeIn,
          );
        },
        child: Hero(
          tag: media.link,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              placeholder: (BuildContext context, String url) => Container(
                color: Colors.black12,
                height: 180,
                child: const Center(child: CircularProgressIndicator()),
              ),

              errorWidget: (BuildContext context, String url, Object error) {
                if (url.startsWith('http')) {
                  return SizedBox(
                    height: 200.h,
                    child: WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..loadRequest(Uri.parse(url)),
                    ),
                  );
                }
                return Container(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    'Invalid URL: $url',
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 12.sp,
                    ), // Fixed style
                  ),
                );
              },

              // InkWell(
              //   onTap: _openLinkExternally,
              //   child: Container(
              //     color: Colors.black12,
              //     height: 180,
              //     child: const Icon(Icons.open_in_new, size: 40),
              //   ),
              // ),
            ),
          ),
        ),
      );
    }
    /// --- FALLBACK FOR UNKNOWN MEDIA TYPES ---
    else {
      preview = InkWell(
        onTap: _openLinkExternally,
        child: Container(
          height: 180,
          color: Colors.black12,
          alignment: Alignment.center,
          child: Icon(
            media.type == 'video' ? Icons.video_library : Icons.image,
            size: 80,
          ),
        ),
      );
    }

    /// MAIN CARD UI
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 4, top: 16),
          child: Text(
            isVideo ? 'Video URL' : 'Image URL',
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.k46A0F1,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.kF3F4F6,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(8), child: preview),
              Material(
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: _openLinkExternally,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          child: Text(
                            media.link,
                            style: AppTextStyle.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColors.k171A1F,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'delete' && onDelete != null) {
                          onDelete!();
                        } else if (value == 'copy_link' &&
                            media.link.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: media.link));
                          Get.snackbar(
                            'Copied',
                            'Link copied to clipboard',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'copy_link',
                              child: Text(
                                LocaleKeys.copyLink.tr,
                                style: AppTextStyle.lato(fontSize: 12.sp),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text(
                                LocaleKeys.delete.tr,
                                style: AppTextStyle.lato(fontSize: 12.sp),
                              ),
                            ),
                          ],
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppColors.k6C7278,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
