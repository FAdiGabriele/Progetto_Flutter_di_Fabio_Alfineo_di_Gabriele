import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePickerNotifier extends ChangeNotifier {
  ImageSelectedWrapper? _imageSelected;

  ImageSelectedWrapper? get imageSelected => _imageSelected;

  void setImageFromUint8List(Uint8List imageBytes) {
    _imageSelected = ImageSelectedWrapper(
      data: WebImageSelectedData(imageBytes),
    );
    notifyListeners();
  }

  void setImageFromFile(File imageFile) {
    _imageSelected = ImageSelectedWrapper(
      data: MobileImageSelectedData(imageFile),
    );
    notifyListeners();
  }

  void setImageFromLink(String link) {
    if(link != '') {
      _imageSelected = ImageSelectedWrapper(
        data: LinkImagedData(link),
      );
    } else {
      _imageSelected = null;
    }
    notifyListeners();
  }
}

class ImageSelectedWrapper {
  final ImageSelectedData data;

  ImageSelectedWrapper({required this.data});
}

abstract class ImageSelectedData {}

class WebImageSelectedData extends ImageSelectedData {
  final Uint8List bytes;
  WebImageSelectedData(this.bytes);
}

class MobileImageSelectedData extends ImageSelectedData {
  final File file;
  MobileImageSelectedData(this.file);
}

class LinkImagedData extends ImageSelectedData {
  final String link;
  LinkImagedData(this.link);
}