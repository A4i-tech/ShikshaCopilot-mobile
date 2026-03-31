import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Dialog Manager
class DialogManager {
  /// Open setting dialog
  static void showMicrophoneAccessDialog({void Function()? onPositiveClick}) {
    showCupertinoDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) => _appDialogWidget(
        message:
            'Seems like you have denied microphone permission. P'
            'lease allow microphone permission to use this feature.',
        negativeText: 'Close',
        positiveText: 'Open Settings',
        onNegativeClick: () {
          Get.back();
        },
        onPositiveClick: () {
          Get.back();
          onPositiveClick?.call();
        },
      ),
    );
  }

  /// Show logout dialog
  static void showLogoutDialog({void Function()? onPositiveClick}) {
    showCupertinoDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) => _appDialogWidget(
        message:
            'Are you sure you want to log out? Please note that logging '
            'out will erase all locally stored data on this device. '
            'This action cannot be undone.\n\n'
            'Do you want to proceed and log out?',
        negativeText: LocaleKeys.cancel.tr,
        positiveText: 'Log Out',
        onNegativeClick: () {
          Get.back();
        },
        onPositiveClick: () {
          Get.back();
          onPositiveClick?.call();
        },
      ),
    );
  }

  /// Show camera permission dialog
  static void showCameraPermissionDialog({void Function()? onPositiveClick}) {
    showCupertinoDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) => _appDialogWidget(
        message:
            'Seems like you have denied camera permission. '
            'Please allow camera permission to proceed.',
        negativeText: 'Close',
        positiveText: 'Open Settings',
        onNegativeClick: () {
          Get.back();
        },
        onPositiveClick: () {
          Get.back();
          onPositiveClick?.call();
        },
      ),
    );
  }

  /// Show gallery permission dialog
  static void showGalleryPermissionDialog({void Function()? onPositiveClick}) {
    showCupertinoDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) => _appDialogWidget(
        message:
            'Seems like you have denied access to Photos & Gallery. '
            'Please allow access to Photos & Gallery to proceed.',
        negativeText: 'Close',
        positiveText: 'Open Settings',
        onNegativeClick: () {
          Get.back();
        },
        onPositiveClick: () {
          Get.back();
          onPositiveClick?.call();
        },
      ),
    );
  }

  /// Show change of override status dialog
  static void onGoBackWarehouse({void Function()? onPositiveClick}) {
    showCupertinoDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) => _appDialogWidget(
        title: 'Are you sure you want to go back?',
        message: 'Please note that all scanned items will be lost.',
        negativeText: 'No, Close',
        positiveText: 'Yes, Go-Back',
        onNegativeClick: () {
          Get.back();
        },
        onPositiveClick: () {
          Get.back();
          onPositiveClick?.call();
        },
      ),
    );
  }

  /// Do you want to exit from app dialog
  static void doYouWantToExitFromApp({void Function()? onPositiveClick}) {
    showCupertinoDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) => _appDialogWidget(
        message: 'Are you sure you want to exit from the app?',
        negativeText: 'No',
        positiveText: 'Yes',
        onNegativeClick: () {
          Get.back();
        },
        onPositiveClick: () {
          Get.back();
          onPositiveClick?.call();
        },
      ),
    );
  }

  /// Show camera permission dialog
  static void showLocationPermissionDialog({
    void Function()? onPositiveClick,
  }) => showCupertinoDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) => _appDialogWidget(
      message:
          'Seems like you have Disabled or Denied Location permission. '
          'To select DROP-OFF LOCATION please allow Location permission.',
      negativeText: 'Close',
      positiveText: 'Open Settings',
      onNegativeClick: () {
        Get.back();
      },
      onPositiveClick: () {
        Get.back();
        onPositiveClick?.call();
      },
    ),
  );

  /// Show delete account dialog
  static void showDeleteAccountDialog({void Function()? onPositiveClick}) =>
      showCupertinoDialog<void>(
        context: Get.context!,
        builder: (BuildContext context) => _appDialogWidget(
          title: 'Delete Account',
          message:
              'Are you sure you want to delete your account? '
              'This action is not reversible and will affect '
              'your current settings',
          negativeText: LocaleKeys.cancel.tr,
          positiveText: 'Yes, Delete',
          onNegativeClick: () {
            Get.back();
          },
          onPositiveClick: () {
            Get.back();
            onPositiveClick?.call();
          },
        ),
      );

  /// Show maps redirection dialog
  static void showMapsRedirectionDialog({void Function()? onPositiveClick}) =>
      showCupertinoDialog<void>(
        context: Get.context!,
        builder: (BuildContext context) => _appDialogWidget(
          title: 'Shiksha',
          message: 'You\'re being redirected to Maps',
          negativeText: LocaleKeys.cancel.tr,
          positiveText: LocaleKeys.continueKey.tr,
          onNegativeClick: () {
            Get.back();
          },
          onPositiveClick: () {
            Get.back();
            onPositiveClick?.call();
          },
        ),
      );

  /// Show delete Confirmation Dialog
  static void deleteConfirmationDialog({void Function()? onPositiveClick}) =>
      showCupertinoDialog<void>(
        context: Get.context!,
        builder: (BuildContext context) => _appDialogWidget(
          title: LocaleKeys.delete.tr,
          message: LocaleKeys.areYouSureYouWantToDeleteThisSchedule.tr,
          negativeText: LocaleKeys.cancel.tr,
          positiveText: LocaleKeys.delete.tr,
          onNegativeClick: () {
            Get.back();
          },
          onPositiveClick: () {
            Get.back();
            onPositiveClick?.call();
          },
        ),
      );

  /// Dialog widget
  static Widget _appDialogWidget({
    required String message,
    required String negativeText,
    required String positiveText,
    String? title,
    Function()? onNegativeClick,
    Function()? onPositiveClick,
  }) => CupertinoAlertDialog(
    title: title != null && title.isNotEmpty
        ? Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.lato(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
            ),
          )
        : null,
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: AppTextStyle.lato(fontSize: 14.sp, fontWeight: FontWeight.w400),
    ),
    actions: <CupertinoDialogAction>[
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          onNegativeClick?.call();
        },
        child: Text(
          negativeText,
          style: AppTextStyle.lato(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      CupertinoDialogAction(
        isDestructiveAction: true,
        onPressed: () {
          onPositiveClick?.call();
        },
        child: Text(
          positiveText,
          style: AppTextStyle.lato(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}
