import 'package:intl/intl.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a horizontal week selector for schedule navigation.
///
/// This widget provides an interactive week view selector that allows users to:
/// - View all 7 days of the current week in a horizontal scrollable list
/// - Navigate between days using left/right chevron buttons
/// - Select a specific day by tapping on it
/// - See the currently selected day highlighted with a border and blue text
/// - Automatically load previous/next weeks when navigating beyond current week boundaries
///
/// Visual layout:
/// ```
/// [←] [Mon Apr 1] [Tue Apr 2] [Wed Apr 3] ... [Sun Apr 7] [→]
/// ```
///
/// The selected day is highlighted with:
/// - A border around the day container
/// - Blue colored date text
///
/// Example usage:
/// ```dart
/// WeekSelectorWidget()
/// ```
class WeekSelectorWidget extends GetView<MySchedulesController> {
  /// Creates a [WeekSelectorWidget].
  ///
  /// This widget automatically connects to [MySchedulesController] through GetX
  /// and responds to changes in selected day and week range.
  const WeekSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) => Obx(
    () => Container(
      decoration: BoxDecoration(
        color: AppColors.kF6F8FA,
        borderRadius: BorderRadius.circular(6).r,
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      height: 74.h,
      child: Row(
        children: <Widget>[
          /// Left navigation button - moves to previous day
          /// Automatically loads previous week if moving before current week start
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              // Calculate the new day (previous day)
              final DateTime newSelectedDay = controller.selectedDay.value!
                  .subtract(const Duration(days: 1));

              // Check if we need to load the previous week
              if (newSelectedDay.isBefore(controller.startOfWeek)) {
                controller.onPageChanged(newSelectedDay);
              }

              // Update selected day
              controller.onDaySelected(newSelectedDay, newSelectedDay);
            },
          ),

          /// Week days list - scrollable horizontally
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                controller: controller.weekScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(7, (int index) {
                    // Calculate the date for this day cell
                    final DateTime day = controller.startOfWeek.add(
                      Duration(days: index),
                    );

                    // Check if this day is currently selected
                    final bool isSelected = isSameDay(
                      day,
                      controller.selectedDay.value,
                    );

                    return GestureDetector(
                      onTap: () => controller.onDaySelected(day, day),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 16.w,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          // Show border only for selected day
                          border: isSelected
                              ? Border.all(color: AppColors.kEBEBEB, width: 2)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /// Day of week abbreviation (e.g., "Mon", "Tue")
                            Text(
                              DateFormat.E().format(day),
                              style: AppTextStyle.lato(fontSize: 14.sp),
                            ),
                            6.verticalSpace,

                            /// Month and day number (e.g., "Apr 8", "Nov 28")
                            /// Blue when selected, gray when not
                            Text(
                              DateFormat('MMM d').format(day),
                              style: AppTextStyle.lato(
                                color: isSelected
                                    ? AppColors.k46A0F1
                                    : AppColors.k84828A,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,

                                decoration: !controller.isToday(day)
                                    ? null
                                    : TextDecoration.underline,
                                decorationStyle: !controller.isToday(day)
                                    ? null
                                    : TextDecorationStyle.solid,
                                decorationColor: !controller.isToday(day)
                                    ? null
                                    : AppColors.k46A0F1,
                                decorationThickness: !controller.isToday(day)
                                    ? null
                                    : 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          /// Right navigation button - moves to next day
          /// Automatically loads next week if moving after current week end
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              // Calculate the new day (next day)
              final DateTime newSelectedDay = controller.selectedDay.value!.add(
                const Duration(days: 1),
              );

              // Calculate the last day of current week
              final DateTime endOfWeek = controller.startOfWeek.add(
                const Duration(days: 6),
              );

              // Check if we need to load the next week
              // Compare date-only (without time) to avoid time-based comparison issues
              if (DateTime(
                newSelectedDay.year,
                newSelectedDay.month,
                newSelectedDay.day,
              ).isAfter(endOfWeek)) {
                controller.onPageChanged(newSelectedDay);
              }

              // Update selected day
              controller.onDaySelected(newSelectedDay, newSelectedDay);
            },
          ),
        ],
      ),
    ),
  );
}
