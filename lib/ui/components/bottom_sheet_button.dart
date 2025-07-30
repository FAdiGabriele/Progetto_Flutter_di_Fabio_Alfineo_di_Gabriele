import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/asset_location.dart';


class AddCameraPhotoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddCameraPhotoButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 64,
      icon: SvgPicture.asset(AssetLocation.cameraPhotoIconSvgLocation),
    );
  }
}

class AddGalleryPhotoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddGalleryPhotoButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 64,
      icon: SvgPicture.asset(AssetLocation.galleryPhotoIconSvgLocation),
    );
  }
}
