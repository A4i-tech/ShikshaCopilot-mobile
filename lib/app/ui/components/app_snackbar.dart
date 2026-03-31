import 'package:sikshana/app/utils/exports.dart';

/// State of the snackbar
/// Setting this will set the background color of the snackbar
enum SnackBarType {
  /// Bottom Snackbar
  bottom,

  /// Top Snackbar
  top,
}

/// SnackBar state
enum SnackBarState {
  /// Info state
  info,

  /// Warning state
  warning,

  /// Danger state
  danger,

  /// Default state
  success,

  /// Default state
  defaultState,
}

/// App themed snackbar
void appSnackBar({
  required String message,
  SnackBarType type = SnackBarType.bottom,
  SnackBarState state = SnackBarState.defaultState,
  void Function()? onTryAgain,
  bool showTryAgain = false,
}) {
  if (type == SnackBarType.top) {
    Get.rawSnackbar(
      borderColor: _topSnackBarBorderColor(state),
      margin: REdgeInsets.all(16),
      padding: REdgeInsets.all(16),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(_topSnackBarIcon(state), color: _topSnackBarIconColor(state)),
          12.horizontalSpace,
          Expanded(
            child: Padding(
              padding: REdgeInsets.only(top: 2.5),
              child: RichText(
                text: TextSpan(
                  text: message,
                  style: AppTextStyle.lato(
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    fontSize: 12.sp,
                    color: AppColors.k46A0F1,
                  ),
                  children: <InlineSpan>[
                    if (state == SnackBarState.danger &&
                        showTryAgain) ...<InlineSpan>[
                      TextSpan(
                        text: '\nPlease try again.',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            onTryAgain?.call();
                          },
                        style: AppTextStyle.lato(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: AppColors.k46A0F1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          12.horizontalSpace,
          InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(color: AppColors.k46A0F1, Icons.close),
          ),
        ],
      ),
      backgroundColor: _topSnackBarColor(state),
      borderRadius: 6.r,
      duration: Duration(seconds: showTryAgain ? 10 : 2),
      snackPosition: SnackPosition.TOP,
    );
  } else {
    Get.rawSnackbar(
      icon: Icon(_snackBarIcon(state), color: Colors.white),
      margin: const EdgeInsets.all(8),
      messageText: Text(message, style: AppTextStyle.lato(color: Colors.white)),
      backgroundColor: _snackBarColor(state),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }
}

Color _snackBarColor(SnackBarState state) {
  switch (state) {
    case SnackBarState.info:
      return Colors.blue;
    case SnackBarState.warning:
      return Colors.orangeAccent;
    case SnackBarState.danger:
      return Colors.red;
    case SnackBarState.defaultState:
      return Colors.blueGrey;
    case SnackBarState.success:
      return Colors.green;
  }
}

Color _topSnackBarColor(SnackBarState state) {
  switch (state) {
    case SnackBarState.info:
      return AppColors.kEBF8FF;
    case SnackBarState.danger:
      return AppColors.kFFF8F8;
    case SnackBarState.success:
      return AppColors.kEDFCF5;
    case SnackBarState.warning:
    case SnackBarState.defaultState:
      return AppColors.kEBF8FF;
  }
}

Color _topSnackBarBorderColor(SnackBarState state) {
  switch (state) {
    case SnackBarState.info:
      return AppColors.k0070F2;
    case SnackBarState.danger:
      return AppColors.kDE1A1A;
    case SnackBarState.success:
      return AppColors.k75B798;
    case SnackBarState.warning:
    case SnackBarState.defaultState:
      return AppColors.k0070F2;
  }
}

Color _topSnackBarIconColor(SnackBarState state) {
  switch (state) {
    case SnackBarState.info:
      return AppColors.k0070F2;
    case SnackBarState.danger:
      return AppColors.kDE1A1A;
    case SnackBarState.success:
      return AppColors.k75B798;
    case SnackBarState.warning:
    case SnackBarState.defaultState:
      return AppColors.k0070F2;
  }
}

IconData _snackBarIcon(SnackBarState state) {
  switch (state) {
    case SnackBarState.info:
      return Icons.info;
    case SnackBarState.warning:
      return Icons.warning;
    case SnackBarState.danger:
      return Icons.error;
    case SnackBarState.defaultState:
      return Icons.notifications_active;
    case SnackBarState.success:
      return Icons.check_circle;
  }
}

IconData _topSnackBarIcon(SnackBarState state) {
  switch (state) {
    case SnackBarState.info:
      return Icons.info;
    case SnackBarState.danger:
      return Icons.error;
    case SnackBarState.success:
      return Icons.check_circle;
    case SnackBarState.warning:
    case SnackBarState.defaultState:
      return Icons.info;
  }
}
