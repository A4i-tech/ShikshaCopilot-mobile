import 'package:sikshana/app/utils/exports.dart';

///Custom button
class AppButton extends StatelessWidget {
  /// Custom button constructor
  const AppButton({
    required this.buttonText,
    required this.onPressed,
    this.borderSide,
    this.height,
    this.style,
    this.buttonColor,
    this.borderRadius,
    this.loader = false,
    this.buttonTextColor,
    this.loaderColor,
    this.icon,
    this.rightIcon = true,
    this.iconSpacing = 6,
    Key? key,
  }) : super(key: key);

  /// Button text
  final String buttonText;

  /// On pressed
  final void Function() onPressed;

  /// Border side
  final BorderSide? borderSide;

  /// Height
  final double? height;

  /// Style
  final TextStyle? style;

  /// Button color
  final Color? buttonColor;

  /// Border radius
  final BorderRadius? borderRadius;

  ///bool show loader
  final bool loader;

  /// button text color
  final Color? buttonTextColor;

  /// loader color
  final Color? loaderColor;

  /// Child widget
  final Widget? icon;

  ///icon right side
  final bool rightIcon;

  ///icon horizontal spacing
  final double iconSpacing;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      maximumSize: Size(context.width, height ?? 50.h),
      minimumSize: Size(20.w, 20.h),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(10).r,
        side: borderSide ?? BorderSide.none,
      ),
      shadowColor: AppColors.kFFFFFF,
      side: borderSide,
      padding: EdgeInsets.zero,
      foregroundColor: buttonColor ?? AppColors.k46A0F1,
      backgroundColor: buttonColor ?? AppColors.k46A0F1,
    ),
    child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (loader) ...<Widget>[
            Lottie.asset(
              AppImages.loader,
              height: 50.h,
              width: 50.w,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
              delegates: loaderColor != null
                  ? LottieDelegates(
                      values: <ValueDelegate<dynamic>>[
                        ValueDelegate.color(
                          const <String>['**'], // Select all elements
                          value: loaderColor, // your desired color
                        ),
                      ],
                    )
                  : null,
            ),
            8.verticalSpace,
          ],
          if (icon != null && !rightIcon) ...<Widget>[
            icon!,
            iconSpacing.horizontalSpace,
          ],
          Flexible(
            child: Text(
              buttonText,
              style:
                  style ??
                  AppTextStyle.lato(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: buttonTextColor ?? AppColors.kFFFFFF,
                  ),
            ),
          ),
          if (icon != null && rightIcon) ...<Widget>[
            iconSpacing.horizontalSpace,
            icon!,
          ],
        ],
      ),
    ),
  );
}
