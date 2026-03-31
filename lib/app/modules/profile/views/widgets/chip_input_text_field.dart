import 'package:sikshana/app/utils/exports.dart';

/// A text field that allows users to input and display a list of chips.
class ChipInputTextField extends StatefulWidget {
  /// Constructs a [ChipInputTextField].
  const ChipInputTextField({
    required this.label,
    required this.name,
    required this.onChanged,
    required this.hintText,
    Key? key,
    this.initialValue = const <String>[],
  }) : super(key: key);

  /// The label for the text field.
  final String label;

  /// The name of the form field.
  final String name;

  /// The initial list of chips.
  final List<String> initialValue;

  /// A callback function that is called when the list of chips changes.
  final Function(List<String>) onChanged;

  /// The hint text to display in the text field.
  final String hintText;

  @override
  _ChipInputTextFieldState createState() => _ChipInputTextFieldState();
}

class _ChipInputTextFieldState extends State<ChipInputTextField> {
  late final TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  List<String> _chips = <String>[];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _chips = List<String>.from(widget.initialValue);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addChip(FormFieldState<List<String>> field) {
    final String text = _textController.text.trim();
    if (text.isNotEmpty && !_chips.contains(text)) {
      setState(() {
        _chips.add(text);
        _textController.clear();
      });
      widget.onChanged(_chips);
      field.didChange(_chips); // ✅ keep form value in sync
    }
    _focusNode.requestFocus();
  }

  void _removeChip(String chip, FormFieldState<List<String>> field) {
    setState(() {
      _chips.remove(chip);
    });
    widget.onChanged(_chips);
    field.didChange(_chips); // ✅ keep form value in sync
  }

  @override
  Widget build(BuildContext context) => FormBuilderField<List<String>>(
    name: widget.name,
    initialValue: widget.initialValue,
    builder: (FormFieldState<List<String>> field) {
      // ✅ Sync _chips with field.value (for patchValue support)
      _chips = List<String>.from(field.value ?? <dynamic>[]);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.label,
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              color: AppColors.k424955,
            ),
          ),
          4.verticalSpace,
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: _textController,
                  onFieldSubmitted: (_) => _addChip(field),
                  onTap: () {
                    _focusNode.unfocus();
                  },
                  onTapOutside: (PointerDownEvent event) {
                    _focusNode.unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTextStyle.lato(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: AppColors.k72767C,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.r),
                      borderSide: const BorderSide(color: AppColors.k9095A0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.r),
                      borderSide: const BorderSide(color: AppColors.k9095A0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.r),
                      borderSide: const BorderSide(color: AppColors.k9095A0),
                    ),
                  ),
                ),
              ),
              8.horizontalSpace,
              SizedBox(
                height: 50.h,
                width: 50.w,
                child: AppButton(
                  onPressed: () => _addChip(field),
                  buttonColor: AppColors.k46A0F1,
                  borderRadius: BorderRadius.circular(8.r),
                  buttonText: '+',
                ),
              ),
            ],
          ),
          if (_chips.isNotEmpty) ...<Widget>[
            8.verticalSpace,
            Wrap(
              spacing: 6,
              runSpacing: -6,
              children: _chips
                  .map(
                    (String chip) => Chip(
                      label: Text(
                        chip,
                        style: AppTextStyle.lato(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color: AppColors.k171A1F,
                        ),
                      ),
                      onDeleted: () => _removeChip(chip, field),
                      deleteIconColor: AppColors.k72767C,
                      backgroundColor: AppColors.kF3F4F6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20.r),
                        side: const BorderSide(color: AppColors.kFFFFFF),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      );
    },
  );
}
