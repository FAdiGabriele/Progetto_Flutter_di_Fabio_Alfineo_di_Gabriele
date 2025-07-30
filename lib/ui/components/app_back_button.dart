import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/asset_location.dart';


class AppBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppBackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 24,
      icon: SvgPicture.asset(AssetLocation.backIconSvgLocation),
    );
  }
}
