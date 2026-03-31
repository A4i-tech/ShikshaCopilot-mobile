import 'package:intl/intl.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A header widget that displays the day of the week and date number.
///
/// This widget is typically used in calendar or schedule views to show
/// individual day headers. It highlights the current day with a blue color
/// and displays other days in gray.
///
/// The header shows:
/// - Day abbreviation (e.g., "MON", "TUE") in uppercase
/// - Day number (e.g., "1", "15", "28")
///
/// Example usage:
/// ```dart
/// DayHeader(day: DateTime(2024, 11, 28))
/// ```
class DayHeader extends StatelessWidget {
  /// Creates a [DayHeader] widget.
  ///
  /// Parameters:
  /// - [day]: The date to display in the header (required).
  const DayHeader({required this.day, super.key});

  /// The date to be displayed in this header.
  ///
  /// Used to show the day of the week abbreviation and day number.
  /// If this date matches today's date, the text is highlighted in blue.
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    /// Determines if the given day is today's date.
    final bool isToday = isSameDay(day, DateTime.now());

    return Container(
      height: 40.h,
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.kDCDEE4)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// Day of week abbreviation (e.g., "MON", "TUE")
            Text(
              DateFormat.E().format(day).toUpperCase(),
              style: AppTextStyle.lato(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isToday ? AppColors.k46A0F1 : AppColors.k84828A,
              ),
            ),

            /// Day number (e.g., "1", "15", "28")
            Text(
              DateFormat.d().format(day),
              style: AppTextStyle.lato(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isToday ? AppColors.k46A0F1 : AppColors.k303030,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
