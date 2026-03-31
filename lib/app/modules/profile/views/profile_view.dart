import 'package:sikshana/app/utils/exports.dart';

/// The main view for the user's profile, which is organized into tabs.
class ProfileView extends GetView<ProfileController> {
  /// Constructs a [ProfileView].
  const ProfileView({super.key});

  @override
  /// Builds the UI for the profile screen.
  ///
  /// This method sets up a [NestedScrollView] with a [SliverPersistentHeader]
  /// to create a tab bar that sticks to the top. The body of the view is a
  /// [TabBarView] that displays different sections of the profile.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the profile screen UI.
  @override
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>()
          ..onReConnect = controller.initController;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : Stack(
              children: [
                Scaffold(
                  key: scaffoldKey,
                  body: FormBuilder(
                    key: controller.formKey,
                    child: DefaultTabController(
                      length: 3,
                      child: NestedScrollView(
                        headerSliverBuilder:
                            (
                              BuildContext context,
                              bool innerBoxIsScrolled,
                            ) => <Widget>[
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 26.h,
                                  ),
                                  child: const ProfilePhotoSection(),
                                ),
                              ),
                              SliverPersistentHeader(
                                delegate: _SliverAppBarDelegate(
                                  TabBar(
                                    controller: controller.tabController,
                                    labelColor: AppColors.k46A0F1,
                                    labelStyle: AppTextStyle.lato(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    dividerColor: AppColors.kEBEBEB,
                                    unselectedLabelColor: AppColors.k666970,
                                    indicator: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.k46A0F1,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    indicatorColor: AppColors.k46A0F1,
                                    tabAlignment: TabAlignment.fill,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    tabs: <Tab>[
                                      Tab(text: LocaleKeys.baseDetails.tr),
                                      Tab(text: LocaleKeys.classDetails.tr),
                                      Tab(text: LocaleKeys.resources.tr),
                                    ],
                                  ),
                                ),
                                pinned: true,
                              ),
                            ],
                        body: TabBarView(
                          controller: controller.tabController,
                          children: <Widget>[
                            _buildTabContent(const PersonalDetailsSection()),
                            _buildTabContent(const ClassDetailsSection()),
                            _buildTabContent(const ResourcesSection()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 25.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kFFFFFF,
                      border: Border(
                        top: BorderSide(
                          color: AppColors.k000000.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Obx(
                      () => AppButton(
                        buttonText: LocaleKeys.saveProfile.tr,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kFFFFFF,
                        ),
                        loader: controller
                            .isLoading
                            .value, // Bonus: button loader too
                        onPressed: () async {
                          await controller.saveProfile();
                        },
                      ),
                    ),
                  ),
                ),

                // Full-screen blocking loader
                if (controller.isLoading.value)
                  AbsorbPointer(
                    absorbing: true,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.k46A0F1,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildTabContent(Widget child) => RefreshIndicator(
    onRefresh: controller.initController,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
        child: child,
      ),
    ),
  );
}

/// A delegate for the sliver app bar that holds the tab bar.
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  /// Constructs a [_SliverAppBarDelegate].
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  /// Builds the tab bar within the sliver app bar.
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: _tabBar,
  );

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
