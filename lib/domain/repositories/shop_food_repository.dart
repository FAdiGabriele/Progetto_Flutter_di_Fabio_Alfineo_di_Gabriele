import '../../data/data_sources/firebase_firestore_food_service.dart';
import '../../data/data_sources/firebase_storage_service.dart';
import '../../data/models/food_dto.dart';
import '../../ui/screens/edit_offer/utils/image_picker_notifier.dart';
import '../entities/food.dart';
import '../utils/request_status.dart';

abstract class ShopFoodRepositoryApi {
  Future<RequestStatus> addFood(Food newFood, ImageSelectedWrapper? imageSelected);

  Future<RequestStatus> deleteFood(String id);

  Future<RequestStatus> getFood(String id);

  Future<RequestStatus> updateFood(Food food, ImageSelectedWrapper? imageSelected);

  Future<RequestStatus> getFoodListByUser(String userId);
}

class ShopFoodRepository implements ShopFoodRepositoryApi {
  final FirebaseFirestoreFoodServiceApi _firebaseFoodService;
  final FirebaseStorageServiceApi _firebaseStorageService;

  ShopFoodRepository(
      {required FirebaseFirestoreFoodServiceApi firebaseFoodService,
      required FirebaseStorageServiceApi firebaseStorageService
      })
      : _firebaseFoodService = firebaseFoodService,
        _firebaseStorageService = firebaseStorageService;

  @override
  Future<RequestStatus> addFood(Food newFood, ImageSelectedWrapper? imageSelected) async {
    try {
      final foodDTO = FoodDTO.mapEntityToFoodDTO(newFood);
      final addedDTO = await _firebaseFoodService.addFood(foodDTO);

      if(imageSelected != null && imageSelected is! LinkImagedData) {
        final path = 'food/${addedDTO.idCustomUser}/${addedDTO.id}';

        if (imageSelected.data is WebImageSelectedData) {
          final webImage = imageSelected.data as WebImageSelectedData;

          await _firebaseStorageService.uploadImageFromBytes(bytes: webImage.bytes, path: path);
          final imageLink = await _firebaseStorageService.fetchImageUrl(path);

          final foodWithImage = addedDTO.copyWith(imageLink: imageLink);
          _firebaseFoodService.updateFood(foodWithImage);
        } else if (imageSelected.data is MobileImageSelectedData) {
          final mobileImage = imageSelected.data as MobileImageSelectedData;

          await _firebaseStorageService.uploadImageFromFile(file: mobileImage.file, path: path);
          final imageLink = await _firebaseStorageService.fetchImageUrl(path);

          final foodWithImage = addedDTO.copyWith(imageLink: imageLink);
          _firebaseFoodService.updateFood(foodWithImage);
        }
      }

      final addedFood = Food.mapFoodDTOToFood(addedDTO);

      return Success(addedFood);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<RequestStatus> deleteFood(String id) async {
    try {
      final isFoodDeleted = await _firebaseFoodService.deleteFood(id);
      return Success(isFoodDeleted);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<RequestStatus> getFood(String id) async {
    try {
      final foodDTO = await _firebaseFoodService.getFood(id);
      final food = Food.mapFoodDTOToFood(foodDTO);
      return Success(food);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<RequestStatus> updateFood(Food food, ImageSelectedWrapper? imageSelected) async {
    try {
      final foodDTO = FoodDTO.mapEntityToFoodDTO(food);
      final updatedDTO = await _firebaseFoodService.updateFood(foodDTO);

      if(imageSelected != null && imageSelected is! LinkImagedData) {
        final path = 'food/${updatedDTO.idCustomUser}/${updatedDTO.id}';

        if (imageSelected.data is WebImageSelectedData) {
          final webImage = imageSelected.data as WebImageSelectedData;

          await _firebaseStorageService.uploadImageFromBytes(bytes: webImage.bytes, path: path);
          final imageLink = await _firebaseStorageService.fetchImageUrl(path);

          final foodWithImage = updatedDTO.copyWith(imageLink: imageLink);
          _firebaseFoodService.updateFood(foodWithImage);
        } else if (imageSelected.data is MobileImageSelectedData) {
          final mobileImage = imageSelected.data as MobileImageSelectedData;

          await _firebaseStorageService.uploadImageFromFile(file: mobileImage.file, path: path);
          final imageLink = await _firebaseStorageService.fetchImageUrl(path);

          final foodWithImage = updatedDTO.copyWith(imageLink: imageLink);
          _firebaseFoodService.updateFood(foodWithImage);
        }
      }

      final updatedFood = Food.mapFoodDTOToFood(updatedDTO);
      return Success(updatedFood);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<RequestStatus> getFoodListByUser(String userId) async {
    try {
      final List<FoodDTO> foodDTOList =
          await _firebaseFoodService.getFoodListByUser(userId);

      final foodList =
          foodDTOList.map((dto) => Food.mapFoodDTOToFood(dto)).toList();

      return Success(foodList);
    } catch (e) {
      return Failure(e);
    }
  }
}
