import 'package:cached_network_image/cached_network_image.dart';
import 'package:sikshana/app/modules/help/models/help_video_model.dart' as v;
import 'package:sikshana/app/utils/exports.dart';
import '../controllers/help_controller.dart';

/// A view that displays a list of help videos.
///
/// This view observes the state of the [HelpController] and displays a list of
/// help videos. It also handles loading and empty states.
class HelpView extends GetView<HelpController> {
  /// Creates a new [HelpView] instance.
  const HelpView({super.key});
  @override
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>()..onReConnect = controller.onInit;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : Scaffold(
              key: scaffoldKey,
              appBar: CommonAppBar(
                scaffoldKey: scaffoldKey,
                leading: Leading.drawer,
              ),
              drawer: const AppDrawer(currentRoute: Routes.HELP),
              body: RefreshIndicator(
                onRefresh: () async {
                  controller.getHelpVideos();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.helpVideoModel.value?.data == null ||
                        controller.helpVideoModel.value!.data!.isEmpty) {
                      return const Center(child: Text('No videos found.'));
                    } else {
                      return CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    LocaleKeys.exploreOurVideoGuides.tr,
                                    style: AppTextStyle.lato(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    LocaleKeys.stepByStepVideosToGuide.tr,
                                    style: AppTextStyle.lato(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.k84828A,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: SliverHeaderDelegate(
                              height: 50.h,
                              child: Container(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                padding: EdgeInsets.only(
                                  top: 10.h,
                                  bottom: 10.h,
                                ),
                                child: Text(
                                  LocaleKeys.videos.tr,
                                  style: AppTextStyle.lato(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20.w,
                                  mainAxisSpacing: 14.h,
                                  childAspectRatio: 1.1,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final v.Datum video = controller
                                    .helpVideoModel
                                    .value!
                                    .data![index];

                                final String? videoId =
                                    YoutubePlayer.convertUrlToId(
                                      video.link ?? '',
                                    );

                                final String heroTag =
                                    (video.id ?? '') + index.toString();

                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.VIDEO_PLAYER,
                                      arguments: {
                                        'title': video.title ?? '',
                                        'link': video.link ?? '',
                                        'heroTag': heroTag,
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.kEBEBEB,
                                      ),
                                      borderRadius: BorderRadius.circular(6).r,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 8.w,
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Hero(
                                                tag: heroTag,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        6,
                                                      ).r,
                                                  child: (videoId != null)
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              'https://i.ytimg.com/vi/$videoId/hqdefault.jpg',
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          placeholder: (context, url) => Center(
                                                            child: SvgPicture.asset(
                                                              AppImages
                                                                  .youtubeVideoIcon,
                                                              height: 40.h,
                                                              colorFilter:
                                                                  const ColorFilter.mode(
                                                                    AppColors
                                                                        .kD02020,
                                                                    BlendMode
                                                                        .srcIn,
                                                                  ),
                                                            ),
                                                          ),
                                                          errorWidget:
                                                              (
                                                                context,
                                                                url,
                                                                error,
                                                              ) => Center(
                                                                child: SvgPicture.asset(
                                                                  AppImages
                                                                      .youtubeVideoIcon,
                                                                  height: 40.h,
                                                                  colorFilter: const ColorFilter.mode(
                                                                    AppColors
                                                                        .kD02020,
                                                                    BlendMode
                                                                        .srcIn,
                                                                  ),
                                                                ),
                                                              ),
                                                        )
                                                      : SvgPicture.asset(
                                                          AppImages
                                                              .youtubeVideoIcon,
                                                          height: 40.h,
                                                          colorFilter:
                                                              const ColorFilter.mode(
                                                                AppColors
                                                                    .kD02020,
                                                                BlendMode.srcIn,
                                                              ),
                                                        ),
                                                ),
                                              ),
                                              SvgPicture.asset(
                                                AppImages.youtubeVideoIcon,
                                                height: 40.h,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                      AppColors.kD02020,
                                                      BlendMode.srcIn,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 8.h),
                                        Text(
                                          video.title ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: AppTextStyle.lato(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount:
                                  controller.helpVideoModel.value!.data!.length,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 20.h,
                                horizontal: 20.w,
                              ),
                              child: SizedBox(height: 10.h),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                ),
              ),
            ),
    );
  }
}
