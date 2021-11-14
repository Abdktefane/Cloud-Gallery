import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/theme/colors.dart';

class GraduateTextField extends StatefulWidget {
  const GraduateTextField({
    Key? key,
    this.hintText,
    this.onChanged,
    this.isSuffixIcon,
    this.initialValue,
    this.context,
    this.hintColor,
    this.textEditingController,
    this.useObscure = false,
    this.onTab,
    this.keyboardType,
    this.focusNode,
    this.validator,
  }) : super(key: key);

  final String? hintText;
  final bool useObscure;
  final bool? isSuffixIcon;
  final BuildContext? context;
  final Color? hintColor;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? textEditingController;
  final String? initialValue;
  final Function? onTab;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  @override
  _GraduateTextFieldState createState() => _GraduateTextFieldState();
}

class _GraduateTextFieldState extends State<GraduateTextField> {
  bool showPassword = false;
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType ?? TextInputType.text,
      focusNode: widget.focusNode ?? _focusNode,
      onTap: widget.onTab as void Function()?,

      // ignore: avoid_bool_literals_in_conditional_expressions
      obscureText: widget.useObscure ? !showPassword : false,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: context.textTheme.bodyText1?.copyWith(
        fontSize: 16.0,
        color: TEXT_COLOR,
      ),
      initialValue: widget.initialValue,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        labelText: context.translate(widget.hintText!),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        labelStyle: context.textTheme.bodyText1!.copyWith(
          height: 0.5,
          color: widget.hintColor ?? Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: widget.isSuffixIcon == true
            ? IconButton(
                onPressed: () => setState(() => showPassword = !showPassword), //widget.onPressed,
                icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.black),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }
}
