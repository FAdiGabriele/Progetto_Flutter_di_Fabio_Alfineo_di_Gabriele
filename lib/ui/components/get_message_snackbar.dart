import 'package:flutter/material.dart';
import '../utils/app_color.dart';

SnackBar getErrorMessageSnackBar(String text) {
  return SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 3),
    backgroundColor: AppColor.red,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}

SnackBar getPositiveMessageSnackBar(String text) {
  return SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 3),
    backgroundColor: AppColor.green,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}
