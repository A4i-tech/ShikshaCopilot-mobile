import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A multi-select dropdown widget for profile forms.
class ProfileMultiSelectDropdown extends StatefulWidget {
  /// Constructs a [ProfileMultiSelectDropdown].
  const ProfileMultiSelectDropdown({
    required this.label,
    required this.name,
    required this.items,
    required this.hintText,
    Key? key,
    this.onChanged,
    this.enabled = true,
    this.validator,
    this.isMultiSelection = false,
    this.labelStyle,
  }) : super(key: key);

  /// The label for the dropdown.
  final String label;

  /// The name of the form field.
  final String name;

  /// The list of items to display in the dropdown.
  final List<String> items;

  /// The hint text to display when no value is selected.
  final String hintText;

  /// A callback function that is called when the selected value changes.
  final void Function(List<String>?)? onChanged;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// A validator function for the dropdown field.
  final String? Function(List<String>?)? validator;

  /// Whether to allow multiple selections.
  final bool isMultiSelection;

  /// The style for the label text.
  final TextStyle? labelStyle;

  @override
  State<ProfileMultiSelectDropdown> createState() =>
      _ProfileMultiSelectDropdownState();
}

class _ProfileMultiSelectDropdownState
    extends State<ProfileMultiSelectDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  OverlayEntry? _barrierEntry;
  List<String>? _lastEmittedValue;
  final GlobalKey _dropdownFieldKey = GlobalKey();

  void _openDropdown(BuildContext context, FormFieldState<List<String>> field) {
    _overlayEntry = _createOverlay(context, field);
    _barrierEntry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeDropdown,
        ),
      ),
    );
    Overlay.of(
      context,
    ).insertAll(<OverlayEntry>[_barrierEntry!, _overlayEntry!]);
  }

  OverlayEntry _createOverlay(
    BuildContext context,
    FormFieldState<List<String>> field,
  ) {
    final RenderBox renderBox =
        _dropdownFieldKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    // Calculate actual content height
    const double itemHeight =
        48; // Approximate height per item (padding + text)
    final int itemCount = widget.items.isEmpty
        ? 1 // For "No items found" message
        : widget.items.length +
              (widget.isMultiSelection ? 1 : 0); // +1 for Select/Deselect All
    final double actualContentHeight = itemCount * itemHeight;
    final double dropdownMaxHeight = 250.h;

    // Use the smaller of content height or max height
    final double dropdownHeight = actualContentHeight < dropdownMaxHeight
        ? actualContentHeight
        : dropdownMaxHeight;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double spaceBelow = screenHeight - offset.dy - size.height;
    final bool showAbove = (spaceBelow - 20) < dropdownHeight;

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx,
        width: size.width,
        top: showAbove
            ? offset.dy -
                  dropdownHeight -
                  2 // Small gap above
            : offset.dy + size.height + 2, // Small gap below
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(6),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: dropdownMaxHeight),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  if (widget.isMultiSelection && widget.items.isNotEmpty)
                    InkWell(
                      onTap: () {
                        setState(() {
                          final bool allSelected =
                              field.value?.length == widget.items.length;
                          field.didChange(
                            allSelected
                                ? <String>[]
                                : List<String>.from(widget.items),
                          );
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.kDEE1E6),
                          ),
                        ),
                        child: Text(
                          (field.value?.length == widget.items.length)
                              ? 'Deselect All'
                              : 'Select All',
                          style: AppTextStyle.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                            color: AppColors.k171A1F,
                          ),
                        ),
                      ),
                    ),
                  // If items are empty, show a "No items found" message
                  if (widget.items.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Text(
                        'No items found',
                        style: AppTextStyle.lato(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color: AppColors.k72767C,
                        ),
                      ),
                    )
                  else
                    ...widget.items.map((String item) {
                      final bool isSelected = (field.value ?? <String>[])
                          .contains(item);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (widget.isMultiSelection) {
                              final List<String> next = List<String>.from(
                                field.value ?? <dynamic>[],
                              );
                              isSelected ? next.remove(item) : next.add(item);
                              field.didChange(next);
                            } else {
                              field.didChange(<String>[item]);
                              _closeDropdown();
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: const Border(
                              bottom: BorderSide(color: AppColors.kDEE1E6),
                            ),
                            color: isSelected
                                ? Colors.grey.shade200
                                : Colors.transparent,
                          ),
                          child: Text(
                            item,
                            style: AppTextStyle.lato(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: AppColors.k171A1F,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _barrierEntry?.remove();
    _barrierEntry = null;
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      FormBuilderField<List<String>>(
        name: widget.name,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: widget.enabled,
        onChanged: (List<String>? val) {
          if (!listEquals(val, _lastEmittedValue)) {
            _lastEmittedValue = val == null ? null : List<String>.from(val);
            widget.onChanged?.call(val);
          }
        },
        builder: (FormFieldState<List<String>> field) {
          final List<String> selected = List<String>.from(
            field.value ?? const <String>[],
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.label,
                style:
                    widget.labelStyle ??
                    AppTextStyle.lato(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: AppColors.k171A1F,
                    ),
              ),
              const SizedBox(height: 6),
              CompositedTransformTarget(
                key: _dropdownFieldKey,
                link: _layerLink,
                child: GestureDetector(
                  onTap: widget.enabled
                      ? () {
                          if (_overlayEntry == null) {
                            FocusScope.of(context).unfocus();
                            _openDropdown(context, field);
                          } else {
                            _closeDropdown();
                          }
                        }
                      : null,
                  child: InputDecorator(
                    isEmpty: selected.isEmpty,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppTextStyle.lato(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: AppColors.k72767C,
                      ),
                      suffixIcon: Icon(
                        CupertinoIcons.chevron_down,
                        size: 16.dg,
                        color: AppColors.k171A1F,
                      ),
                      errorText: field.errorText,
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
                    ),
                    child: widget.isMultiSelection
                        ? const Text('')
                        : selected.isEmpty
                        ? null
                        : Text(
                            selected.first,
                            style: AppTextStyle.lato(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: AppColors.k171A1F,
                            ),
                          ),
                  ),
                ),
              ),
              if (widget.isMultiSelection && selected.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6, // Changed from -6 to 6
                  children: selected
                      .map(
                        (String val) => Chip(
                          label: Text(
                            val,
                            style: AppTextStyle.lato(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: AppColors.k171A1F,
                            ),
                          ),
                          deleteIconColor: AppColors.k72767C,
                          backgroundColor: AppColors.kF3F4F6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: const BorderSide(color: AppColors.kFFFFFF),
                          ),
                          onDeleted: () {
                            final List<String> next = List<String>.from(
                              selected,
                            )..remove(val);
                            field.didChange(next);
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          );
        },
      ),
    ],
  );
}
