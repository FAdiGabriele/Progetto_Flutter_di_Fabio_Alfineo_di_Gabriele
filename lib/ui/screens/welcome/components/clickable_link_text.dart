import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class ClickableLinkText extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const ClickableLinkText({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: AppColor.green,
          color: AppColor.green,
        ),
      ),
    );
  }
}