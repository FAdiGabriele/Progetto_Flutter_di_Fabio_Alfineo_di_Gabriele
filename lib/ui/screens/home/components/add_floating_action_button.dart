import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class AddFloatingActionButton extends StatelessWidget {
  final Function() onPressedListener;
  const AddFloatingActionButton({super.key, required this.onPressedListener});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0.0,
      highlightElevation: 0.0,
      foregroundColor: AppColor.white,
      backgroundColor: AppColor.green,
      shape: const CircleBorder(),
      onPressed: onPressedListener,
      child: const Icon(Icons.add),
    );
  }
}
