import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class UnderlinedTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool isTitle;

  const UnderlinedTextFormField({
    super.key,
    required this.controller,
    this.isTitle = false,
  });

  @override
  State<UnderlinedTextFormField> createState() => _UnderlinedTextFormFieldState();
}

class _UnderlinedTextFormFieldState extends State<UnderlinedTextFormField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColor.green, width: 1.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColor.green, width: 1.0),
          ),
          contentPadding: EdgeInsets.zero,
          isDense: true,
      ),
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20.0,
        fontWeight: widget.isTitle ? FontWeight.bold : FontWeight.normal,
      ),

    );
  }
}
