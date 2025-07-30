import 'package:flutter/material.dart';
import 'text.dart';

class DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backGroundColor;
  final Color textColor;

  const DialogButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.backGroundColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backGroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        child: DialogButtonText(
          text: text,
          color: textColor,
        ),
      ),
    );
  }
}
