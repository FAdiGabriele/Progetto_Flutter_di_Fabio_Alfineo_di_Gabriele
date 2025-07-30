import '../../data/data_sources/firebase_firestore_take_food_service.dart';
import '../utils/request_status.dart';

abstract class TakeFoodRepositoryApi {
  Future<RequestStatus> takeFood(
      {required String foodId, required int portions, required String userId});
}

class TakeFoodRepository implements TakeFoodRepositoryApi {
  final FirebaseFirestoreTakeFoodServiceApi _firebaseTakeFoodService;

  TakeFoodRepository(
      {required FirebaseFirestoreTakeFoodServiceApi firebaseTakeFoodService})
      : _firebaseTakeFoodService = firebaseTakeFoodService;

  @override
  Future<RequestStatus> takeFood({
    required String foodId,
    required int portions,
    required String userId,
  }) async {
    try {
      final result = await _firebaseTakeFoodService.takeFood(foodId, portions, userId);
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }
}
