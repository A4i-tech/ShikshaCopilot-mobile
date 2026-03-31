import 'package:sikshana/app/modules/content_generation/views/widgets/content_filter_widget.dart';
import 'package:sikshana/app/modules/content_generation/views/widgets/content_generation_tab_section.dart';
import 'package:sikshana/app/modules/content_generation/views/widgets/lesson_resource_search_box.dart';
import 'package:sikshana/app/utils/exports.dart';

/// The main view for the content generation feature with pinned tabs at top.
/// ContentFilterWidget is now properly visible in header.
class ContentGenerationView extends GetView<ContentGenerationController> {
  const ContentGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>()
          ..onReConnect = controller.refreshContentGenerationScreen;

    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : DefaultTabController(
              length: 2,
              child: Scaffold(
                body: RefreshIndicator(
                  onRefresh: () async {
                    controller.formKey.currentState?.fields['search']?.reset();
                    controller.onInit();
                  },
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (
                          BuildContext context,
                          bool innerBoxIsScrolled,
                        ) => <Widget>[
                          // Header content (collapses)
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 20.h,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: FormBuilder(
                                key: controller.formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      LocaleKeys.lessonContent.tr,
                                      style: AppTextStyle.lato(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.k141522,
                                      ),
                                    ),
                                    20.verticalSpace,
                                    const GenerateLessonSection(),
                                    13.verticalSpace,
                                    LessonResourceSearchBox(
                                      onFilterTap:
                                          controller.toggleFilterVisible,
                                    ),
                                    // Filter Widget - Now properly visible
                                    AnimatedSize(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      alignment: Alignment.topCenter,
                                      curve: Curves.easeIn,
                                      reverseDuration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      child: Obx(
                                        () => controller.isFilterVisible.value
                                            ? const Padding(
                                                padding: EdgeInsets.only(
                                                  top: 13,
                                                ),
                                                child: ContentFilterWidget(),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Pinned TabBar
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _SliverTabBarDelegate(
                              TabBar(
                                labelColor: AppColors.k46A0F1,
                                unselectedLabelColor: AppColors.k9095A0,
                                indicator: const UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 3,
                                    color: AppColors.k46A0F1,
                                  ),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: AppColors.kEBEBEB,
                                labelStyle: AppTextStyle.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                unselectedLabelStyle: AppTextStyle.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                tabs: const <Widget>[
                                  Tab(text: 'Lesson Plan'),
                                  Tab(text: 'Lesson Resources'),
                                ],
                              ),
                            ),
                          ),
                        ],
                    body: const ContentGenerationTabSection(),
                  ),
                ),
              ),
            ),
    );
  }
}

/// Delegate for pinned TabBar header.
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(color: AppColors.kFFFFFF, child: _tabBar);

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
