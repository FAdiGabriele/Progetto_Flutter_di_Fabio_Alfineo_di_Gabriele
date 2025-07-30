import 'package:flutter_test/flutter_test.dart';
import 'package:offro_cibo/data/models/food_dto.dart';

void main() {
  group('FoodDTO', () {
    final now = DateTime.now().toString();

    group('constructor and properties', () {
      test('should correctly assign properties when created', () {
        final foodDto = FoodDTO(
          id: '1',
          foodName: 'Pizza',
          category: ['pizza'],
          quantity: 1,
          date: now,
          restaurantName: 'Pizza Place',
          restaurantAddress: '123 Main St',
          idCustomUser: 'user123',
          imageLink: '',
        );

        expect(foodDto.id, '1');
        expect(foodDto.foodName, 'Pizza');
        expect(foodDto.category, ['pizza']);
        expect(foodDto.quantity, 1);
        expect(foodDto.date, now);
        expect(foodDto.restaurantName, 'Pizza Place');
        expect(foodDto.restaurantAddress, '123 Main St');
        expect(foodDto.idCustomUser, 'user123');
        expect(foodDto.imageLink, '');
      });
    });

    group('toMap', () {
      test('should return a valid map representation of the FoodDTO', () {
        final foodDto = FoodDTO(
          id: '1',
          foodName: 'Pizza',
          category: ['pizza'],
          quantity: 1,
          date: now,
          restaurantName: 'Pizza Place',
          restaurantAddress: '123 Main St',
          idCustomUser: 'user123',
          imageLink: '',
        );

        final result = foodDto.toMap();

        final expectedMap = {
          'id': '1',
          'foodName': 'Pizza',
          'category': ['pizza'],
          'quantity': 1,
          'date': now,
          'restaurant_name': 'Pizza Place',
          'restaurant_address': '123 Main St',
          'id_custom_user': 'user123',
          'image_link': '',
        };
        expect(result, expectedMap);
      });

      test('should return a map with null id if DTO id is null', () {
        final foodDto = FoodDTO(
          id: null,
          foodName: 'Pasta',
          category: ['pasta'],
          quantity: 2,
          date: now,
          restaurantName: 'Pasta Place',
          restaurantAddress: '456 Oak Ave',
          idCustomUser: 'user456',
          imageLink: '',
        );

        final result = foodDto.toMap();

        expect(result['id'], null);
        expect(result['foodName'], 'Pasta');
      });
    });

    group('fromMap', () {
      test('should return a valid FoodDTO from a map', () {
        final map = {
          'id': 'doc1',
          'foodName': 'Burger',
          'category': ['meat'],
          'quantity': 1,
          'date': now,
          'restaurant_name': 'Burger Joint',
          'restaurant_address': '789 Pine Ln',
          'id_custom_user': 'user789',
          'image_link': '',
        };

        final result = FoodDTO.fromMap(map);

        expect(result.id, 'doc1');
        expect(result.foodName, 'Burger');
        expect(result.category, ['meat']);
        expect(result.quantity, 1);
        expect(result.date, now);
        expect(result.restaurantName, 'Burger Joint');
        expect(result.restaurantAddress, '789 Pine Ln');
        expect(result.idCustomUser, 'user789');
        expect(result.imageLink, '');
      });

      test('should handle missing optional fields with defaults', () {
        final map = {
          'id': 'doc2',
          'foodName': 'Salad',
        };

        final result = FoodDTO.fromMap(map);

        expect(result.id, 'doc2');
        expect(result.foodName, 'Salad');
        expect(result.category, List.empty());
        expect(result.quantity, 0);
        expect(result.date, '');
        expect(result.restaurantName, '');
        expect(result.restaurantAddress, '');
        expect(result.idCustomUser, '');
        expect(result.imageLink, '');
      });

      test('should handle incorrect data types with defaults', () {
        final map = {
          'id': 'doc3',
          'foodName': 123,
          'category': 'not-a-list',
          'quantity': 'not-an-int',
          'date': true,
          'restaurantName': 45.6,
          'restaurantAddress': [],
          'id_custom_user': {},
          'image_link': '',
        };

        final result = FoodDTO.fromMap(map);

        expect(result.id, 'doc3');
        expect(result.foodName, '');
        expect(result.category, List.empty());
        expect(result.quantity, 0);
        expect(result.date, '');
        expect(result.restaurantName, '');
        expect(result.restaurantAddress, '');
        expect(result.idCustomUser, '');
        expect(result.imageLink, '');
      });

      test('should correctly parse map when category is explicitly null', () {
        final map = {
          'id': 'doc4',
          'foodName': 'Fries',
          'category': null,
          'quantity': 1,
          'date': now,
          'restaurantName': 'Side Snacks',
          'restaurantAddress': 'Corner St',
          'id_custom_user': 'user000',
          'image_link': '',
        };

        final result = FoodDTO.fromMap(map);

        expect(result.id, 'doc4');
        expect(result.foodName, 'Fries');
        expect(result.category, List.empty());
      });
    });
  });
}
