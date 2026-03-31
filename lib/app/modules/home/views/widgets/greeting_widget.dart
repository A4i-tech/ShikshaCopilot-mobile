import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a greeting to the user.
class GreetingWidget extends StatelessWidget {
  /// Creates a new instance of [GreetingWidget].
  ///
  /// Requires a [userName].
  const GreetingWidget({required this.userName, super.key});

  /// The name of the user to greet.
  final String userName;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 18.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${LocaleKeys.hi.tr}, $userName',
          style: AppTextStyle.lato(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        4.verticalSpace,
        Text(
          LocaleKeys.yourTeacherToolkitAtAGlance.tr,
          style: AppTextStyle.lato(fontSize: 14.sp, color: AppColors.k54577A),
        ),
      ],
    ),
  );
}
