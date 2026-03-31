import 'package:sikshana/app/modules/auth/views/widgets/background_grid.dart';
import 'package:sikshana/app/utils/exports.dart';

/// The primary view for the authentication module.
///
/// This widget serves as the entry point for user authentication,
/// displaying the login form and related UI components.
class AuthView extends GetView<AuthController> {
  /// Creates an [AuthView] widget.
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: <Widget>[
        SizedBox(
          height: Get.height / 2.2,
          child: GridBackground(gridColor: AppColors.kFFFFFF.withOpacity(0.15)),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: <Widget>[58.verticalSpace, const LoginForm()],
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        20.verticalSpace,
        const LoginFooter(),
        40.verticalSpace,
      ],
    ),
  );
}
