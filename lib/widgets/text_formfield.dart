import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';

class BuildTextFormField extends StatefulWidget {
  const BuildTextFormField(
      {super.key,
      required this.controller,
      this.hint,
      this.textAlign,
      this.onChanged,
      this.validator,
      this.focusedBorder,
      this.border,
      this.textSize,
      this.obscureText = false,
      this.maxLines = 1,
      this.inputAction,
      this.inputFormatters,
      this.keyboardType,
      this.textCapitalization,
      this.maxLength,
      this.style,
      this.label,
      this.errorStyle,
      this.fillColor,
      this.onFieldSubmitted,
      this.prefix,
      this.padding,
      this.labelStyle,
      this.onTap,
      this.suffix,
      this.focusNode});
  final TextEditingController controller;
  final String? hint;
  final double? textSize;
  final TextAlign? textAlign;
  final Function(String value)? onChanged;
  final Function()? onTap;

  final Function(String value)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final EdgeInsets? padding;
  final InputBorder? focusedBorder;
  final InputBorder? border;
  final int? maxLines;
  final bool obscureText;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final FocusNode? focusNode;
  final String? label;
  final int? maxLength;
  final TextStyle? errorStyle;
  final Color? fillColor;
  final Widget? prefix;
  final Widget? suffix;

  @override
  State<BuildTextFormField> createState() => _BuildTextFormFieldState();
}

class _BuildTextFormFieldState extends State<BuildTextFormField> {
  bool obscureText = false;
  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      obscureText: obscureText,
      readOnly: widget.onTap != null,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      controller: widget.controller,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.inputAction,
      decoration: InputDecoration(
        errorMaxLines: 5,
        contentPadding: widget.padding ?? const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        hintText: widget.hint,
        fillColor: widget.fillColor ?? AppColors.baseColor,
        filled: true,
        hintStyle: TextStyle(fontSize: widget.textSize ?? 14, fontWeight: FontWeight.w400, color: Colors.grey),
        border: widget.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.baseColor),
              borderRadius: BorderRadius.circular(10),
            ),
        enabledBorder: widget.border,
        focusedBorder: widget.focusedBorder,
        labelText: widget.label,
        labelStyle: widget.labelStyle ?? TextStyle(fontSize: widget.textSize ?? 14, color: Colors.white),
        errorStyle: widget.errorStyle,
        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix ??
            (widget.obscureText
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        obscureText = !obscureText;
                        setState(() {});
                      },
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                        size: widget.textSize != null ? widget.textSize! + 10 : 20,
                      ),
                    ),
                  )
                : null),
      ),
      textAlign: widget.textAlign ?? TextAlign.start,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      cursorColor: Colors.black,
      validator: widget.validator,
      onTap: widget.onTap,
      maxLength: widget.maxLength,
      style: widget.style ?? TextStyle(fontSize: widget.textSize ?? 14, color: Colors.black),
    );
  }
}
