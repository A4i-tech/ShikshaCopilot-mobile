import 'package:get_storage/get_storage.dart';
import 'package:sikshana/app/modules/auth/models/otp_model.dart';
import 'package:sikshana/app/modules/auth/models/validate_otp_model.dart';
import 'package:sikshana/app/utils/exports.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// A controller for the Auth module, managing user authentication.
class AuthController extends GetxController {
  /// Form Key for the phone number input form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Form Key for the OTP input form.
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  /// Controller for the phone number text field.
  final TextEditingController phoneController = TextEditingController();

  /// A reactive boolean to track the state of the "Remember Me" checkbox.
  final RxBool rememberMe = false.obs;

  /// A reactive string to hold the OTP value.
  final RxString otp = ''.obs;

  /// A reactive boolean to indicate loading state, useful for showing spinners.
  final RxBool loading = false.obs;

  /// Repository for handling authentication-related API calls.
  final AuthApiRepo _authApiRepo = AuthApiRepo();

  /// Reactive boolean to control the visibility of the "Resend Pin" text.
  final RxBool showResendPin = false.obs;

  /// Instance of GetStorage for persisting data locally.
  final GetStorage _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // On controller initialization, attempt to load saved credentials.
    _loadCredentials();
  }

  /// Loads credentials from local storage if "Remember Me" was previously true.
  void _loadCredentials() {
    final bool isRemembered = _box.read('rememberMe') ?? false;
    rememberMe.value = isRemembered;
    if (isRemembered) {
      // If the user chose to be remembered, pre-fill the phone number and OTP.
      phoneController.text = _box.read('mobile') ?? '';
      otp.value = _box.read('otp') ?? '';
    }
  }

  /// Saves or clears credentials based on the "Remember Me" checkbox state.
  ///
  /// If `rememberMe` is true, the user's mobile number and OTP are stored
  /// locally. Otherwise, any stored credentials are removed.
  /// It also handles user login by calling `UserProvider.onLogin` with
  /// the validated user data and token.
  ///
  /// Parameters:
  /// - `res`: The [ValidateOtpModel] containing the user data and token
  ///   after successful OTP validation.
  Future<void> _handleCredentialsPersistence({
    required ValidateOtpModel res,
  }) async {
    if (res.data?.user != null && res.data?.token != null) {
      await UserProvider.onLogin(
        res.data!.user!,
        res.data!.token!,
        res.data!.user!.preferredLanguage ?? 'en',
      );
    }
    if (rememberMe.value) {
      // If "Remember Me" is enabled, write the mobile number and OTP to storage.
      await _box.write('rememberMe', true);
      await _box.write('mobile', phoneController.text);
      await _box.write('otp', otp.value);
    } else {
      // If "Remember Me" is disabled, remove any previously saved credentials.
      await _box.remove('rememberMe');
      await _box.remove('mobile');
      await _box.remove('otp');
    }
  }

  /// Triggered when the "Continue" button is pressed.
  ///
  /// This method validates the phone number input, shows a loading indicator,
  /// and attempts to request an OTP from the server. If successful, it
  /// displays the [OtpAlertDialog] for OTP entry.
  Future<void> onContinue() async {
    if (formKey.currentState!.validate()) {
      loading(true);
      Loader.show();
      try {
        final OtpModel? otpModel = await _authApiRepo.getOtp(
          phone: phoneController.text,
          rememberMe: rememberMe.value,
        );
        if (otpModel != null && (otpModel.success ?? false)) {
          // If OTP request is successful, show the OTP entry dialog.
          if (otpModel.data?.otpTriggered ?? false) {
            showResendPin(true);
          }
          unawaited(Get.dialog(const OtpAlertDialog()));
        } else {
          // If OTP request fails, show an error message.
          if (!Get.isSnackbarOpen) {
            appSnackBar(
              message: otpModel?.message ?? 'Something went wrong',
              type: SnackBarType.top,
              state: SnackBarState.danger,
            );
          }
        }
      } finally {
        Loader.dismiss();
        loading(false);
      }
    }
  }

  /// Automatically validates the OTP if it exists and "Remember Me" is enabled.
  ///
  /// This method is typically called after the widget tree has been built
  /// to attempt automatic OTP verification.
  void autoValidate() {
    if (otp.value.isNotEmpty && rememberMe.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        verifyOtp(otpString: otp.value);
      });
    }
  }

  /// Verifies the OTP entered by the user.
  ///
  /// Validates the OTP form, shows a loading indicator, and sends the
  /// phone number and OTP to the server for verification. On successful
  /// verification, it handles credential persistence and navigates to the
  /// home screen. If verification fails, it displays an error message.
  ///
  /// Parameters:
  /// - `otpString`: An optional OTP string to verify. If null, uses the
  ///   current `otp.value`.
  Future<void> verifyOtp({String? otpString}) async {
    if (otpFormKey.currentState!.validate()) {
      loading(true);
      otp.value = otpString ?? otp.value;
      final ValidateOtpModel? validateOtpModel = await _authApiRepo.validateOtp(
        phone: phoneController.text,
        otp: otp.value,
      );
      loading(false);
      if (validateOtpModel != null && (validateOtpModel.success ?? false)) {
        // After successful OTP verification, handle credential persistence.
        await _handleCredentialsPersistence(res: validateOtpModel);
        otp('');
        unawaited(
          Get.offNamedUntil(
            Routes.NAVIGATION_SCREEN,
            (Route<dynamic> route) => false,
          ),
        );
      } else {
        // If OTP is invalid, show an error message.
        appSnackBar(
          message: validateOtpModel?.message ?? 'Invalid OTP',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    }
  }

  /// Resends the OTP to the user's phone number.
  ///
  /// Closes any open dialogs, shows a loading indicator, and requests a
  /// new OTP from the server. On success, it displays a success message
  /// and re-opens the [OtpAlertDialog].
  Future<void> resendOtp() async {
    if (formKey.currentState!.validate()) {
      Get.back();

      loading(true);
      final OtpModel? otpModel = await _authApiRepo.getOtp(
        phone: phoneController.text,
        rememberMe: rememberMe.value,
        forgotPassword: true,
      );
      loading(false);
      if (otpModel != null && (otpModel.success ?? false)) {
        // If OTP request is successful, show the OTP entry dialog.
        otp('');
        appSnackBar(
          message: otpModel.message ?? 'PIN sent successfully',
          type: SnackBarType.top,
          state: SnackBarState.info,
        );
        unawaited(Get.dialog(const OtpAlertDialog()));
      } else {
        // If OTP request fails, show an error message.
        appSnackBar(
          message: otpModel?.message ?? 'Something went wrong',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    }
  }

  /// Handles the tap event on the FAQ link.
  ///
  /// Launches the FAQ URL in an in-app browser view.
  void onFaqTap() {
    LaunchUrl.launch(
      'https://sikshana.pacewisdom.in/#/faq',
      mode: LaunchMode.inAppBrowserView,
    );
  }

  @override
  void onClose() {
    // Ensure the dialog is closed if open.
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    // Dispose of the text controller to free up resources.
    phoneController.dispose();
    super.onClose();
  }
}
