import 'package:intl/intl.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A header widget for the schedule calendar, displaying:
/// - The currently focused month (e.g., *January 2025*)
/// - A weekly range (e.g., *Jan 1 – Jan 7*)
/// - Left/right buttons to navigate between weeks
///
/// This widget listens reactively to changes in the
/// [MySchedulesController.focusedDay] via `Obx`.
/// Whenever the focused date updates, the displayed
/// month and week range automatically refresh.
class CalendarHeader extends GetView<MySchedulesController> {
  /// Creates an instance of [CalendarHeader].
  ///
  /// The [key] can be used to control the widget’s lifecycle.
  const CalendarHeader({super.key});

  /// Builds the header user interface consisting of:
  /// - A left-aligned month label in bold text
  /// - A right-aligned row showing:
  ///   - A button to go to the previous week
  ///   - The formatted current week range
  ///   - A button to go to the next week
  ///
  /// This widget rebuilds reactively using `Obx` whenever
  /// the controller’s `focusedDay` changes.
  @override
  Widget build(BuildContext context) => Obx(
    () => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Displays the currently focused month (e.g., "January 2025").
          Text(
            DateFormat.yMMMM().format(controller.focusedDay.value),
            style: AppTextStyle.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          /// Contains week navigation controls and week range text.
          Row(
            children: <Widget>[
              /// Moves backward one week by subtracting 7 days.
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  controller.focusedDay.value = controller.focusedDay.value
                      .subtract(const Duration(days: 7));
                },
              ),

              /// Displays the current week's range:
              /// `Mon - Sun` (formatted using `MMM d`)
              ///
              /// The start of the week is determined by:
              ///   `focusedDay - (weekday - 1)`
              ///
              /// The end of the week is determined by:
              ///   `focusedDay + (7 - weekday)`
              Text(
                '${DateFormat.MMMd().format(controller.focusedDay.value.subtract(Duration(days: controller.focusedDay.value.weekday - 1)))} - '
                '${DateFormat.MMMd().format(controller.focusedDay.value.add(Duration(days: DateTime.daysPerWeek - controller.focusedDay.value.weekday)))}',
                style: AppTextStyle.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              /// Moves forward one week by adding 7 days.
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  controller.focusedDay.value = controller.focusedDay.value.add(
                    const Duration(days: 7),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
