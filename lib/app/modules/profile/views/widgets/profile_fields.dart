import 'package:sikshana/app/utils/exports.dart';

/// A custom text field widget for the profile screen.
class ProfileTextField extends StatelessWidget {
  /// Constructs a [ProfileTextField].
  const ProfileTextField({
    required this.name,
    this.label,
    Key? key,
    this.enabled = true,
    this.validator,
    this.keyboardType,
    this.hintWidget,
    this.suffixIcon,
    this.borderColor,
    this.onChanged,
    this.color,
  }) : super(key: key);

  /// The label for the text field.
  final String? label;

  /// The name of the form field.
  final String name;

  /// A validator function for the text field.
  final String? Function(String?)? validator;

  /// The keyboard type for the text field.
  final TextInputType? keyboardType;

  /// Whether the text field is enabled.
  final bool enabled;

  /// A widget to display as a hint.
  final Widget? hintWidget;

  /// An icon to display at the end of the text field.
  final Widget? suffixIcon;

  /// The color of the border.
  final Color? borderColor;

  /// A callback function that is called when the text field's value changes.
  final void Function(String?)? onChanged;

  /// The background color of the text field.
  final Color? color;

  @override
  /// Builds the UI for the profile text field.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the text field with a label.
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (label != null) ...<Widget>[
        Text(
          label!,
          style: AppTextStyle.lato(
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            color: AppColors.k424955,
          ),
        ),
        4.verticalSpace,
      ],
      FormBuilderTextField(
        name: name,
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.number
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
        enabled: enabled,
        onChanged: onChanged,
        onTapOutside: (PointerDownEvent event) {
          final FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          hint: hintWidget,
          suffixIcon: suffixIcon,
          fillColor: enabled ? color ?? Colors.white : AppColors.kF3F4F6,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(color: borderColor ?? AppColors.k9095A0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(color: borderColor ?? AppColors.k9095A0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(color: borderColor ?? AppColors.k9095A0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(color: borderColor ?? AppColors.k9095A0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(color: borderColor ?? AppColors.k9095A0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
        style: AppTextStyle.lato(
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          color: AppColors.k171A1F,
        ),
      ),
    ],
  );
}
