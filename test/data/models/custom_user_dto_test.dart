import 'package:flutter_test/flutter_test.dart';
import 'package:offro_cibo/data/models/custom_user_dto.dart';

void main() {
  group('CustomUserDTO', () {
    final String testId = 'user123';
    final String testName = 'John Doe';
    final String testEmail = 'john.doe@example.com';
    final int testFoodQuantity = 10;

    test('toMap() should convert CustomUserDTO to a Map', () {
      final customUserDTO = CustomUserDTO(
        id: testId,
        name: testName,
        email: testEmail,
        food_quantity: testFoodQuantity,
      );

      final map = customUserDTO.toMap();

      expect(map['id'], testId);
      expect(map['name'], testName);
      expect(map['email'], testEmail);
      expect(map['food_quantity'], testFoodQuantity);
    });

    test('fromMap() should create CustomUserDTO from a Map with valid data', () {
      final Map<String, dynamic> map = {
        'name': testName,
        'email': testEmail,
        'food_quantity': testFoodQuantity,
      };

      final customUserDTO = CustomUserDTO.fromMap(map, testId);

      expect(customUserDTO.id, testId);
      expect(customUserDTO.name, testName);
      expect(customUserDTO.email, testEmail);
      expect(customUserDTO.food_quantity, testFoodQuantity);
    });

    test('fromMap() should create CustomUserDTO with default values for missing data', () {
      final Map<String, dynamic> map = {}; // Empty map

      final customUserDTO = CustomUserDTO.fromMap(map, testId);

      expect(customUserDTO.id, testId);
      expect(customUserDTO.name, '');
      expect(customUserDTO.email, '');
      expect(customUserDTO.food_quantity, 0);
    });

    test('fromMap() should handle null values in map and use default values', () {
      final Map<String, dynamic> map = {
        'name': null,
        'email': null,
        'food_quantity': null,
      };

      final customUserDTO = CustomUserDTO.fromMap(map, testId);

      expect(customUserDTO.id, testId);
      expect(customUserDTO.name, '');
      expect(customUserDTO.email, '');
      expect(customUserDTO.food_quantity, 0);
    });

    test('fromMap() should handle different data types gracefully', () {
      final Map<String, dynamic> map = {
        'name': 123,
        'email': true,
        'food_quantity': 'abc',
      };

      final customUserDTO = CustomUserDTO.fromMap(map, testId);

      expect(customUserDTO.id, testId);
      expect(customUserDTO.name, '');
      expect(customUserDTO.email, '');
      expect(customUserDTO.food_quantity, 0);
    });
  });
}