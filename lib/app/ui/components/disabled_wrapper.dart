import 'package:flutter/material.dart';

/// A widget that wraps another widget to disable its interaction
class DisabledWrapper extends StatelessWidget {
  /// Creates a [DisabledWrapper].
  const DisabledWrapper({
    required this.isDisabled,
    required this.child,
    Key? key,
    this.disabledOpacity = 0.5,
  }) : super(key: key);

  /// Indicates whether the child widget is disabled.
  final bool isDisabled;

  /// The child widget to be wrapped.
  final Widget child;

  /// The opacity level when the widget is disabled.
  final double disabledOpacity;

  @override
  Widget build(BuildContext context) => AbsorbPointer(
    absorbing: isDisabled, // Prevent interaction when disabled
    child: Opacity(
      opacity: isDisabled ? disabledOpacity : 1.0,
      // Dim the widget if disabled
      child: child,
    ),
  );
}
