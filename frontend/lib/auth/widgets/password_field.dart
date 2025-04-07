import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.validator,
    required this.labelText,
    required this.hintText,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;
  final String labelText;
  final String hintText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final bool password = true;

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          style: IconButton.styleFrom(padding: EdgeInsets.all(0)),
          onPressed:
              () => setState(() {
                obscure = !obscure;
              }),
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.remove_red_eye_outlined,
          ),
        ),

        hintText: widget.hintText,
      ),
      obscureText: obscure,
      validator: widget.validator,
    );
  }
}
