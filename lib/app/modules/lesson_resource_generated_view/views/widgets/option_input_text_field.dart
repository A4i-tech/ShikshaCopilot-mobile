import 'package:sikshana/app/utils/exports.dart';

/// A text field widget specifically designed for inputting options.
class OptionInputTextField extends StatefulWidget {
  /// Creates an [OptionInputTextField].
  const OptionInputTextField({
    required this.initialValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  /// The initial value of the text field.
  final String initialValue;
  /// A callback function that is called when the text field's value changes.
  final Function(String) onChanged;

  @override
  State<OptionInputTextField> createState() => _OptionInputTextFieldState();
}

class _OptionInputTextFieldState extends State<OptionInputTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
        ),
      ),
    );
}