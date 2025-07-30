import 'package:flutter_test/flutter_test.dart';
import 'package:offro_cibo/domain/entities/categories.dart';
import 'package:offro_cibo/ui/utils/app_string.dart';

void main() {

  group('Categories Enum', () {
    test('should have correct id and name for each enum value', () {
      expect(Categories.pizza.id, 'pizza');
      expect(Categories.pizza.name, AppString.pizza_category_label);

      expect(Categories.fish.id, 'fish');
      expect(Categories.fish.name, AppString.fish_category_label);

      expect(Categories.meat.id, 'meat');
      expect(Categories.meat.name, AppString.meat_category_label);

      expect(Categories.sweets.id, 'sweets');
      expect(Categories.sweets.name, AppString.sweets_category_label);

      expect(Categories.pasta.id, 'pasta');
      expect(Categories.pasta.name, AppString.pasta_category_label);

      expect(Categories.fries.id, 'fries');
      expect(Categories.fries.name, AppString.fries_category_label);

      expect(Categories.vegan.id, 'vegan');
      expect(Categories.vegan.name, AppString.vegan_category_label);
    });

    group('fromId static method', () {
      test('should return correct Category for valid id', () {
        expect(Categories.fromId('pizza'), Categories.pizza);
        expect(Categories.fromId('fish'), Categories.fish);
        expect(Categories.fromId('meat'), Categories.meat);
        expect(Categories.fromId('sweets'), Categories.sweets);
        expect(Categories.fromId('pasta'), Categories.pasta);
        expect(Categories.fromId('fries'), Categories.fries);
        expect(Categories.fromId('vegan'), Categories.vegan);
      });

      test('should be case sensitive for id matching', () {
        expect(Categories.fromId('Pizza'), isNull);
        expect(Categories.fromId('FISH'), isNull);
      });

      test('should return null for an unknown id', () {
        expect(Categories.fromId('unknown_category'), isNull);
        expect(Categories.fromId(''), isNull);
        expect(Categories.fromId(' dessert '), isNull);
      });

      test('should return null for an id that is a substring but not a full match', () {
        expect(Categories.fromId('piz'), isNull);
      });
    });

    test('Categories.values should contain all defined categories', () {
      final allValues = Categories.values;
      expect(allValues, contains(Categories.pizza));
      expect(allValues, contains(Categories.fish));
      expect(allValues, contains(Categories.meat));
      expect(allValues, contains(Categories.sweets));
      expect(allValues, contains(Categories.pasta));
      expect(allValues, contains(Categories.fries));
      expect(allValues, contains(Categories.vegan));
      expect(allValues.length, 7);
    });
  });
}
