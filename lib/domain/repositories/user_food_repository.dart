import '../../data/data_sources/firebase_firestore_food_service.dart';
import '../../data/data_sources/firebase_firestore_user_service.dart';
import '../../data/models/food_dto.dart';
import '../entities/categories.dart';
import '../entities/food.dart';
import '../utils/request_status.dart';

abstract class UserFoodRepositoryApi {
  Future<RequestStatus> getFoodCounter({required String userId});

  Future<RequestStatus> searchFood({
    required String queryText,
    required List<Categories> categories,
  });
}

class UserFoodRepository implements UserFoodRepositoryApi {
  final FirebaseFirestoreFoodServiceApi _firebaseFoodService;
  final FirebaseFirestoreUserServiceApi _firebaseUserService;

  UserFoodRepository({
    required FirebaseFirestoreFoodServiceApi firebaseFoodService,
    required FirebaseFirestoreUserServiceApi firebaseUserService,
  })  : _firebaseFoodService = firebaseFoodService,
        _firebaseUserService = firebaseUserService;

  @override
  Future<RequestStatus> searchFood({
    required String queryText,
    required List<Categories> categories,
  }) async {
    try {
      final categoryIds = categories.map((category) => category.id).toList();

      final List<FoodDTO> foodDTOList = await _firebaseFoodService.searchFood(
        queryText: queryText,
        categoryIds: categoryIds,
      );

      final foodList =
          foodDTOList.map((dto) => Food.mapFoodDTOToFood(dto)).toList();

      return Success(foodList);
    } catch (e) {
      return Failure(e);
    }
  }

  Future<RequestStatus> getFoodCounter({required String userId}) async {
    try {
      final user = await _firebaseUserService.getUserById(userId);

      final result = user.food_quantity;

      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }
}
