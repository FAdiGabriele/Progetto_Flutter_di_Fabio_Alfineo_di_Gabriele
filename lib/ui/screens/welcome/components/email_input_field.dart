import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class EmailInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final String hint;

  const EmailInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
  });

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
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
        keyboardType: TextInputType.emailAddress,
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
      ),
    );
  }
}