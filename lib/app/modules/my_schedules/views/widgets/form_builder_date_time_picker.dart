import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A custom date and time picker widget with label and consistent styling.
///
/// This widget wraps [FormBuilderDateTimePicker] with a standardized appearance
/// that matches the app's design system. It supports both date and time picking
/// modes with customizable formatting.
///
/// Features:
/// - Labeled input field with consistent styling
/// - Support for date-only, time-only, or date-time picking
/// - Optional suffix icon (automatically flipped horizontally)
/// - Enabled/disabled state with visual feedback
/// - Form validation support
/// - Customizable date/time format
///
/// Example usage:
/// ```dart
/// FormBuilderDateTimePickerWidget(
///   name: 'start_date',
///   label: 'Start Date',
///   inputType: InputType.date,
///   format: DateFormat('MMM d, yyyy'),
///   suffixIcon: Icons.calendar_today,
///   validator: (val) => val == null ? 'Required' : null,
/// )
/// ```
class FormBuilderDateTimePickerWidget extends StatelessWidget {
  /// Creates a [FormBuilderDateTimePickerWidget].
  ///
  /// Parameters:
  /// - [name]: Form field identifier for value storage and retrieval (required).
  /// - [label]: Text label displayed above the input field (required).
  /// - [inputType]: Type of picker (date, time, or both) (required).
  /// - [format]: Date/time format for display (required).
  /// - [initialValue]: Pre-filled date/time value (optional).
  /// - [enabled]: Whether the field is editable (default: true).
  /// - [suffixIcon]: Icon displayed on the right side (optional).
  /// - [validator]: Function to validate the selected date/time (optional).
  /// - [key]: Widget key for identification (optional).
  const FormBuilderDateTimePickerWidget({
    required this.name,
    required this.label,
    required this.inputType,
    required this.format,
    this.initialValue,
    this.enabled = true,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    super.key,
  });

  /// Unique identifier for this form field.
  ///
  /// Used to store and retrieve the field's value from the form state.
  final String name;

  /// Label text displayed above the input field.
  ///
  /// Styled in bold with a dark gray color to clearly identify the field.
  final String label;

  /// Initial date/time value to display in the picker.
  ///
  /// If null, the field will be empty until the user selects a value.
  final DateTime? initialValue;

  /// Whether the field is enabled for user interaction.
  ///
  /// When false, the field is displayed with a gray background
  /// and cannot be modified by the user.
  final bool enabled;

  /// Type of date/time picker to display.
  ///
  /// Options:
  /// - [InputType.date]: Date picker only
  /// - [InputType.time]: Time picker only
  /// - [InputType.both]: Combined date and time picker
  final InputType inputType;

  /// Format for displaying the selected date/time.
  ///
  /// Uses [DateFormat] from the intl package.
  /// Examples:
  /// - `DateFormat('MMM d, yyyy')` → "Nov 28, 2024"
  /// - `DateFormat('h:mm a')` → "2:30 PM"
  /// - `DateFormat('E, MMM d')` → "Thu, Nov 28"
  final DateFormat format;

  /// Optional icon displayed on the right side of the input field.
  ///
  /// The icon is automatically flipped horizontally using a matrix transformation.
  /// Common icons: [Icons.calendar_today], [CupertinoIcons.clock]
  final IconData? suffixIcon;

  /// Validation function for the selected date/time.
  ///
  /// Receives the selected [DateTime] value (or null if empty) and returns
  /// an error message string if validation fails, or null if valid.
  ///
  /// Example:
  /// ```dart
  /// validator: (DateTime? val) => val == null ? 'Date is required' : null
  /// ```
  final String? Function(DateTime?)? validator;

  /// Optional callback function when the value changes.
  final void Function(DateTime?)? onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      /// Label text above the input field
      Text(
        label,
        style: AppTextStyle.lato(
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
          color: AppColors.k424955,
        ),
      ),
      4.verticalSpace,

      /// Date/time picker input field
      FormBuilderDateTimePicker(
        name: name,
        initialValue: initialValue,
        enabled: enabled,
        inputType: inputType,
        format: format,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          // White background when enabled, gray when disabled
          fillColor: enabled ? Colors.white : AppColors.kF3F4F6,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          // Standard border styling for all states
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: const BorderSide(color: AppColors.k9095A0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: const BorderSide(color: AppColors.k9095A0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: const BorderSide(color: AppColors.k9095A0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: const BorderSide(color: AppColors.k9095A0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: const BorderSide(color: AppColors.k9095A0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          // Suffix icon with horizontal flip transformation
          suffixIcon: suffixIcon != null
              ? Transform(
                  alignment: Alignment.center,
                  // Flips icon horizontally (180° rotation on Y-axis)
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(
                    suffixIcon,
                    color: AppColors.k171A1F,
                    size: 14.dg,
                  ),
                )
              : null,
        ),
        style: AppTextStyle.lato(
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          color: AppColors.k171A1F,
        ),
        validator: validator,
      ),
    ],
  );
}
