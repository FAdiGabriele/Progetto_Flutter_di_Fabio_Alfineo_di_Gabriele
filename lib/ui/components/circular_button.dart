import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color iconColor;
  final Color backgroundColor;
  final String iconLocation;
  final double size;
  final double iconMargin;

  const CircularButton({
    super.key,
    required this.onPressed,
    required this.iconColor,
    required this.backgroundColor,
    required this.iconLocation,
    required this.size,
    required this.iconMargin,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius:
              BorderRadius.circular(32.0),
        ),
        child: IconButton(
          onPressed: onPressed,
          color: iconColor,
          iconSize: size - (iconMargin * 2),
          icon: SvgPicture.asset(iconLocation),
        ),
      ),
    );
  }
}
