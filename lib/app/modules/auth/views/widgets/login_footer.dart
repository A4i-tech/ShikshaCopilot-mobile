import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the footer content for the login screen.
///
/// This includes links to terms and conditions and a video guide for registration.
class LoginFooter extends StatelessWidget {
  /// Creates a [LoginFooter] widget.
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextButton(
        onPressed: () async {
          await LaunchUrl.launch('https://sikshana.org/policies/tnc.html');
        },
        child: Text(
          LocaleKeys.termsAndConditions.tr,
          style: AppTextStyle.lato(fontSize: 14.sp, color: AppColors.k46A0F1),
        ),
      ),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '${LocaleKeys.needHelpWithRegistration.tr} ',
              style: AppTextStyle.lato(
                fontSize: 14.sp,
                color: AppColors.k344767,
                decorationColor: AppColors.k344767,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: LocaleKeys.watchOurVideoGuide.tr,
              style: AppTextStyle.lato(
                fontSize: 14.sp,
                color: AppColors.k46A0F1,
                decorationColor: AppColors.k46A0F1,
                decoration: TextDecoration.underline,
                decorationThickness: 1.5,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  LaunchUrl.launch(
                    'https://youtu.be/qsGd7vCfceo?si=0b7q3BpQh5-a3Gcy',
                  );
                },
            ),
          ],
        ),
      ),
    ],
  );
}
