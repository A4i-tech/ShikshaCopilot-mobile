import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/utils/exports.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    required this.label,
    required this.name,
    required this.items,
    required this.hintText,
    Key? key,
    this.enabled = true,
    this.onClear,
    this.fillColor,
    this.value,
    this.onChanged,
    this.validator,
  }) : super(key: key);
  final String label;
  final String name;
  final List<DropdownMenuItem<String>> items;
  final String hintText;
  final void Function()? onClear;
  final Color? fillColor;
  final bool enabled;
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final Widget clearIcon = onClear != null
        ? InkWell(
            onTap: onClear,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                CupertinoIcons.clear_circled_solid,
                size: 18.dg,
                color: AppColors.k9095A0,
              ),
            ),
          )
        : const SizedBox.shrink();

    final InputDecoration inputDecoration = InputDecoration(
      filled: true,
      fillColor: fillColor ?? Colors.white,
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: AppColors.k9095A0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: AppColors.k9095A0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: AppColors.k9095A0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: AppColors.k9095A0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: AppColors.k9095A0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: AppColors.k9095A0),
      ),
    );

    final Widget icon = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        clearIcon,
        Icon(
          CupertinoIcons.chevron_down,
          size: 16.dg,
          color: AppColors.k171A1F,
        ),
      ],
    );

    final TextStyle style = AppTextStyle.lato(
      fontWeight: FontWeight.w400,
      fontSize: 13.sp,
      color: AppColors.k171A1F,
    );

    final Widget hint = Text(
      hintText,
      style: AppTextStyle.lato(
        fontWeight: FontWeight.w400,
        fontSize: 13.sp,
        color: AppColors.k72767C,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyle.lato(
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            color: AppColors.k424955,
          ),
        ),
        4.verticalSpace,

        FormBuilderDropdown<String>(
          name: name,
          enabled: enabled,
          decoration: inputDecoration,
          icon: icon,
          style: style,
          hint: hint,
          items: items,
          initialValue: value,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (String? value) {
            onChanged?.call(value);
          },
        ),
      ],
    );
  }
}
