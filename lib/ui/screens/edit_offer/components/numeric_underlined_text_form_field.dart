import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class NumericUnderlinedTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  const NumericUnderlinedTextFormField({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  State<NumericUnderlinedTextFormField> createState() =>
      _NumericUnderlinedTextFormFieldState();
}

class _NumericUnderlinedTextFormFieldState
    extends State<NumericUnderlinedTextFormField> {

  final _hintTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColor.hintGray
  );

  double _calculateTextWidthByHint() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.hint, style: _hintTextStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 32.0, maxWidth: double.infinity);
    return textPainter.size.width + 4.0;
  }


  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _calculateTextWidthByHint(),
      child: TextFormField(
        controller: widget.controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.green, width: 1.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.green, width: 1.0),
            ),
            contentPadding: EdgeInsets.zero,
            isDense: true,
            hintText: widget.hint,
            hintStyle: _hintTextStyle),
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
        ),
      ),
    );
  }
}
