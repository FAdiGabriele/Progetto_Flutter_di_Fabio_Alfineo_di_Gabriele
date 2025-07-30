import '../../ui/utils/app_string.dart';
import '../utils/logger.dart';

enum Categories{
  pizza('pizza', AppString.pizza_category_label),
  fish('fish', AppString.fish_category_label),
  meat('meat', AppString.meat_category_label),
  sweets('sweets', AppString.sweets_category_label),
  pasta('pasta', AppString.pasta_category_label),
  fries('fries', AppString.fries_category_label),
  vegan('vegan', AppString.vegan_category_label);

  final String id;
  final String name;

  const Categories(this.id, this.name);

  static Categories? fromId(String id) {
    try {
      return Categories.values.firstWhere((e) => e.id == id);
    } catch (e) {
      AppLogger.logger.d('Warning: No Categories found with ID: $id');
      return null;
    }
  }
}