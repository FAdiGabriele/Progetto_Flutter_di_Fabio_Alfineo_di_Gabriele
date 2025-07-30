import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/utils/logger.dart';
import '../models/food_dto.dart';

abstract class FirebaseFirestoreFoodServiceApi {
  Future<FoodDTO> addFood(FoodDTO newFood);

  Future<bool> deleteFood(String id);

  Future<FoodDTO> getFood(String id);

  Future<FoodDTO> updateFood(FoodDTO food);

  Future<List<FoodDTO>> searchFood({
    required String queryText,
    required List<String> categoryIds,
  });

  Future<List<FoodDTO>> getFoodListByUser(String userId);
}

class FirebaseFirestoreFoodService implements FirebaseFirestoreFoodServiceApi {
  static final _classTag = 'FirebaseFirestoreFoodService';
  static final _foodCollectionName = 'food';

  @override
  Future<FoodDTO> addFood(FoodDTO newFood) async {
    try {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection(_foodCollectionName)
          .doc(newFood.id);
      AppLogger.logger.d('$_classTag: Food Added');

      final foodMap = newFood.toMap();
      foodMap['id'] = docRef.id;

      await docRef.set(foodMap);
      AppLogger.logger.d('$_classTag: Food Added with ID: ${foodMap['id']}');

      return FoodDTO.fromMap(foodMap);
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to add food: $error');
      rethrow;
    }
  }

  @override
  Future<bool> deleteFood(String id) async {
    try {
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection(_foodCollectionName).doc(id);

      await docRef.delete();

      AppLogger.logger.d('$_classTag: Food Deleted with ID: $id');

      return true;
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to delete food: $error');
      rethrow;
    }
  }

  @override
  Future<FoodDTO> getFood(String id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(_foodCollectionName)
          .where('id', isEqualTo: id)
          .get();

      final snapshot = querySnapshot.docs.first;
      final data = snapshot.data() as Map<String, dynamic>;
      return FoodDTO.fromMap(data);
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to get users: $error');
      rethrow;
    }
  }

  @override
  Future<List<FoodDTO>> searchFood({
    required String queryText,
    required List<String> categoryIds,
  }) async {
    if (queryText.trim().isEmpty && categoryIds.isEmpty) {
      return [];
    }

    String normalizedQuery = queryText.trim().toLowerCase();
    List<String> queryKeywords =
        normalizedQuery.split(' ').where((k) => k.isNotEmpty).toList();

    Query foodsQuery =
        FirebaseFirestore.instance.collection(_foodCollectionName);

    if (categoryIds.isNotEmpty) {
      foodsQuery = foodsQuery.where('category', arrayContainsAny: categoryIds);
    }

    try {
      QuerySnapshot querySnapshot = await foodsQuery.get();
      List<FoodDTO> foodsFromCategoryFilter = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            if (data == null) return null;
            final newFood = FoodDTO.fromMap(data);
            if(newFood.id?.isEmpty == true) return null;
            return newFood;
          })
          .whereType<FoodDTO>()
          .toList();

      if (normalizedQuery.isNotEmpty) {
        return foodsFromCategoryFilter.where((food) {
          String searchableFoodText =
              ("${food.foodName} ${food.restaurantName}").toLowerCase();

          if (queryKeywords
              .every((keyword) => searchableFoodText.contains(keyword))) {
            return true;
          }
          return false;
        }).toList();
      } else {
        return foodsFromCategoryFilter;
      }
    } catch (e) {
      AppLogger.logger.d("$_classTag: Error searching food: $e");
      throw Exception("Failed to search for food: $e");
    }
  }

  @override
  Future<List<FoodDTO>> getFoodListByUser(String userId) async {
    try {
      final List<FoodDTO> result = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(_foodCollectionName)
          .where('id_custom_user', isEqualTo: userId)
          .get();

      final snapshot = querySnapshot.docs;

      for (var doc in snapshot) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          FoodDTO newFoodDTO = FoodDTO.fromMap(data);
          if(newFoodDTO.id?.isNotEmpty == true) {
            result.add(newFoodDTO);
          }
        }
      }
      return result;
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to get food: $error');
      rethrow;
    }
  }

  @override
  Future<FoodDTO> updateFood(FoodDTO food) async {
    try {
      await FirebaseFirestore.instance
          .collection(_foodCollectionName)
          .doc(food.id)
          .update(food.toMap());

      AppLogger.logger.d('$_classTag: Food Updated');
      return food;
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to update food: $error');
      rethrow;
    }
  }
}
