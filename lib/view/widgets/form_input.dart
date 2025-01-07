import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../res/app_colors.dart';
import 'app_custom_text.dart';
import 'app_spacer.dart';

class CustomTextFormField extends StatefulWidget {
  final bool isobscure;
  final bool isMobileNumber;
  final ValueChanged<String>? onChanged;
  final Function? onFieldSubmitted;
  final bool? readOnly;
  final String? Function(String?)? validateName;
  final String hint;
  final String label;
  final int? maxLines;
  final bool isPasswordField;
  final int? maxLength;
  final IconData? icon;
  final Color borderColor;
  final double borderRadius;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Color backgroundColor;
  final Color hintColor;

  const CustomTextFormField(
      {super.key,
        this.maxLength,
        this.maxLines = 1,
        this.readOnly = false,
        this.textInputType = TextInputType.text,
         this.icon,
        this.backgroundColor = AppColors.white,
        this.hintColor = AppColors.grey,
        this.borderColor = AppColors.grey,
        this.borderRadius = 10,
        this.isPasswordField = false,
        required this.controller,
        this.validateName,
        this.validator,
        this.isMobileNumber = false,
        this.isobscure = true,
        this.onChanged,
        this.onFieldSubmitted,
        required this.hint,
        required this.label});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle( fontSize: 15),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.borderColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: [
                if (widget.isMobileNumber)
                  const Text(
                    '+234',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: widget.readOnly!,
                    controller: widget.controller,
                    onTapOutside: (event){
                      FocusScope.of(context).requestFocus(FocusNode());

                    },
                    //focusNode:FocusNode().,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black, // Ensures text color is visible.
                    ),
                    onTap: () async {
                      if (widget.readOnly!) {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          widget.controller!.text = formattedDate;
                        }
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: widget.icon == null
                          ? null
                          : Icon(
                        widget.icon,
                        color: widget.borderColor,
                      ),
                      suffixIcon: widget.isPasswordField
                          ? GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: widget.borderColor,
                        ),
                      )
                          : null,
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: widget.hintColor.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: widget.textInputType,
                    validator: widget.validator,
                    maxLines: widget.maxLines,
                    maxLength: widget.maxLength,
                    obscureText: widget.isPasswordField ? _obscureText : false,
                    onFieldSubmitted: (val) {
                      if (widget.onFieldSubmitted != null) {
                        widget.onFieldSubmitted!();
                      }
                    },
                    onChanged: widget.onChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextFormPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validateName;
  final String label;
  final TextEditingController controller;

  const CustomTextFormPasswordField(
      {super.key,
        required this.controller,
        this.validateName,
        this.onChanged,
        required this.label});

  @override
  State<CustomTextFormPasswordField> createState() =>
      _CustomTextFormPasswordFieldState();
}

class _CustomTextFormPasswordFieldState
    extends State<CustomTextFormPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
      ),
      keyboardType: TextInputType.text,
      validator: widget.validateName,
      onChanged: (String val) {
        //_name = val;
      },
    );
  }
}


class FormSelectInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType inputType;
  final int maxLines;
  final double width;
  final double height;
  final bool isEnabled;

  const FormSelectInput(
      {Key? key,
        required this.controller,
        this.label = '',
        this.hint = '',
        this.width = 200,
        this.height = 35,
        this.inputType = TextInputType.text,
        this.maxLines = 1,
        this.isEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ),
        const AppSpacer(
          height: 8,
        ),
        Material(
          elevation: 0,
          color: Colors.black12,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: TextField(
                controller: controller,
                keyboardType: inputType,
                maxLines: maxLines,
                enabled: isEnabled,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    hintText: hint,
                    hintStyle:
                    TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                onChanged: (text) {}),
          ),
        ),
      ],
    );
  }
}

class SelectFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final double height;
  final double width;

  final TextInputType inputType;
  final int maxLines;

  const SelectFormInput(
      {Key? key,
        required this.controller,
        this.label = '',
        this.hint = '',
        this.inputType = TextInputType.text,
        this.maxLines = 1,
        this.height = 35,
        this.width = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.only(left: 10, bottom: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: TextField(
          controller: controller,
          keyboardType: inputType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              fontSize: 12,
            ),
            enabled: false,
            border: InputBorder.none,
            hintText: hint,
            contentPadding: EdgeInsets.zero,
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          onChanged: (text) {}),
    );
  }
}

class SelectBorderFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final double width;
  final TextInputType inputType;
  final int maxLines;

  const SelectBorderFormInput(
      {Key? key,
        required this.controller,
        this.label = '',
        this.hint = '',
        this.width = 120,
        this.inputType = TextInputType.text,
        this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4, left: 4),
      width: width,
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.3),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: TextField(
          controller: controller,
          keyboardType: inputType,
          maxLines: maxLines,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w200),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 6, top: 4),
            enabled: false,
            border: InputBorder.none,
            hintText: hint,
            suffixIcon: const Icon(
              Icons.arrow_drop_down_outlined,
              color: Colors.white,
            ),
          ),
          onChanged: (text) {}),
    );
  }
}




@immutable
class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType inputType;
  final int maxLines;
  final double width;
  final double height;
  final bool isEnabled;
  final Function(String)? validate;

  const PasswordInput({
    Key? key,
    required this.controller,
    this.label = '',
    this.hint = '',
    this.width = 200,
    this.height = 42,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.isEnabled = true,
    this.validate,
  }) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Text(
          widget.label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ),
      const AppSpacer(
        height: 8,
      ),
      Material(
        elevation: 0,
        color: Colors.black12,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: const EdgeInsets.only(right: 0, left: 0, bottom: 3),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.green, width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.inputType,
              maxLines: widget.maxLines,
              enabled: widget.isEnabled,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.black,
                  size: 22,
                ),
                suffixIcon: InkWell(
                  onTap: _toggleIcon,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18.0,
                      color: Colors.black26,
                    ),
                  ),
                ),
              ),
              onChanged: (text) {
                // if (widget.validate != null) {
                //   widget.error!.value = widget.validate!(text);
                // }
              },
            ),
          ),
        ),
      ),
      // widget.error == null
      //     ? const AppSpacer.shrink()
      //     : Obx(() => widget.error?.value == ''
      //     ? const AppSpacer.shrink()
      //     : Text(
      //   widget.error?.value ?? '',
      //   style: const TextStyle(color: Pallet.red),
      // )),
    ]);
  }

  void _toggleIcon() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
