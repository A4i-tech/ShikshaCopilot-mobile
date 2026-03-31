import 'package:sikshana/app/utils/exports.dart';

/// A customizable arrow button widget with bordered container styling.
///
/// This widget creates a compact, icon-based button typically used for
/// navigation actions like "previous" and "next" arrows. The button has
/// a light gray border and dark blue icon.
///
/// Example usage:
/// ```dart
/// ArrowButton(
///   icon: Icons.arrow_back,
///   onPressed: () {
///     // Navigate to previous page
///   },
/// )
/// ```
class ArrowButton extends StatelessWidget {
  /// Creates an [ArrowButton] widget.
  ///
  /// Parameters:
  /// - [icon]: The icon to display in the button (required).
  /// - [onPressed]: Callback function when the button is tapped (required).
  const ArrowButton({required this.icon, required this.onPressed, super.key});

  /// The icon displayed inside the button.
  ///
  /// Typically uses directional icons like [Icons.arrow_back],
  /// [Icons.arrow_forward], [Icons.chevron_left], or [Icons.chevron_right].
  final IconData icon;

  /// Callback function triggered when the button is tapped.
  ///
  /// Used to handle navigation or other actions when the user
  /// interacts with the button.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.all(6.dg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4).r,
        border: Border.all(color: AppColors.kEBEBEB),
      ),
      child: Icon(icon, color: AppColors.k344767, size: 18.dg),
    ),
  );
}
