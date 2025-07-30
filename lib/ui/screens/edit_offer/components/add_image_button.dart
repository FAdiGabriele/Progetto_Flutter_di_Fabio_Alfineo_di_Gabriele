import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/app_color.dart';
import '../../../utils/asset_location.dart';

class DottedIconButton extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double dashPatternPrimary;
  final double dashPatternSecondary;
  final double borderRadius;
  final double buttonWidth;
  final double buttonHeight;

  const DottedIconButton({
    super.key,
    this.color = AppColor.black,
    this.strokeWidth = 2.0,
    this.dashPatternPrimary = 6,
    this.dashPatternSecondary = 4,
    this.borderRadius = 8.0,
    this.buttonWidth = 285.0,
    this.buttonHeight = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: color,
      strokeWidth: strokeWidth,
      borderType: BorderType.RRect,
      radius: Radius.circular(borderRadius),
      dashPattern: [dashPatternPrimary, dashPatternSecondary],
      child: SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: Center(
          child: SvgPicture.asset(AssetLocation.circularAddIconSvgLocation),
        ),
      ),
    );
  }
}
