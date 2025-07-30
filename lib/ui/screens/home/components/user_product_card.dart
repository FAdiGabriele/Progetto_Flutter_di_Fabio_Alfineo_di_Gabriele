import 'package:flutter/material.dart';
import 'package:offro_cibo/ui/utils/app_string.dart';

import '../../../../domain/entities/categories.dart';
import '../../../components/cta_button.dart';
import '../../../components/text.dart';
import '../../../components/top_image_card.dart';
import '../../../utils/app_color.dart';

class UserProductCard extends StatelessWidget {
  final String name;
  final String restaurantName;
  final String restaurantAddress;
  final List<Categories> categories;
  final String productionFoodDate;
  final String imageLink;
  final int foodQuantity;
  final VoidCallback onCTAPressed;

  const UserProductCard({
    super.key,
    required this.name,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.productionFoodDate,
    required this.foodQuantity,
    required this.categories,
    required this.imageLink,
    required this.onCTAPressed,
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
              TopImageCard(imageLink: imageLink),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TitleText(text: name),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: categories
                          .map((type) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GreenCategoryText(text: type.name),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CenteredText(
                            text: AppString
                                .user_home_screen__card__portions_number_label),
                        CenteredBoldText(text: foodQuantity.toString()),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    CenteredBoldText(text: restaurantName),
                    SizedBox(height: 8.0),
                    CenteredText(text: restaurantAddress),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CenteredText(
                            text: AppString
                                .user_home_screen__card__product_date_label),
                        CenteredText(text: productionFoodDate),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    CTAButton(
                      text: AppString.user_home_screen__card__cta_label,
                      onPressed: onCTAPressed,
                      fontSize: 24.0,
                    ),
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
