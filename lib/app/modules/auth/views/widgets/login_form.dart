import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the login form.
///
/// This form allows users to enter their phone number, choose to remember
/// themselves, and initiate the OTP request process. It integrates with
/// [AuthController] for state management and form validation.
class LoginForm extends GetView<AuthController> {
  /// Creates a [LoginForm] widget.
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) => Form(
    key: controller.formKey,
    child: Column(
      children: <Widget>[
        SvgPicture.asset(
          AppImages.bookSikshana,
          height: 37.h,
          width: 37.w,
          colorFilter: const ColorFilter.mode(
            AppColors.kFFFFFF,
            BlendMode.srcIn,
          ),
        ),
        9.verticalSpace,
        Text(
          'Shiksha copilot',
          style: AppTextStyle.lato(
            color: AppColors.kFFFFFF,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Empowering Educators with GenAI.',
          style: AppTextStyle.lato(color: AppColors.kFFFFFF, fontSize: 12.sp),
        ),
        16.verticalSpace,
        SizedBox(
          width: 250.w,
          child: Text(
            LocaleKeys.signInToYourAccount.tr,
            textAlign: TextAlign.center,
            style: AppTextStyle.lato(
              color: AppColors.kFFFFFF,
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        6.verticalSpace,
        Text(
          LocaleKeys.enterYourPhoneNumberTologin.tr,
          style: AppTextStyle.lato(
            color: AppColors.kFFFFFF,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        26.verticalSpace,
        Card(
          elevation: 0.3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: <Widget>[
                30.verticalSpace,
                IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12).r,
                          border: Border.all(color: AppColors.kEBEBEB),
                        ),
                        child: Center(
                          child: Text(
                            '+91',
                            style: AppTextStyle.lato(
                              fontSize: 14.sp,
                              color: AppColors.k344767,
                            ),
                          ),
                        ),
                      ),
                      6.horizontalSpace,
                      Flexible(
                        child: TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLength: 10,
                          style: AppTextStyle.lato(
                            fontSize: 14.sp,
                            color: AppColors.k344767,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.zero,
                            counter: const SizedBox(),
                            prefix: SizedBox(width: 16.w),
                            prefixIconConstraints: const BoxConstraints(),
                            hintText: '  ${LocaleKeys.enterPhoneNumber.tr}',
                            hintStyle: AppTextStyle.lato(
                              fontSize: 14.sp,
                              color: AppColors.k9095A0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12).r,
                              borderSide: const BorderSide(
                                color: AppColors.kEBEBEB,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12).r,
                              borderSide: const BorderSide(
                                color: AppColors.kEBEBEB,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12).r,
                              borderSide: const BorderSide(
                                color: AppColors.kEBEBEB,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12).r,
                              borderSide: const BorderSide(
                                color: AppColors.kEBEBEB,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12).r,
                              borderSide: const BorderSide(
                                color: AppColors.kEBEBEB,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12).r,
                              borderSide: const BorderSide(
                                color: AppColors.kEBEBEB,
                              ),
                            ),
                          ),
                          validator: (String? val) {
                            if (val!.contains(RegExp(r'(\D)'))) {
                              return LocaleKeys.invalidPhoneNumber.tr;
                            }
                            if (!val.contains(RegExp(r'(\d{10})'))) {
                              return LocaleKeys
                                  .phoneNumberRequiredShouldBe10Digits
                                  .tr;
                            }
                            final RegExp spaceRegex = RegExp(r'\s');
                            if (spaceRegex.hasMatch(val)) {
                              return LocaleKeys.invalidPhoneNumber.tr;
                            }
                            return null;
                          },
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                16.verticalSpace,
                Obx(
                  () => AppCheckBox(
                    title: LocaleKeys.rememberMe.tr,
                    value: controller.rememberMe.value,
                    size: 12.h,
                    style: AppTextStyle.lato(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.k72767C,
                    ),
                    onChanged: (bool? value) {
                      controller.rememberMe.value = value ?? false;
                    },
                  ),
                ),
                24.verticalSpace,
                AppButton(
                  buttonText: LocaleKeys.continueKey.tr,
                  style: AppTextStyle.lato(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.kFFFFFF,
                  ),
                  onPressed: controller.loading()
                      ? () {}
                      : controller.onContinue,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                20.verticalSpace,
                TextButton(
                  onPressed: controller.onFaqTap,
                  child: Text(
                    LocaleKeys.faq.tr,
                    style: AppTextStyle.lato(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.k46A0F1,
                    ),
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
