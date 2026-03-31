import 'package:intl/intl.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a vertical column of time labels for a schedule view.
///
/// This widget creates the left-side time axis of a schedule/calendar view,
/// showing hour labels in 12-hour format (e.g., "7 AM", "2 PM"). Each time
/// label is positioned to align with its corresponding hour row in the schedule.
///
/// Features:
/// - 12-hour time format with AM/PM indicators
/// - Light purple background for visual distinction
/// - Top padding to align with day column headers
/// - Border styling matching the grid lines
/// - Fixed width column for consistent layout
///
/// The time labels help users quickly identify the time slot for any
/// scheduled event in the adjacent day columns.
///
/// Example usage:
/// ```dart
/// TimeColumn(
///   hours: List.generate(12, (i) => 7 + i), // 7 AM to 6 PM
///   hourHeight: 60.0,
/// )
/// ```
class TimeColumn extends StatelessWidget {
  /// Creates a [TimeColumn] widget.
  ///
  /// Parameters:
  /// - [hours]: List of hour values (24-hour format) to display (required).
  /// - [hourHeight]: Height in pixels for each hour slot (required).
  /// - [key]: Widget key for identification (optional).
  const TimeColumn({required this.hours, required this.hourHeight, super.key});

  /// List of hour values in 24-hour format to display as time labels.
  ///
  /// Each hour is converted to 12-hour format with AM/PM for display.
  /// Typically represents business hours (e.g., 7-18 for 7 AM to 6 PM).
  ///
  /// Example:
  /// ```dart
  /// List.generate(12, (i) => 7 + i) // Hours: 7, 8, 9... 18
  /// // Displays as: "7 AM", "8 AM", "9 AM"... "6 PM"
  /// ```
  final List<int> hours;

  /// Height in pixels allocated for each hour slot.
  ///
  /// Must match the hourHeight used in the schedule grid to ensure
  /// proper vertical alignment between time labels and event rows.
  ///
  /// Typical values range from 40 to 80 pixels depending on the
  /// desired schedule density.
  final double hourHeight;

  @override
  Widget build(BuildContext context) => Container(
    width: 45.w,
    // Top padding aligns time labels with day column headers
    padding: EdgeInsets.only(top: 40.h),
    child: Column(
      children: hours
          .map(
            (int hour) => Container(
              height: hourHeight,
              decoration: const BoxDecoration(
                // Borders match the grid line styling
                border: Border(
                  left: BorderSide(color: AppColors.kDCDEE4),
                  top: BorderSide(color: AppColors.kDCDEE4),
                ),
                // Light purple background distinguishes time column from schedule
                color: AppColors.kF8F5F9,
              ),
              child: Center(
                /// Time label in 12-hour format with AM/PM
                /// Example: "7 AM", "2 PM", "11 PM"
                child: Text(
                  DateFormat('h a').format(DateTime(2024, 1, 1, hour)),
                  style: AppTextStyle.lato(
                    fontSize: 12.sp,
                    color: AppColors.k344767,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}
