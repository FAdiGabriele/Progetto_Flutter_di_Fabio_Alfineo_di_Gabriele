import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class SelectableChip extends StatelessWidget {
  final bool isSelected;
  final Function(bool) onSelected;
  final String label;

  const SelectableChip(
      {super.key,
      required this.isSelected,
      required this.onSelected,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return FilterChip.elevated(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide.none,
      ),
      elevation: 4.0,
      showCheckmark: false,
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColor.white : AppColor.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: AppColor.backgroundWhite,
      selectedColor: AppColor.green,
    );
  }
}
