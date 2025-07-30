import 'package:flutter/foundation.dart';

import '../../domain/entities/food.dart';

class FoodDTO {
  final String? id;
  final String foodName;
  final List<String> category; //TODO: explain this change from spec
  final int quantity;
  final String date;
  final String restaurantName;
  final String restaurantAddress;
  final String idCustomUser;
  final String imageLink;

  FoodDTO(
      {required this.id,
      required this.foodName,
      required this.category,
      required this.quantity,
      required this.date,
      required this.restaurantName,
      required this.restaurantAddress,
      required this.idCustomUser,
      required this.imageLink});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodName': foodName,
      'category': category,
      'quantity': quantity,
      'date': date,
      'restaurant_name': restaurantName,
      'restaurant_address': restaurantAddress,
      'id_custom_user': idCustomUser,
      'image_link': imageLink
    };
  }

  factory FoodDTO.fromMap(Map<String, dynamic> map) {
    return FoodDTO(
      id: map['id'] is String ? map['id'] : '',
      foodName: map['foodName'] is String ? map['foodName'] : '',
      category: map['category'] is List<dynamic> ? List<String>.from(map['category']) : List.empty(),
      quantity: map['quantity'] is int ? map['quantity'] : 0,
      date: map['date'] is String ? map['date'] : '',
      restaurantName: map['restaurant_name'] is String ? map['restaurant_name'] : '',
      restaurantAddress: map['restaurant_address'] is String ? map['restaurant_address'] : '',
      idCustomUser: map['id_custom_user'] is String ? map['id_custom_user'] : '',
      imageLink: map['image_link'] is String ? map['image_link'] : '',
    );
  }

  factory FoodDTO.mapEntityToFoodDTO(Food entity) {
    return FoodDTO(
      id: entity.id,
      foodName: entity.foodName,
      category: entity.category.map((cat) => cat.id).toList(),
      quantity: entity.quantity,
      date: entity.date,
      restaurantName: entity.restaurantName,
      restaurantAddress: entity.restaurantAddress,
      idCustomUser: entity.userId,
      imageLink: entity.imageLink,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodDTO &&
        runtimeType == other.runtimeType &&
        id == other.id &&
        foodName == other.foodName &&
        listEquals(category, other.category) &&
        quantity == other.quantity &&
        date == other.date &&
        restaurantName == other.restaurantName &&
        restaurantAddress == other.restaurantAddress &&
        idCustomUser == other.idCustomUser &&
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
      idCustomUser,
      imageLink,
      runtimeType,
    );
  }

  FoodDTO copyWith({
    String? id,
    String? foodName,
    List<String>? category,
    int? quantity,
    String? date,
    String? restaurantName,
    String? restaurantAddress,
    String? idCustomUser,
    String? imageLink

  }) {
    return FoodDTO(
      id: id ?? this.id,
      foodName: foodName ?? this.foodName,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      idCustomUser: idCustomUser ?? this.idCustomUser,
      imageLink: imageLink ?? this.imageLink,
    );
  }
}
