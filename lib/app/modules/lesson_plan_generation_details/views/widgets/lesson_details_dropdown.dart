import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A dropdown widget for lesson details.
class LessonDetailsDropdown extends StatelessWidget {
  /// Creates a [LessonDetailsDropdown] widget.
  const LessonDetailsDropdown({
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.hintText,
    required this.onChanged,
    Key? key,
    this.onClear,
    this.fillColor,
  }) : super(key: key);
  /// The label for the dropdown.
  final String label;
  /// The currently selected value.
  final String? selectedValue;
  /// The items to display in the dropdown.
  final List<String> items;
  /// The hint text to display when no value is selected.
  final String hintText;
  /// A callback function that is called when the selected value changes.
  final void Function(String?) onChanged;
  /// A callback function that is called when the clear button is tapped.
  final void Function()? onClear;
  /// The color to fill the dropdown button with.
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
        RichText(
          text: TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: label,
                style: AppTextStyle.lato(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: AppColors.k424955,
                ),
              ),
              TextSpan(
                text: ' *',
                style: AppTextStyle.lato(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: AppColors.kD02020, // Red color for the asterisk
                ),
              ),
            ],
          ),
        ),

        4.verticalSpace,
        DropdownButtonFormField<String>(
          initialValue: selectedValue?.isEmpty ?? true ? null : selectedValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.kF3F4F6,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kFFFFFF),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kFFFFFF),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kFFFFFF),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kFFFFFF),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kFFFFFF),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.kFFFFFF),
            ),
          ),
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              clearIcon,
              Icon(
                Icons.keyboard_arrow_down,
                size: 25.dg,
                color: AppColors.k171A1F,
              ),
            ],
          ),
          hint: Text(
            hintText,
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: AppColors.k565E6C,
            ),
          ),
          style: AppTextStyle.lato(
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.k565E6C,
          ),
          isExpanded: true,
          items: items
              .map(
                (String value) =>
                    DropdownMenuItem<String>(value: value, child: Text(value)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
