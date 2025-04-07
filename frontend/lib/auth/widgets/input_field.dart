import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.validator,
    required this.type,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(hintText: hintText),
      validator: validator,
    );
  }
}
