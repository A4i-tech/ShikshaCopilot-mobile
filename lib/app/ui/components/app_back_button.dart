import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Back button
class AppBackButton extends StatelessWidget {
  /// Back button Constructor
  const AppBackButton({this.onBack, super.key});

  /// On pressed
  final void Function()? onBack;

  @override
  Widget build(BuildContext context) => IconButton(
    icon: Icon(CupertinoIcons.back, size: 24.dg, color: AppColors.k000000),
    onPressed: () {
      if (onBack != null) {
        onBack!();
      } else {
        Get.back();
      }
    },
  );
}
