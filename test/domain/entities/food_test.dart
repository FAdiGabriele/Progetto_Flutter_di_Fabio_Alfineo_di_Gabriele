import 'package:flutter_test/flutter_test.dart';
import 'package:offro_cibo/data/models/food_dto.dart';
import 'package:offro_cibo/domain/entities/categories.dart';
import 'package:offro_cibo/domain/entities/food.dart';

void main() {
  group('Food', () {
    final now = DateTime.now().toString();

    group('constructor and properties', () {
      test('should correctly assign properties when created', () {
        final food = Food(
          id: '1',
          foodName: 'Pizza Margherita',
          category: [Categories.pizza, Categories.vegan],
          quantity: 1,
          date: now,
          restaurantName: 'Italian Place',
          restaurantAddress: '123 Main St',
          userId: 'user123',
          imageLink: ''
        );

        expect(food.id, '1');
        expect(food.foodName, 'Pizza Margherita');
        expect(food.category, [Categories.pizza, Categories.vegan]);
        expect(food.quantity, 1);
        expect(food.date, now);
        expect(food.restaurantName, 'Italian Place');
        expect(food.restaurantAddress, '123 Main St');
        expect(food.userId, 'user123');
      });
    });

    group('mapFoodDTOToFood factory', () {
      test('should correctly map a FoodDTO to a Food entity with valid categories', () {
        final foodDto = FoodDTO(
          id: 'dto1',
          foodName: 'Sushi Set',
          category: ['fries', 'fish'],
          quantity: 5,
          date: now,
          restaurantName: 'Sushi Bar',
          restaurantAddress: 'Ocean Ave',
          idCustomUser: 'userDto1',
          imageLink: '',
        );

        final result = Food.mapFoodDTOToFood(foodDto);

        expect(result.id, 'dto1');
        expect(result.foodName, 'Sushi Set');
        expect(result.category, containsAll([Categories.fries, Categories.fish]));
        expect(result.category.length, 2);
        expect(result.quantity, 5);
        expect(result.date, now);
        expect(result.restaurantName, 'Sushi Bar');
        expect(result.restaurantAddress, 'Ocean Ave');
        expect(result.userId, 'userDto1');
        expect(result.imageLink, '');
      });

      test('should correctly map a FoodDTO with an empty category list', () {
        final foodDto = FoodDTO(
          id: 'dto2',
          foodName: 'Plain Burger',
          category: [],
          quantity: 1,
          date: now,
          restaurantName: 'Burger Joint',
          restaurantAddress: 'Fast Food Ln',
          idCustomUser: 'userDto2',
          imageLink: '',
        );

        final result = Food.mapFoodDTOToFood(foodDto);

        expect(result.id, 'dto2');
        expect(result.foodName, 'Plain Burger');
        expect(result.category, isEmpty);
        expect(result.quantity, 1);
        expect(result.userId, 'userDto2');
      });

      test('should correctly map a FoodDTO with category strings needing trimming', () {
        final foodDto = FoodDTO(
          id: 'dto3',
          foodName: 'Spicy Tacos',
          category: [' fries ', ' meat '],
          quantity: 3,
          date: now,
          restaurantName: 'Taco Spot',
          restaurantAddress: 'South St',
          idCustomUser: 'userDto3',
          imageLink: '',
        );

        final result = Food.mapFoodDTOToFood(foodDto);

        expect(result.id, 'dto3');
        expect(result.foodName, 'Spicy Tacos');
        expect(result.category, containsAll([Categories.fries, Categories.meat]));
        expect(result.category.length, 2);
        expect(result.quantity, 3);
      });

      test('should map FoodDTO with null id correctly', () {
        final foodDto = FoodDTO(
          id: null,
          foodName: 'New Item',
          category: ['sweets'],
          quantity: 1,
          date: now,
          restaurantName: 'Sweet Shop',
          restaurantAddress: 'Sugar Ln',
          idCustomUser: 'userNew',
          imageLink: '',
        );

        final result = Food.mapFoodDTOToFood(foodDto);

        expect(result.id, isNull);
        expect(result.foodName, 'New Item');
        expect(result.category, [Categories.sweets]);
      });
    });
  });
}
