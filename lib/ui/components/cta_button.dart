import 'package:flutter/material.dart';
import '../utils/app_color.dart';

class CTAButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double fontSize;

  const CTAButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColor.gray,
          disabledForegroundColor: AppColor.white,
          backgroundColor: AppColor.green,
          foregroundColor: AppColor.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
