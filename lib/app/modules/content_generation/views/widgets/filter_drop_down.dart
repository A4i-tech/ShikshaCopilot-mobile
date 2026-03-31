import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A reusable dropdown widget for filtering.
///
/// This widget displays a dropdown button with a label, a hint text, and a
/// list of items. It also supports an optional clear button.
class FilterDropdown extends StatelessWidget {
  /// Creates a new [FilterDropdown].
  const FilterDropdown({
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.fillColor,
    super.key,
  });

  /// The label displayed above the dropdown.
  final String label;

  /// The currently selected value in the dropdown.
  final String? selectedValue;

  /// The list of items to display in the dropdown.
  final List<String> items;

  /// The hint text displayed when no value is selected.
  final String hintText;

  /// A callback function that is called when the selected value changes.
  final void Function(String?) onChanged;

  /// An optional callback function that is called when the clear button is tapped.
  final void Function()? onClear;

  /// The background color of the dropdown.
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final Widget clearIcon =
        onClear != null && selectedValue != null && selectedValue!.isNotEmpty
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.lato(
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            //   color: AppColors.k424955,
            color: AppColors.k5F6165,
          ),
        ),
        4.verticalSpace,
        DropdownButtonFormField<String>(
          value: items.contains(selectedValue)
              ? selectedValue
              : null, // << IMPORTANT
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? AppColors.kF6F8FA,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kEBEBEB),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kEBEBEB),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kEBEBEB),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kEBEBEB),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kEBEBEB),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kEBEBEB),
            ),
          ),
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              clearIcon,
              Icon(
                Icons.keyboard_arrow_down,
                size: 22.dg,
                color: AppColors.k171A1F,
              ),
            ],
          ),
          hint: Text(
            hintText,
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: AppColors.k6C7278,
            ),
          ),
          style: AppTextStyle.lato(
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.k171A1F,
          ),
          isExpanded: true,
          items: items
              .map(
                (String value) =>
                    DropdownMenuItem<String>(value: value, child: Text(value)),
              )
              .toList(),
          onChanged: items.isEmpty ? null : onChanged, // << IMPORTANT
        ),
      ],
    );
  }
}
