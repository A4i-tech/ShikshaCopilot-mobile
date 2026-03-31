import 'package:sikshana/app/utils/exports.dart';

/// Loader
class Loader {
  /// Is Open Dialog
  static bool isOpen = false;

  /// Is More Than 20 Sec
  static RxBool isTakingMoreThan20Sec = false.obs;

  /// Show Dialog
  static void show({String? msg}) {
    FocusScope.of(Get.context!).unfocus();

    isTakingMoreThan20Sec(false);

    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.transparent
      ..indicatorColor = Colors.transparent
      ..textColor = Colors.transparent
      ..boxShadow = <BoxShadow>[];

    if (!isOpen) {
      isOpen = true;

      if ((msg?.isNotEmpty ?? false) && msg != null) {
        Future<void>.delayed(const Duration(seconds: 20), () {
          isTakingMoreThan20Sec(true);
        });
      }
      EasyLoading.show(
        indicator: PopScope(
          canPop: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Lottie.asset(
                  AppImages.loader,
                  width: 120.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                ),
                5.verticalSpace,
                Obx(
                  () => isTakingMoreThan20Sec()
                      ? Text(
                          'Loading...',
                          style: AppTextStyle.lato(color: AppColors.k46A0F1),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
    }
  }

  /// Dismiss Dialog
  static void dismiss() {
    if (isOpen) {
      isOpen = false;
      EasyLoading.dismiss();
    }
  }
}
