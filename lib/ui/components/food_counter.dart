import 'package:flutter/material.dart';
import 'package:offro_cibo/ui/components/text.dart';

import '../utils/app_string.dart';

class FoodCounter extends StatelessWidget {
  final String foodQuantity;

  const FoodCounter({super.key, required this.foodQuantity});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      LeftSubTitleText(
        text: '$foodQuantity ',
      ),
      Text(
        getLabel(),
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
        ),
      ),
    ]);
  }

  String getLabel() {
    if (foodQuantity == '1') {
      return AppString.user_home_screen__ordered_one_portion_label;
    } else {
      return AppString.user_home_screen__ordered_many_portions_label;
    }
  }
}
