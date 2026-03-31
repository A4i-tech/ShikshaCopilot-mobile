import 'package:sikshana/app/ui/components/app_back_button.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Leading type
enum Leading {
  /// Back button
  back,

  /// App Deawer
  drawer,
}

/// App bar
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar Constructor
  const CommonAppBar({
    required this.scaffoldKey,
    this.title,
    this.onBackPress,
    this.backgroundColor,
    this.backIconColor,
    this.titleColor,
    this.drawerColor,
    this.leading = Leading.back,
    this.trailingWidget,
    super.key,
  });

  /// App bar title
  final String? title;

  /// Scaffold key
  final GlobalKey<ScaffoldState> scaffoldKey;

  ///on Back press
  final void Function()? onBackPress;

  /// Background color
  final Color? backgroundColor;

  /// Back icon color
  final Color? backIconColor;

  /// Customer name color
  final Color? titleColor;

  /// Drawer color
  final Color? drawerColor;

  /// Leading type
  final Leading leading;

  /// trailing Widget
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) => Material(
    color: backgroundColor ?? AppColors.kFFFFFF,
    elevation: 4,
    shadowColor: AppColors.k000000.withValues(alpha: 0.25),
    child: SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 24.w),
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: <Widget>[
              leading == Leading.back
                  ? AppBackButton(onBack: onBackPress)
                  : AppDrawerButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        scaffoldKey.currentState?.openDrawer();
                      },
                      color: drawerColor ?? AppColors.k303030,
                    ),
              6.horizontalSpace,
              if (title != null)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: Get.width - 100.w),
                  child: Text(
                    title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.lato(
                      color: titleColor ?? AppColors.k141522,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (trailingWidget != null) ...<Widget>[
                const Spacer(),
                trailingWidget!,
              ],
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}
