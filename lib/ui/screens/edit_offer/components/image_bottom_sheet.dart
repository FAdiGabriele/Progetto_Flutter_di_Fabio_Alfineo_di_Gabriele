import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offro_cibo/domain/utils/logger.dart';

import '../../../components/bottom_sheet_button.dart';
import '../../../components/text.dart';
import '../../../utils/app_string.dart';
import '../utils/image_picker_notifier.dart';

final ImagePicker _picker = ImagePicker();

void addImageBottomSheet(
  BuildContext context,
  ImagePickerNotifier imagePickerNotifier,
) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      List<Widget> buttonList;

      if (kIsWeb) {
        buttonList = <Widget>[
          AddGalleryPhotoButton(
            onPressed: () {
              _pickImage(context, imagePickerNotifier, _picker);
            },
          ),
        ];
      } else {
        buttonList = <Widget>[
          AddCameraPhotoButton(
            onPressed: () {
              _pickImageFromCamera(context, imagePickerNotifier, _picker);
            },
          ),
          const SizedBox(width: 16),
          AddGalleryPhotoButton(
            onPressed: () {
              _pickImage(context, imagePickerNotifier, _picker);
            },
          ),
        ];
      }

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const TitleText(
              text: AppString.add_offer_screen__load_image_label,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttonList,
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _pickImage(
  BuildContext context,
  ImagePickerNotifier notifier,
  ImagePicker picker,
) async {
  try {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        notifier.setImageFromUint8List(imageBytes);
        AppLogger.logger.d('Image selected (web): ${pickedFile.name}');
      } else {
        final imageFile = File(pickedFile.path);
        notifier.setImageFromFile(imageFile);
        AppLogger.logger.d('Image selected (mobile): ${pickedFile.path}');
      }
    } else {
      AppLogger.logger.d('No image selected.');
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }
  Navigator.pop(context);
}

Future<void> _pickImageFromCamera(BuildContext context,
    ImagePickerNotifier notifier, ImagePicker picker) async {
  if (kIsWeb) {
    return;
  }

  try {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      notifier.setImageFromFile(File(pickedFile.path));
      AppLogger.logger.d('Image taken: ${pickedFile.path}');
    } else {
      AppLogger.logger.d('No image taken.');
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking image: $e')),
      );
    }
  }
  Navigator.pop(context);
}
