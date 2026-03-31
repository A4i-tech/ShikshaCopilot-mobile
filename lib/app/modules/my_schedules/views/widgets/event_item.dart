import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a single schedule event item.
///
/// This widget shows event information in a colored, rounded container
/// and provides interactive functionality based on the schedule view mode.
/// In "my schedule" mode, it shows a context menu with options to view,
/// edit, or delete the event. In "others' schedule" mode, it only allows
/// viewing the event details.
///
/// The event card displays:
/// - Class name (bold, primary text)
/// - Topic (colored, underlined text)
///
/// Example usage:
/// ```dart
/// EventItem(
///   event: myEvent,
///   hourHeight: 60.0,
/// )
/// ```
class EventItem extends StatelessWidget {
  /// Creates an [EventItem] widget.
  ///
  /// Parameters:
  /// - [event]: The event data to display (required).
  /// - [hourHeight]: The height allocated per hour in the schedule view (required).
  /// - [key]: Widget key for identification (optional).
  const EventItem({required this.event, required this.hourHeight, super.key});

  /// The event data containing all schedule information.
  ///
  /// Includes details such as class name, topic, teacher, color,
  /// start/end times, and identifiers for database operations.
  final Event event;

  /// The height in pixels allocated for each hour slot in the schedule.
  ///
  /// Used for calculating the visual height of events based on duration.
  /// Currently passed but not actively used in height calculations.
  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    final MySchedulesController controller = Get.find<MySchedulesController>();

    return Builder(
      builder: (BuildContext context) => GestureDetector(
        // Different tap behavior based on schedule view mode:
        // - Others' schedule: Opens view-only dialog
        // - My schedule: Shows context menu with edit/delete options
        onTap: controller.scheduleView() == ScheduleView.others
            ? () => controller.viewEvent(event)
            : () => _showEventOptions(context, event, controller),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1),
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Class name - primary bold text
                Text(
                  event.className,
                  style: AppTextStyle.lato(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                /// Topic - colored and underlined text
                Text(
                  event.topic,
                  style: AppTextStyle.lato(
                    color: event.color,
                    fontSize: 12.sp,
                    decoration: TextDecoration.underline,
                    decorationColor: event.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a context menu with event management options.
  ///
  /// This menu appears when tapping an event in "my schedule" mode
  /// and provides options to:
  /// - View the associated lesson plan
  /// - View event details
  /// - Edit the event
  /// - Delete the event (with confirmation dialog)
  ///
  /// The menu is positioned relative to the tapped event item.
  ///
  /// Parameters:
  /// - [context]: BuildContext for rendering the menu.
  /// - [event]: The event for which to show options.
  /// - [controller]: The schedules controller for handling actions.
  void _showEventOptions(
    BuildContext context,
    Event event,
    MySchedulesController controller,
  ) {
    // Calculate menu position relative to the event item
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: <PopupMenuEntry<dynamic>>[
        /// View Lesson Plan option
        /// Opens the lesson plan associated with this event
        PopupMenuItem<Widget>(
          onTap: () => controller.viewLessonPlan(event, context),
          child: Text(
            LocaleKeys.viewLessonPlan.tr,
            style: AppTextStyle.lato(color: AppColors.k303030, fontSize: 12.sp),
          ),
        ),

        /// View Details option
        /// Opens a read-only view of the event details
        PopupMenuItem<Widget>(
          onTap: () => controller.viewEvent(event),
          child: Text(
            LocaleKeys.view.tr,
            style: AppTextStyle.lato(color: AppColors.k303030, fontSize: 12.sp),
          ),
        ),

        /// Edit option
        /// Opens the event dialog in edit mode
        PopupMenuItem<Widget>(
          onTap: () => controller.editEvent(event),
          child: Text(
            LocaleKeys.edit.tr,
            style: AppTextStyle.lato(color: AppColors.k303030, fontSize: 12.sp),
          ),
        ),

        /// Delete option
        /// Shows confirmation dialog before deleting the event
        PopupMenuItem<Widget>(
          onTap: () {
            DialogManager.deleteConfirmationDialog(
              onPositiveClick: () => controller.deleteSchedule(
                scheduleId: event.scheduleId,
                scheduleDateTimeId: event.scheduleDateTimeId,
              ),
            );
          },
          child: Text(
            LocaleKeys.delete.tr,
            style: AppTextStyle.lato(color: AppColors.k303030, fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}
