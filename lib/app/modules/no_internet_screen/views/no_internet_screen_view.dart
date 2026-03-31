import 'package:sikshana/app/utils/exports.dart';

/// A view that is displayed when there is no internet connection.
class NoInternetScreenView extends GetView<NoInternetScreenController> {
  ///NoInternetScreenView constructor
  const NoInternetScreenView({super.key});

  @override
  /// Builds the UI for the no internet screen.
  ///
  /// This method displays a message, a Lottie animation, and a button to retry
  /// the connection.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Scaffold` widget displaying the no internet screen.
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.kFFFFFF,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Lost Connection!',
            textAlign: TextAlign.center,
            style: AppTextStyle.lato(
              color: AppColors.k171A1F,
              fontWeight: FontWeight.w500,
              fontSize: 22.sp,
            ),
          ),
          Lottie.asset(
            AppImages.noInternet,
            fit: BoxFit.fitHeight,
            height: 300.h,
            width: 300.w,
          ),
          Text(
            'No Internet connection was found.\nPlease check your connection.',
            textAlign: TextAlign.center,
            style: AppTextStyle.lato(
              color: AppColors.k171A1F,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
          40.verticalSpace,
          Obx(
            () => SizedBox(
              width: 150.w,
              child: AppButton(
                buttonText: controller.isChecking() ? 'Checking' : 'Try again',
                onPressed: controller.isChecking()
                    ? () {}
                    : controller.checkConnection,
                height: 40.h,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
