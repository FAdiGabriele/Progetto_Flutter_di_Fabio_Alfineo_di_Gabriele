import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class UsernameInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final String hint;

  const UsernameInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
  });

  @override
  State<UsernameInputField> createState() => _UsernameInputFieldState();
}

class _UsernameInputFieldState extends State<UsernameInputField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadow,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColor.darkGray),
        ),
        validator: widget.validator ??
                (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
      ),
    );
  }
}