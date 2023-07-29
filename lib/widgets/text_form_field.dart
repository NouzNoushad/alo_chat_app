import 'package:flutter/material.dart';

import '../core/colors.dart';

class ChatTextFormField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final IconData? suffixIcon;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final void Function()? onSuffixIconTap;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextInputType? keyboardType;
  const ChatTextFormField(
      {super.key,
      this.hintText,
      this.icon,
      this.suffixIcon,
      this.onSuffixIconTap,
      this.focusNode,
      this.controller,
      this.validator,
      this.onSaved,
      this.onTapOutside,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder kOutlineInputBorder(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: color,
          ),
        );
    return TextFormField(
      style: const TextStyle(
        color: CustomColors.backgroundColor1,
      ),
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      focusNode: focusNode,
      onTapOutside: onTapOutside,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: CustomColors.backgroundColor1,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          size: 18,
          color: CustomColors.backgroundColor1,
        ),
        suffixIcon: InkWell(
          onTap: onSuffixIconTap,
          child: Icon(
            suffixIcon,
            size: 22,
            color: CustomColors.backgroundColor1,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: CustomColors.backgroundColor1,
        ),
        fillColor: CustomColors.backgroundColor2,
        filled: true,
        errorStyle: const TextStyle(
          color: CustomColors.backgroundColor1,
        ),
        enabledBorder: kOutlineInputBorder(CustomColors.backgroundColor),
        focusedBorder: kOutlineInputBorder(CustomColors.backgroundColor),
        errorBorder: kOutlineInputBorder(CustomColors.backgroundColor1),
        focusedErrorBorder: kOutlineInputBorder(CustomColors.backgroundColor1),
      ),
    );
  }
}
