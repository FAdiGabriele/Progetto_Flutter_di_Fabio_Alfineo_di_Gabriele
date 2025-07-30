import 'package:flutter/material.dart';

import '../utils/image_picker_notifier.dart';
import 'add_image_button.dart';

class ImagePickerWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final ImagePickerNotifier notifier;

  const ImagePickerWidget({
    super.key,
    required this.onPressed,
    required this.notifier,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Widget _buildImagePreview(ImageSelectedWrapper? imageSelected) {
    if (imageSelected == null) {
      return DottedIconButton();
    }

    final imageData = imageSelected.data;

    const double imageHeight = 94;
    const double imageWidth = 285;
    const BoxFit imageFit = BoxFit.fitWidth;

    switch (imageData) {
      case WebImageSelectedData webData:
        return Image.memory(
          webData.bytes,
          height: imageHeight,
          width: imageWidth,
          fit: imageFit,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorImagePlaceholder("Error loading web image");
          },
        );
      case MobileImageSelectedData mobileData:
        return Image.file(
          mobileData.file,
          height: imageHeight,
          width: imageWidth,
          fit: imageFit,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorImagePlaceholder("Error loading mobile image");
          },
        );
      case LinkImagedData linkData:
        return Stack(
          children: [
            Image.network(
              linkData.link,
              height: imageHeight,
              width: imageWidth,
              fit: imageFit,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorImagePlaceholder(
                    "Error loading network image");
              },
            ),
            Container(
              height: imageHeight,
              width: imageWidth,
              color: Colors.transparent,
            )
          ],
        );
    }
    return _buildErrorImagePlaceholder(
        "Could not display image (unknown type)");
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (BuildContext context, Widget? child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: widget.onPressed,
              child: _buildImagePreview(widget.notifier.imageSelected),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildErrorImagePlaceholder(String message) {
  return Container(
    height: 94,
    width: 285,
    color: Colors.grey[300],
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red[700], fontSize: 12),
        ),
      ),
    ),
  );
}
