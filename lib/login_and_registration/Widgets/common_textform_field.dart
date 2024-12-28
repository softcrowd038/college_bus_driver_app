import 'package:flutter/material.dart';

class CommonTextFormfield extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscure;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  const CommonTextFormfield(
      {super.key,
      required this.label,
      required this.hint,
      required this.obscure,
      required this.controller,
      required this.validator,
      required this.onChanged,
      required this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      autocorrect: true,
      obscureText: obscure,
      controller: controller,
      validator: validator,
      style: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.height * 0.016),
      decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 255, 255),
              width: 1,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 126, 126, 126),
              width: 1,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: MediaQuery.of(context).size.height * 0.016),
          hintText: hint,
          hintStyle: TextStyle(
              color: const Color.fromARGB(255, 129, 129, 129),
              fontSize: MediaQuery.of(context).size.height * 0.015),
          suffixIcon: suffixIcon),
    );
  }
}
