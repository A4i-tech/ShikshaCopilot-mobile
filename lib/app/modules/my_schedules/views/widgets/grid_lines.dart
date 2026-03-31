import 'package:sikshana/app/utils/exports.dart';

/// A widget that renders horizontal grid lines for a schedule view.
///
/// This widget creates a visual grid structure by drawing horizontal lines
/// at regular intervals, typically used as a background for displaying
/// scheduled events in a calendar or timetable view.
///
/// Each grid line represents one hour slot and includes:
/// - A horizontal line at the top (separating hours)
/// - A vertical line on the left (creating columns for days)
///
/// The lines create a consistent grid structure that helps users
/// visually align events with their corresponding time slots.
///
/// Example usage:
/// ```dart
/// GridLines(
///   hours: List.generate(12, (i) => 7 + i), // 7 AM to 6 PM
///   hourHeight: 60.0,
/// )
/// ```
class GridLines extends StatelessWidget {
  /// Creates a [GridLines] widget.
  ///
  /// Parameters:
  /// - [hours]: List of hour values to create grid lines for (required).
  /// - [hourHeight]: Height in pixels for each hour slot (required).
  /// - [key]: Widget key for identification (optional).
  const GridLines({required this.hours, required this.hourHeight, super.key});

  /// List of hour values representing each time slot in the schedule.
  ///
  /// Each hour in this list results in one horizontal grid line.
  /// Typically generated as a sequential list (e.g., 7, 8, 9... for 7 AM, 8 AM, 9 AM...).
  ///
  /// Example:
  /// ```dart
  /// List.generate(12, (i) => 7 + i) // Creates hours from 7 to 18 (7 AM to 6 PM)
  /// ```
  final List<int> hours;

  /// Height in pixels allocated for each hour slot.
  ///
  /// Determines the vertical spacing between grid lines, affecting
  /// the overall height of the schedule view and the visual density
  /// of events displayed.
  ///
  /// Typical values range from 40 to 80 pixels depending on the
  /// desired schedule density.
  final double hourHeight;

  @override
  Widget build(BuildContext context) => Column(
    children: hours
        .map(
          // Creates one container per hour with top and left borders
          (_) => Container(
            height: hourHeight,
            decoration: const BoxDecoration(
              border: Border(
                // Left border creates vertical column separators
                left: BorderSide(color: AppColors.kDCDEE4),
                // Top border creates horizontal hour separators
                top: BorderSide(color: AppColors.kDCDEE4),
              ),
            ),
          ),
        )
        .toList(),
  );
}
