import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A dropdown widget for selecting a language.
class LanguageDropdown extends StatelessWidget {
  /// Constructs a [LanguageDropdown].
  const LanguageDropdown({
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

  /// The name of the form field.
  final String name;

  /// The list of dropdown menu items.
  final List<DropdownMenuItem<String>> items;

  /// The hint text to display when no value is selected.
  final String hintText;

  /// A callback function to be called when the clear icon is tapped.
  final void Function()? onClear;

  /// The color to fill the dropdown background.
  final Color? fillColor;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// The currently selected value.
  final String? value;

  /// A callback function that is called when the selected value changes.
  final void Function(String?)? onChanged;

  /// A validator function for the dropdown field.
  final String? Function(String?)? validator;

  @override
  /// Builds the UI for the language dropdown widget.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the language dropdown.
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
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
    final Widget icon = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        clearIcon,
        Icon(
          CupertinoIcons.chevron_down,
          size: 16.dg,
          color: AppColors.k000000,
        ),
      ],
    );

    final TextStyle style = AppTextStyle.lato(
      fontWeight: FontWeight.w700,
      fontSize: 14.sp,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.kEBEBEB),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          10.horizontalSpace,
          Icon(Icons.language, color: AppColors.k46A0F1, size: 24.dg),
          10.horizontalSpace,
          Text(
            '${LocaleKeys.application.tr} ${LocaleKeys.language.tr}',
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 110.w,
            child: FormBuilderDropdown<String>(
              name: name,
              enabled: enabled,
              decoration: inputDecoration,
              icon: icon,
              style: style,
              items: items,
              initialValue: value,
              validator: validator,
              menuWidth: 110,
              alignment: AlignmentGeometry.centerRight,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (String? value) {
                onChanged?.call(value);
              },
            ),
          ),
          6.horizontalSpace,
        ],
      ),
    );
  }
}
