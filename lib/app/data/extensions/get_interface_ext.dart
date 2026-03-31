import 'package:sikshana/app/utils/exports.dart';

/// Custom dialog launcher
extension CustomDialogLauncher on GetInterface {
  /// Show custom dialog
  void showDialog(Widget dialogContent) => unawaited(
    dialog(
      dialogContent,
      transitionDuration: const Duration(milliseconds: 500),
      useSafeArea: false,
      transitionCurve: Curves.easeInOut,
    ),
  );
}
