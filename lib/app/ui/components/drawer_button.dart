import 'package:sikshana/app/utils/exports.dart';

/// A button that opens the drawer.
class AppDrawerButton extends StatelessWidget {
  /// Constructor for the [AppDrawerButton] widget.
  const AppDrawerButton({required this.onPressed, super.key, this.color});

  /// The function to be executed when the button is pressed.
  final void Function() onPressed;

  /// The color of the icon.
  final Color? color;

  @override
  Widget build(BuildContext context) => IconButton(
    icon: SvgPicture.asset(height: 23.h, width: 23.w, AppImages.drawer),
    onPressed: () {
      onPressed.call();
    },
  );
}
