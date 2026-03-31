import 'package:sikshana/app/utils/exports.dart';

/// App check box
class AppCheckBox extends StatelessWidget {
  /// App check box constructor
  const AppCheckBox({
    required this.value,
    required this.onChanged,
    super.key,
    this.activeColor = AppColors.k0070F2,
    this.title,
    this.checkColor = Colors.white,
    this.size,
    this.style,
  });

  /// Value
  final bool value;

  /// On changed
  final ValueChanged<bool> onChanged;

  /// Active color
  final Color activeColor;

  /// Check color
  final Color checkColor;

  /// Title
  final String? title;

  /// Size
  final double? size;

  ///title style
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      onChanged.call(!value);
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: value ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(2).r,
            border: Border.all(
              color: value
                  ? activeColor
                  : AppColors.k9095A061.withValues(alpha: 0.38),
              width: 1.5.w,
            ),
          ),
          width: size ?? 16.w,
          height: size ?? 16.h,
          child: value
              ? Icon(
                  size: size == null ? 12.h : (size! - 2),
                  Icons.check_rounded,
                  color: checkColor,
                )
              : null,
        ),
        if (title != null && title!.isNotEmpty) ...<Widget>[
          8.horizontalSpace,
          Expanded(
            child: Text(
              title ?? '',
              style:
                  style ??
                  AppTextStyle.lato(
                    color: AppColors.k344767,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        ],
      ],
    ),
  );
}
