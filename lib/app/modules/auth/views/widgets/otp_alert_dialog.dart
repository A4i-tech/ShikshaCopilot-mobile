import 'package:sikshana/app/utils/exports.dart';

/// A dialog box widget used to collect the OTP (One-Time Password) from the user.
///
/// This dialog provides an input field for the OTP, along with options to
/// resend the PIN or contact support. It integrates with [AuthController]
/// for OTP verification and state management.
class OtpAlertDialog extends StatefulWidget {
  /// Creates a [OtpAlertDialog] widget.
  const OtpAlertDialog({super.key});

  @override
  State<OtpAlertDialog> createState() => _OtpAlertDialogState();
}

/// The state class for the [OtpAlertDialog] widget.
///
/// Manages the local state of the OTP input field and interacts with the
/// [AuthController] for OTP verification and other actions.
class _OtpAlertDialogState extends State<OtpAlertDialog> {
  /// The [AuthController] instance obtained via GetX dependency injection.
  final AuthController controller = Get.find<AuthController>();

  /// Controller for the OTP text field within the dialog.
  final TextEditingController otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Initialize the OTP text field with any pre-filled OTP from the controller.
    otpController.value = TextEditingValue(text: controller.otp());
    // controller.autoValidate(); // This line is commented out, but its intent is to auto-validate if necessary.
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    backgroundColor: AppColors.kFFFFFF,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Get.back(closeOverlays: true);
              },
              icon: Icon(Icons.close, size: 24.dg, color: AppColors.k141522),
            ),
          ),
          Text(
            LocaleKeys.enterPin.tr,
            style: AppTextStyle.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          12.verticalSpace,
          Text(
            LocaleKeys.pleaseTypeTheCode.tr,
            textAlign: TextAlign.center,
            style: AppTextStyle.lato(fontSize: 12.sp, color: AppColors.k344767),
          ),
          30.verticalSpace,
          Form(
            key: controller.otpFormKey,
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              autoFocus: controller.otp().isEmpty,
              controller: otpController,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              validator: (String? val) {
                if (val!.contains(RegExp(r'(\D)'))) {
                  return LocaleKeys.invalidPhoneNumber.tr;
                }
                if (!val.contains(RegExp(r'(\d{4})'))) {
                  return LocaleKeys.pleaseTypeTheCode.tr;
                }
                final RegExp spaceRegex = RegExp(r'\s');
                if (spaceRegex.hasMatch(val)) {
                  return LocaleKeys.invalidPhoneNumber.tr;
                }
                return null;
              },
              textStyle: AppTextStyle.lato(
                fontSize: 20.sp,
                color: AppColors.k46A0F1,
                fontWeight: FontWeight.w700,
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8).r,
                fieldHeight: 48.h,
                fieldWidth: 48.w,
                activeFillColor: AppColors.kFFFFFF,
                inactiveFillColor: AppColors.kFFFFFF,
                selectedFillColor: AppColors.kFFFFFF,
                activeColor: AppColors.k46A0F1,
                inactiveColor: AppColors.kEBEBEB,
                selectedColor: AppColors.k46A0F1,
              ),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              onChanged: (String value) {
                controller.otp.value = value;
              },
              onCompleted: (String otp) {
                controller.verifyOtp(otpString: otp);
              },
            ),
          ),
          30.verticalSpace,
          Obx(
            () => AppButton(
              buttonText: LocaleKeys.verify.tr,
              buttonTextColor: AppColors.kFFFFFF,
              buttonColor: controller.otp.value.length == 4
                  ? AppColors.k46A0F1
                  : AppColors.k46A0F1.withOpacity(0.5),
              loader: controller.loading(),
              loaderColor: AppColors.kFFFFFF,
              onPressed: () {
                controller.verifyOtp();
              },
            ),
          ),
          12.verticalSpace,
          TextButton(
            onPressed: controller.resendOtp,
            child: Text(
              controller.showResendPin()
                  ? LocaleKeys.resendPin.tr
                  : LocaleKeys.forgotYourPin.tr,
              style: AppTextStyle.lato(
                fontSize: 14.sp,
                color: AppColors.k46A0F1,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.k46A0F1,
              ),
            ),
          ),
          30.verticalSpace,
          Text(
            LocaleKeys.havingTroubleAccessingApplication.tr,
            style: AppTextStyle.lato(fontSize: 12.sp, color: AppColors.k344767),
          ),
          // TextButton(
          //   onPressed: () {
          //     // TODO: Handle contact representative
          //   },
          //   child:
          Text(
            LocaleKeys.contactSikshanaRepresentatives.tr,
            style: AppTextStyle.lato(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.k46A0F1,
            ),
          ),
          // ),
        ],
      ),
    ),
  );
}
