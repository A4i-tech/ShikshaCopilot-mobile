import 'package:sikshana/app/utils/exports.dart';

import '../controllers/splash_screen_controller.dart';

/// A view that displays a splash screen with an animated logo.
class SplashScreenView extends GetView<SplashScreenController> {
  /// Constructs a [SplashScreenView].
  const SplashScreenView({super.key});

  @override
  /// Builds the UI for the splash screen.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Scaffold` widget containing the animated logo and text.
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
    extendBodyBehindAppBar: true,
    backgroundColor: AppColors.kFFFFFF,
    body: Center(
      child: AnimatedBuilder(
        animation: controller.animation,
        builder: (BuildContext context, Widget? child) => Transform.scale(
          scale: controller.animation.value,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppImages.copilotLogo,
                  width: 125.dg,
                  height: 125.dg,
                ),
                Text(
                  'Empowering Educators with GenAI.',
                  style: AppTextStyle.lato(fontSize: 18.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 20.dg),
  );
}
