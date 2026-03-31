import 'package:sikshana/app/utils/exports.dart';

/// A text field widget specifically designed for inputting questions.
class QuestionInputTextField extends StatefulWidget {
  /// Creates a [QuestionInputTextField].
  const QuestionInputTextField({
    required this.label,
    required this.name,
    required this.onChanged, // Now Function(String) instead of List<String>
    required this.hintText,
    required this.initialValue, // <-- Add this
    Key? key,
  }) : super(key: key);

  /// The label for the text field.
  final String label;
  /// The name associated with the text field.
  final String name;
  /// A callback function that is called when the text field's value changes.
  final Function(String) onChanged; // <-- Change callback type
  /// The hint text to display in the text field.
  final String hintText;
  /// The initial value of the text field.
  final String initialValue; // <-- Add this

  @override
  _QuestionInputTextFieldState createState() => _QuestionInputTextFieldState();
}

class _QuestionInputTextFieldState extends State<QuestionInputTextField> {
  late final TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.initialValue,
    ); // <-- Set initial value here
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
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
              minLines: 4,
              maxLines: 10,
              onChanged: (String text) =>
                  widget.onChanged(text), // <-- Pass String value here
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
        ],
      ),
    ],
  );
}