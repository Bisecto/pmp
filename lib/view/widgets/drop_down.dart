import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final String selectedValue;
  final String label;
  final String hint;
  final double width;
  final double textSize;
  final double height;
  final String? initialValue;
  final List<String> items;
  final Color? color;
  final Color? labelColor;
  final Color? borderColor;
  final Color? dropIconColor;
  final bool showLabel;
  final bool showBorder;
  final double borderRadius;
  final Function(String)? onChanged; // Callback function


  DropDown({
    Key? key,
    required this.selectedValue,
    this.label = '',
    this.hint = '',
    this.width = double.infinity,
    this.height = 40,
    required this.items,
    this.initialValue,
    this.labelColor,
    this.showLabel = true,
    this.showBorder = true,
    this.borderColor,
    this.color,
    this.borderRadius = 4,
    this.dropIconColor,
    this.textSize = 16,
    this.onChanged,
  }) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
    _selectedValue = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.showLabel
            ? Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            widget.label,
            style: TextStyle(fontSize: widget.textSize, fontWeight: FontWeight.w400, color: widget.labelColor ?? widget.color ?? Colors.black87),
          ),
        )
            : const SizedBox.shrink(),
        widget.showLabel ? const SizedBox(height: 8) : const SizedBox.shrink(),
        Material(
          elevation: 0,
          type: MaterialType.card,
          color: const Color.fromARGB(31, 65, 61, 61),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          ),
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.only(left: 0),
            decoration: BoxDecoration(
              color: widget.color ?? const Color.fromARGB(150, 220, 220, 220),
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
              border: widget.showBorder ? Border.all(color: widget.borderColor ?? Colors.black12) : null,
            ),
            margin: const EdgeInsets.only(left: 0, right: 0),
            child: SizedBox(
              width: widget.width,
              child: DropdownButton<String>(
                iconEnabledColor: widget.dropIconColor ?? Colors.black54,
                icon: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.expand_more,
                    size: 22,
                  ),
                ),
                isExpanded: true,
                iconSize: 24,
                focusColor: Colors.black12,
                alignment: Alignment.bottomCenter,
                elevation: 3,
                underline: Container(color: Colors.transparent),
                value: _selectedValue == ' ' || !widget.items.contains(_selectedValue) ? null : _selectedValue,
                onChanged: (newValue) {
                  setState(() {
                    _selectedValue = newValue ?? '';
                    // Invoke the callback function with the new value
                    if (widget.onChanged != null) {
                      widget.onChanged!(_selectedValue);
                    }
                  });
                },
                hint: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.hint,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),

                items: widget.items.map((data) {
                  return DropdownMenuItem<String>(
                    value: data,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(data, style: TextStyle( fontSize: widget.textSize)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
