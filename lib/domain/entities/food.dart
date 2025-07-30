
import 'package:flutter/foundation.dart';

import '../../data/models/food_dto.dart';
import 'categories.dart';

class Food {
  final String? id;
  final String foodName;
  final List<Categories> category;
  final int quantity;
  final String date;
  final String restaurantName;
  final String restaurantAddress;
  final String userId;
  final String imageLink;

  Food({
    this.id,
    required this.foodName,
    required this.category,
    required this.quantity,
    required this.date,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.userId,
    required this.imageLink,
  });

  factory Food.mapFoodDTOToFood(FoodDTO dto) {
    return Food(
      id: dto.id,
      foodName: dto.foodName,
      category: _stringToCategoriesList(dto.category),
      quantity: dto.quantity,
      date: dto.date,
      restaurantName: dto.restaurantName,
      restaurantAddress: dto.restaurantAddress,
      userId: dto.idCustomUser,
      imageLink: dto.imageLink,
    );
  }

  static List<Categories> _stringToCategoriesList(List<String> categoryIdList) {
    if (categoryIdList.isEmpty) {
      return [];
    }
    return categoryIdList
        .map((id) => Categories.fromId(id.trim()))
        .whereType<Categories>()
        .toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Food &&
        runtimeType == other.runtimeType &&
        id == other.id &&
        foodName == other.foodName &&
        listEquals(category, other.category) &&
        quantity == other.quantity &&
        date == other.date &&
        restaurantName == other.restaurantName &&
        restaurantAddress == other.restaurantAddress &&
        userId == other.userId &&
        imageLink == other.imageLink;
  }
  @override
  int get hashCode {
    return Object.hash(
      id,
      foodName,
      Object.hashAll(category),
      quantity,
      date,
      restaurantName,
      restaurantAddress,
      userId,
      imageLink,
      runtimeType,
    );
  }
}
