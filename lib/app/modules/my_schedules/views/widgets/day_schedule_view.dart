import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A day view widget that displays a schedule in an hourly format.
///
/// This widget shows a vertical timeline from 7 AM to 6 PM (12 hours)
/// with events displayed at their corresponding time slots. It supports
/// both viewing and creating events based on the schedule view mode.
///
/// Features:
/// - Hourly time slots with visual dividers
/// - Current time indicator (red line) for today's view
/// - Event cards positioned at their scheduled times
/// - Tap-to-add functionality for creating new events
/// - Read-only mode for viewing others' schedules
///
/// Example usage:
/// ```dart
/// DayScheduleView()
/// ```
class DayScheduleView extends GetView<MySchedulesController> {
  /// Creates a [DayScheduleView] widget.
  const DayScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    /// Current date and time for highlighting the current hour
    final DateTime now = DateTime.now();

    return Obx(() {
      final DateTime? selectedDay = controller.selectedDay.value;

      // Show shimmer effect when loading
      if (controller.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: AppColors.kE0E0E0,
          highlightColor: AppColors.kF5F5F5,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // Number of shimmer items
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 60.w,
                        child: Container(
                          color: AppColors.kFFFFFF,
                          height: 14.h,
                          width: 40.w,
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.kF5F5F5, thickness: 1),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 60.w, top: 8.h),
                    child: Container(
                      height: 70.h, // Approximate height of an EventItem
                      decoration: BoxDecoration(
                        color: AppColors.kFFFFFF,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      // Show message if no day is selected
      if (selectedDay == null) {
        return const Center(child: Text('No day selected'));
      }

      /// Checks if the selected day is today
      final bool isSelectedDayToday = controller.isToday(selectedDay);

      /// Gets all events scheduled for the selected day
      final List<Event> eventsForSelectedDay =
          (controller.kEvents.value[selectedDay] ?? <Event>[]).toList()
            ..sort((Event a, Event b) => a.startTime.compareTo(b.startTime));

      if (eventsForSelectedDay.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20.dg),
            child: Text(
              LocaleKeys.noEvents.tr,
              style: AppTextStyle.lato(
                fontSize: 16.sp,
                color: AppColors.k72767C,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: eventsForSelectedDay.length,
        itemBuilder: (BuildContext context, int index) {
          final Event event = eventsForSelectedDay[index];
          final String eventTime = DateFormat('h:mm a').format(
            selectedDay.copyWith(
              hour: event.startTime.hour,
              minute: event.startTime.minute,
            ),
          );

          /// Determines if current time indicator should be shown
          final bool showCurrentTime =
              isSelectedDayToday &&
              now.hour == event.startTime.hour &&
              now.minute >= event.startTime.minute &&
              now.minute < event.endTime.minute;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Event time label row with divider line
                Row(
                  children: <Widget>[
                    // Time label (e.g., "9:00 AM")
                    SizedBox(
                      width: 60.w,
                      child: Text(
                        eventTime,
                        textAlign: TextAlign.right,
                        style: AppTextStyle.lato(
                          fontSize: 14.sp,
                          color: AppColors.k72767C,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Horizontal divider line
                    const Expanded(
                      child: Divider(color: AppColors.kF5F5F5, thickness: 1),
                    ),
                  ],
                ),

                /// Current time indicator (shows only on current hour of today)
                /// Displays a red arrow and line to mark the present time
                if (showCurrentTime)
                  Padding(
                    padding: EdgeInsets.only(top: 18.h),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 45.w),
                        // Red arrow pointing to current time
                        Transform.translate(
                          offset: const Offset(8, 0),
                          child: Icon(
                            Icons.arrow_right_sharp,
                            size: 20.dg,
                            color: AppColors.kDE3B40,
                          ),
                        ),
                        // Red horizontal line extending across the view
                        Expanded(
                          child: Container(
                            height: 2,
                            color: AppColors.kDE3B40.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                /// Event card for this time slot
                /// Each event is displayed as an EventItem widget
                Padding(
                  padding: EdgeInsets.only(left: 60.w, top: 8.h),
                  child: EventItem(
                    event: event,
                    hourHeight: controller.hourHeight,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
