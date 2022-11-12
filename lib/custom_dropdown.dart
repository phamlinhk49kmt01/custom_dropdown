library animated_custom_dropdown;

export 'custom_dropdown.dart';

import 'package:flutter/material.dart';

part 'animated_section.dart';
part 'dropdown_field.dart';
part 'dropdown_overlay.dart';
part 'overlay_builder.dart';

typedef ItemAsString<T> = String Function(T item);
typedef ValueChanged<T> = void Function(T value);

enum _SearchType { onListData }

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;

  ///selected item
  final T? selectedItem;

  ///selected items
  final List<T> selectedItems;
  final ItemAsString<T> itemAsString;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final TextStyle? listItemStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? fieldSuffixIcon;
  final ValueChanged<T>? onChanged;
  final bool? excludeSelected;
  final Color? fillColor;
  final bool? canCloseOutsideBounds;
  final _SearchType? searchType;

  CustomDropdown({
    Key? key,
    this.items = const [],
    this.selectedItems = const [],
    this.selectedItem,
    required this.itemAsString,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.fillColor = Colors.white,
  })  : assert(items.isNotEmpty, 'Items list must contain at least one item.'),
        searchType = null,
        canCloseOutsideBounds = true,
        super(key: key);

  CustomDropdown.search({
    Key? key,
    this.items = const [],
    this.selectedItems = const [],
    this.selectedItem,
    required this.itemAsString,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.fillColor = Colors.white,
  })  : assert(items.isNotEmpty, 'Items list must contain at least one item.'),
        searchType = _SearchType.onListData,
        super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final layerLink = LayerLink();
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty){
      controller.text = widget.itemAsString(widget.items[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// hint text
    final hintText = widget.hintText ?? 'Select value';

    // hint style :: if provided then merge with default
    final hintStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFFA7A7A7),
      fontWeight: FontWeight.w400,
    ).merge(widget.hintStyle);

    // selected item style :: if provided then merge with default
    final selectedStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ).merge(widget.selectedStyle);

    onChange(String text) {
      var d = widget.items.firstWhere((item) => widget.itemAsString(item) == text);
      if (widget.onChanged != null) {
        widget.onChanged!(d);
      }
    }

    return _OverlayBuilder<T>(
      overlay: (size, hideCallback) {
        return _DropdownOverlay<T>(
          items: widget.items,
          controller: controller,
          size: size,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerStyle: hintStyle,
          hintText: hintText,
          listItemStyle: widget.listItemStyle,
          excludeSelected: widget.excludeSelected,
          canCloseOutsideBounds: widget.canCloseOutsideBounds,
          searchType: widget.searchType,
          itemAsString: widget.itemAsString,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField(
            controller: controller,
            onTap: showCallback,
            style: selectedStyle,
            borderRadius: widget.borderRadius,
            borderSide: widget.borderSide,
            errorBorderSide: widget.errorBorderSide,
            errorStyle: widget.errorStyle,
            errorText: widget.errorText,
            hintStyle: hintStyle,
            hintText: hintText,
            suffixIcon: widget.fieldSuffixIcon,
            onChanged: onChange,
            fillColor: widget.fillColor,
            itemAsString: widget.itemAsString,
          ),
        );
      },
    );
  }
}
