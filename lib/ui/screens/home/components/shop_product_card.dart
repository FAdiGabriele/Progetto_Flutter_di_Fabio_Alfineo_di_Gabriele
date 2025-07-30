import 'package:flutter/material.dart';
import 'package:offro_cibo/ui/utils/app_string.dart';

import '../../../../domain/entities/food.dart';
import '../../../components/circular_button.dart';
import '../../../components/text.dart';
import '../../../components/top_image_card.dart';
import '../../../utils/app_color.dart';
import '../../../utils/asset_location.dart';

class ShopProductCard extends StatelessWidget {
  final Food food;
  final VoidCallback onEditButtonPressed;
  final VoidCallback onDeleteButtonPressed;

  const ShopProductCard({
    super.key,
    required this.food,
    required this.onEditButtonPressed,
    required this.onDeleteButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 360,
        child: Card(
          color: AppColor.white,
          child: Column(
            children: [
              TopImageCard(imageLink: food.imageLink),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(children: [
                      LeftSubTitleText(text: food.foodName),
                    ]),
                    SizedBox(height: 8.0),
                    Row(
                      children: food.category
                          .map(
                            (category) => Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: GreenCategoryText(text: category.name)),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        LeftText(
                            text: AppString
                                .shop_home_screen__card__portions_number_label),
                        LeftBoldText(text: food.quantity.toString()),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(children: [
                      LeftBoldText(text: food.restaurantName),
                    ]),
                    SizedBox(height: 8.0),
                    Row(children: [
                      LeftText(text: food.restaurantAddress),
                    ]),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        LeftText(
                            text: AppString
                                .shop_home_screen__card__product_date_label),
                        LeftText(text: food.date),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircularButton(
                          onPressed: onEditButtonPressed,
                          iconColor: AppColor.black,
                          backgroundColor: AppColor.white,
                          iconLocation: AssetLocation.editIconSvgLocation,
                          size: 52.0,
                          iconMargin: 10.0,
                        ),
                        CircularButton(
                          onPressed: onDeleteButtonPressed,
                          iconColor: AppColor.white,
                          backgroundColor: AppColor.red,
                          iconLocation: AssetLocation.deleteIconSvgLocation,
                          size: 52.0,
                          iconMargin: 10.0,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
