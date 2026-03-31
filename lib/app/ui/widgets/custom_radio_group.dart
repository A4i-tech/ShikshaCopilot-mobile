import 'package:sikshana/app/utils/exports.dart';

/// A simple reusable RadioGroup widget for String values (Flutter 3.32+)
class CustomRadioGroup extends StatelessWidget {
  const CustomRadioGroup({
    required this.options, required this.selectedValue, required this.onChanged, super.key,
    this.spacing = 8.0,
    this.borderColor,
    this.optionTitles,
    this.isVertical = false,
    this.enabled = true,
    this.textStyle,
  });
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onChanged;
  final double spacing;
  final Color? borderColor;
  final List<String>? optionTitles;
  final bool isVertical;
  final bool enabled;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => AbsorbPointer(
    absorbing: !enabled,
    child: RadioGroup<String>(
      groupValue: selectedValue,
      onChanged: (String? value) {
        if (value != null) {
          onChanged(value);
        }
      },
      child: isVertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < options.length; i++) ...<Widget>[
                  _CustomRadioTile(
                    value: options[i],
                    isSelected: selectedValue == options[i],
                    borderColor: borderColor,
                    optionTitle:
                        optionTitles != null && optionTitles!.length > i
                        ? optionTitles![i]
                        : null,
                    enabled: enabled,
                    textStyle: textStyle,
                  ),
                  SizedBox(height: spacing),
                ],
              ],
            )
          : Wrap(
              children: <Widget>[
                for (int i = 0; i < options.length; i++) ...<Widget>[
                  _CustomRadioTile(
                    value: options[i],
                    isSelected: selectedValue == options[i],
                    borderColor: borderColor,
                    optionTitle:
                        optionTitles != null && optionTitles!.length > i
                        ? optionTitles![i]
                        : null,
                    enabled: enabled,
                    textStyle: textStyle,
                  ),
                  SizedBox(height: spacing),
                ],
              ],
            ),
    ),
  );
}

/// Internal single radio tile for a String option
class _CustomRadioTile extends StatelessWidget {
  const _CustomRadioTile({
    required this.value,
    required this.isSelected,
    required this.enabled,
    this.borderColor,
    this.optionTitle,
    this.textStyle,
  });
  final String value;
  final bool isSelected;
  final Color? borderColor;
  final String? optionTitle;
  final TextStyle? textStyle;
  final bool enabled;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () => RadioGroup.maybeOf<String>(context)?.onChanged.call(value),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Radio<String>(
          value: value,
          innerRadius: const WidgetStateProperty.fromMap(
            <WidgetStatesConstraint, double?>{WidgetState.any: 4.5},
          ),
          activeColor: AppColors.k46A0F1,
          focusColor: AppColors.k565E6C,
          hoverColor: AppColors.k565E6C,
          enabled: enabled,
          fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.k565E6C;
            }
            if (states.contains(WidgetState.selected)) {
              return AppColors.k46A0F1;
            }
            return AppColors.k565E6C;
          }),
          visualDensity: VisualDensity.compact,
        ),
        Flexible(
          child: Text(
            optionTitle ?? value,
            style: textStyle ?? AppTextStyle.lato(),
          ),
        ),
      ],
    ),
  );
}
