import 'package:sikshana/app/modules/my_schedules/views/widgets/day_schedule_view.dart';
import 'package:sikshana/app/modules/my_schedules/views/widgets/week_selector_widget.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A view that displays the user's schedules and others' schedules
/// in a toggleable interface with a calendar-based weekly breakdown.
///
/// This widget:
/// - Shows user's schedules or others' schedules depending on toggle.
/// - Provides a weekly calendar with schedule details per day.
/// - Handles no-internet scenarios.
/// - Integrates drawer navigation.
/// - Allows navigation to class-adding flow using `AppButton`.
///
/// This view listens reactively using GetX controllers.
class MySchedulesView extends GetView<MySchedulesController> {
  /// Creates a new instance of [MySchedulesView].
  ///
  /// [key] allows Flutter to preserve widget state when needed.
  const MySchedulesView({super.key});

  /// Builds the main widget tree for the schedules view.
  ///
  /// Includes:
  /// - Connectivity handling.
  /// - App bar with drawer & "Add Class" button.
  /// - A refreshable body showing schedule toggles and weekly calendar.
  ///
  /// Returns a reactive UI based on connectivity and controller states.
  @override
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>()
          ..onReConnect = controller.initController;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : Scaffold(
              key: scaffoldKey,
              appBar: CommonAppBar(
                scaffoldKey: scaffoldKey,
                leading: Leading.drawer,
                title: LocaleKeys.mySchedules.tr,
              ),
              drawer: const AppDrawer(currentRoute: Routes.MY_SCHEDULES),

              /// Pull-to-refresh container that reloads schedules.
              body: RefreshIndicator(
                onRefresh: () async {
                  unawaited(controller.initController());
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      delegate: SliverHeaderDelegate(
                        height: 50.h, // Adjust height as needed
                        child: Container(
                          color: AppColors
                              .kFFFFFF, // Background color for the TabBar
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: TabBar(
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
                            tabAlignment: TabAlignment.center,
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelPadding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                            ),
                            tabs: <Widget>[
                              Tab(text: LocaleKeys.mySchedules.tr),
                              Tab(text: LocaleKeys.othersSchedules.tr),
                            ],
                            onTap: (int index) {
                              controller.scheduleView.value = index == 0
                                  ? ScheduleView.my
                                  : ScheduleView.others;
                            },
                          ),
                        ),
                      ),
                      pinned: true,
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverHeaderDelegate(
                        height: 10.h,
                        child: Container(height: 4, color: AppColors.kFFFFFF),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                          20.verticalSpace,

                          /// Displays the weekly calendar or a loading indicator.
                          _buildCalendarCard(),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Builds the main card UI containing the calendar header,
  /// week selector widget, and day schedule view.
  ///
  /// Returns a decorated card with a column of calendar components.
  Widget _buildCalendarCard() => Container(
    padding: EdgeInsets.all(16.dg),
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.kDCDEE4),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: AppColors.k000000.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: <Widget>[
        _buildCalendarHeader(),
        20.verticalSpace,

        /// Allows selecting the current visible week.
        const WeekSelectorWidget(),
        20.verticalSpace,
        Obx(
          () => controller.isLoading.value
              ? const SizedBox.shrink()
              : Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 100.w,
                    child: AppButton(
                      height: 30.h,
                      borderRadius: BorderRadius.circular(4).r,
                      style: AppTextStyle.lato(
                        fontSize: 12.sp,
                        color: AppColors.kFFFFFF,
                      ),
                      buttonText: LocaleKeys.add.tr,
                      onPressed: () {
                        if (controller.scheduleView() == ScheduleView.my) {
                          controller.onAddEvent(
                            controller.selectedDay.value ?? DateTime.now(),
                          );
                        }
                      },
                    ),
                  ),
                ),
        ),

        /// Shows the list of schedules for the selected day.
        Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : const DayScheduleView(),
        ),
      ],
    ),
  );

  /// Builds the header section for the calendar card, including:
  /// - Current month text
  /// - Left/right navigation arrows
  /// - Display of currently selected week range
  ///
  /// Reactively rebuilds when the selected date changes.
  Widget _buildCalendarHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      /// Displays the currently selected month.
      Obx(
        () => Text(
          controller.formattedMonth,
          style: AppTextStyle.lato(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      const Spacer(),

      /// Navigate to previous week
      ArrowButton(
        icon: Icons.chevron_left,
        onPressed: () {
          controller.onPageChanged(
            controller.focusedDay.value.subtract(const Duration(days: 7)),
          );
        },
      ),
      8.horizontalSpace,

      /// Displays the current week's date range.
      Container(
        padding: EdgeInsets.all(6.dg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4).r,
          border: Border.all(color: AppColors.kEBEBEB),
        ),
        child: Obx(
          () => Text(
            controller.formattedWeekRange,
            style: AppTextStyle.lato(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.k303030,
            ),
          ),
        ),
      ),
      8.horizontalSpace,

      /// Navigate to next week
      ArrowButton(
        icon: Icons.chevron_right,
        onPressed: () {
          controller.onPageChanged(
            controller.focusedDay.value.add(const Duration(days: 7)),
          );
        },
      ),
    ],
  );
}
