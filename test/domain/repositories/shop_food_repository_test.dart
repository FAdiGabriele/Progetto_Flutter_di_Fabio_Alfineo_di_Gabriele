import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/data/data_sources/firebase_firestore_food_service.dart';
import 'package:offro_cibo/data/data_sources/firebase_storage_service.dart';
import 'package:offro_cibo/data/models/food_dto.dart';
import 'package:offro_cibo/domain/entities/categories.dart';
import 'package:offro_cibo/domain/entities/food.dart';
import 'package:offro_cibo/domain/repositories/shop_food_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';
import 'package:offro_cibo/ui/screens/edit_offer/utils/image_picker_notifier.dart';

import 'shop_food_repository_test.mocks.dart';

@GenerateMocks([FirebaseFirestoreFoodServiceApi, FirebaseStorageServiceApi])
void main() {
  late ShopFoodRepository shopFoodRepository;
  late MockFirebaseFirestoreFoodServiceApi mockFirebaseFoodService;
  late MockFirebaseStorageServiceApi mockFirebaseStorageService;

  setUp(() {
    mockFirebaseFoodService = MockFirebaseFirestoreFoodServiceApi();
    mockFirebaseStorageService = MockFirebaseStorageServiceApi();
    shopFoodRepository = ShopFoodRepository(
      firebaseFoodService: mockFirebaseFoodService,
      firebaseStorageService: mockFirebaseStorageService,
    );
  });

  final now = DateTime.now().toString();
  final firebaseException = Exception('Firebase error');
  const foodId = 'food123';
  const userId = 'user123';

  final pizzaFoodExample = Food(
    foodName: 'New Delicious Pizza',
    category: [Categories.pizza, Categories.vegan],
    quantity: 1,
    date: now,
    restaurantName: 'Awesome Pizza Place',
    restaurantAddress: '123 Main St',
    userId: userId,
    imageLink: '',
  );

  final pizzaFoodDTOExample = FoodDTO(
    id: foodId,
    foodName: pizzaFoodExample.foodName,
    category: pizzaFoodExample.category.map((c) => c.id).toList(),
    quantity: pizzaFoodExample.quantity,
    date: pizzaFoodExample.date,
    restaurantName: pizzaFoodExample.restaurantName,
    restaurantAddress: pizzaFoodExample.restaurantAddress,
    idCustomUser: pizzaFoodExample.userId,
    imageLink: pizzaFoodExample.imageLink,
  );

  final baseBurgerFoodExample = Food(
    id: foodId,
    foodName: 'Updated Super Burger',
    category: [Categories.meat, Categories.fries],
    quantity: 1,
    date: now,
    restaurantName: 'Burger Palace',
    restaurantAddress: '789 Oak Ave',
    userId: userId,
    imageLink: '',
  );

  final updatedBurgerFoodDTOExample = FoodDTO(
    id: foodId,
    foodName: 'Classic Burger',
    category: [Categories.meat.id],
    quantity: 2,
    date: now,
    restaurantName: 'Burger Shack',
    restaurantAddress: '456 Oak Ave',
    idCustomUser: userId,
    imageLink: '',
  );

  final foodList = [
    Food.mapFoodDTOToFood(updatedBurgerFoodDTOExample),
    Food(
      id: 'food456',
      foodName: 'Salad Bowl',
      category: [Categories.vegan, Categories.pasta],
      quantity: 1,
      date: now,
      restaurantName: 'Green Eats',
      restaurantAddress: '789 Pine Ln',
      userId: userId,
      imageLink: '',
    ),
  ];

  final foodDTOList =
  foodList.map((food) => FoodDTO.mapEntityToFoodDTO(food)).toList();

  group('addFood', () {
    test('should return Success with Food when adding food without an image', () async {
      // Arrange
      when(mockFirebaseFoodService.addFood(any)).thenAnswer((_) async => pizzaFoodDTOExample);

      // Act
      final result = await shopFoodRepository.addFood(pizzaFoodExample, null);

      // Assert
      verify(mockFirebaseFoodService.addFood(captureAny)).called(1);
      verifyZeroInteractions(mockFirebaseStorageService);
      expect(result, isA<Success>());
      expect((result as Success).data, Food.mapFoodDTOToFood(pizzaFoodDTOExample));
    });

    test('should successfully upload a mobile image and update the food document', () async {
      // Arrange
      final tMobileFile = MockFile();
      final tImageSelected = ImageSelectedWrapper(data: MobileImageSelectedData(tMobileFile));
      const tImageUrl = 'http://example.com/mobile_image.jpg';
      final tPath = 'food/${pizzaFoodDTOExample.idCustomUser}/${pizzaFoodDTOExample.id}';
      final tFoodWithImageDTO = pizzaFoodDTOExample.copyWith(imageLink: tImageUrl);

      when(mockFirebaseFoodService.addFood(any)).thenAnswer((_) async => pizzaFoodDTOExample);
      when(mockFirebaseStorageService.uploadImageFromFile(file: tMobileFile, path: tPath))
          .thenAnswer((_) async => 'newLink');
      when(mockFirebaseStorageService.fetchImageUrl(tPath)).thenAnswer((_) async => tImageUrl);
      when(mockFirebaseFoodService.updateFood(any)).thenAnswer((_) async => tFoodWithImageDTO);

      // Act
      final result = await shopFoodRepository.addFood(pizzaFoodExample, tImageSelected);

      // Assert
      verifyInOrder([
        mockFirebaseFoodService.addFood(captureAny),
        mockFirebaseStorageService.uploadImageFromFile(file: tMobileFile, path: tPath),
        mockFirebaseStorageService.fetchImageUrl(tPath),
        mockFirebaseFoodService.updateFood(tFoodWithImageDTO)
      ]);
      expect(result, isA<Success>());
    });

    test('should successfully upload a web image and update the food document', () async {
      // Arrange
      final tWebBytes = Uint8List.fromList([10, 20, 30]);
      final tImageSelected = ImageSelectedWrapper(data: WebImageSelectedData(tWebBytes));
      const tImageUrl = 'http://example.com/web_image.jpg';
      final tPath = 'food/${pizzaFoodDTOExample.idCustomUser}/${pizzaFoodDTOExample.id}';
      final tFoodWithImageDTO = pizzaFoodDTOExample.copyWith(imageLink: tImageUrl);

      when(mockFirebaseFoodService.addFood(any)).thenAnswer((_) async => pizzaFoodDTOExample);
      when(mockFirebaseStorageService.uploadImageFromBytes(bytes: tWebBytes, path: tPath))
          .thenAnswer((_) async => 'newLink');
      when(mockFirebaseStorageService.fetchImageUrl(tPath)).thenAnswer((_) async => tImageUrl);
      when(mockFirebaseFoodService.updateFood(any)).thenAnswer((_) async => tFoodWithImageDTO);

      // Act
      final result = await shopFoodRepository.addFood(pizzaFoodExample, tImageSelected);

      // Assert
      verifyInOrder([
        mockFirebaseFoodService.addFood(captureAny),
        mockFirebaseStorageService.uploadImageFromBytes(bytes: tWebBytes, path: tPath),
        mockFirebaseStorageService.fetchImageUrl(tPath),
        mockFirebaseFoodService.updateFood(tFoodWithImageDTO)
      ]);
      expect(result, isA<Success>());
    });

    test('should return Failure when the initial food creation throws an exception', () async {
      // Arrange
      when(mockFirebaseFoodService.addFood(any)).thenThrow(firebaseException);

      // Act
      final result = await shopFoodRepository.addFood(pizzaFoodExample, null);

      // Assert
      verify(mockFirebaseFoodService.addFood(captureAny)).called(1);
      verifyZeroInteractions(mockFirebaseStorageService);
      expect(result, isA<Failure>());
      expect((result as Failure).error, firebaseException);
    });

    test('should return Failure when mobile image upload throws an exception', () async {
      // Arrange
      final tMobileFile = MockFile();
      final tImageSelected = ImageSelectedWrapper(data: MobileImageSelectedData(tMobileFile));
      final tPath = 'food/${pizzaFoodDTOExample.idCustomUser}/${pizzaFoodDTOExample.id}';

      when(mockFirebaseFoodService.addFood(any)).thenAnswer((_) async => pizzaFoodDTOExample);
      when(mockFirebaseStorageService.uploadImageFromFile(file: tMobileFile, path: tPath))
          .thenThrow(firebaseException);

      // Act
      final result = await shopFoodRepository.addFood(pizzaFoodExample, tImageSelected);

      // Assert
      verify(mockFirebaseFoodService.addFood(captureAny)).called(1);
      verify(mockFirebaseStorageService.uploadImageFromFile(file: tMobileFile, path: tPath)).called(1);
      verifyNever(mockFirebaseStorageService.fetchImageUrl(any));
      verifyNever(mockFirebaseFoodService.updateFood(any));
      expect(result, isA<Failure>());
      expect((result as Failure).error, firebaseException);
    });
  });

  group('deleteFood', () {
    test(
        'should return Success<bool> with true when firebaseFoodService.deleteFood is successful',
        () async {
      when(mockFirebaseFoodService.deleteFood(captureAny))
          .thenAnswer((_) async => true);

      final result = await shopFoodRepository.deleteFood(foodId);

      verify(mockFirebaseFoodService.deleteFood(foodId)).called(1);
      expect(result, isA<Success>());
      if (result is Success) {
        expect(result.data, true);
      }
    });

    test(
        'should return Success<bool> with false when firebaseFoodService.deleteFood returns false',
        () async {
      when(mockFirebaseFoodService.deleteFood(captureAny))
          .thenAnswer((_) async => false);

      final result = await shopFoodRepository.deleteFood(foodId);

      verify(mockFirebaseFoodService.deleteFood(foodId)).called(1);
      expect(result, isA<Success>());
      if (result is Success) {
        expect(result.data, false);
      }
    });

    test(
        'should return Failure when firebaseFoodService.deleteFood throws an exception',
        () async {
      when(mockFirebaseFoodService.deleteFood(captureAny))
          .thenThrow(firebaseException);

      final result = await shopFoodRepository.deleteFood(foodId);

      verify(mockFirebaseFoodService.deleteFood(foodId)).called(1);
      expect(result, isA<Failure>());
      if (result is Failure) {
        expect(result.error, firebaseException);
      }
    });
  });

  group('getFood', () {
    test(
        'should return Success<Food> when firebaseFoodService.getFood is successful',
        () async {
      when(mockFirebaseFoodService.getFood(captureAny))
          .thenAnswer((_) async => updatedBurgerFoodDTOExample);

      final result = await shopFoodRepository.getFood(foodId);

      verify(mockFirebaseFoodService.getFood(foodId)).called(1);
      expect(result, isA<Success>());
      if (result is Success) {
        expect(result.data, Food.mapFoodDTOToFood(updatedBurgerFoodDTOExample));
      }
    });

    test(
        'should return Failure when firebaseFoodService.getFood throws an exception',
        () async {
      when(mockFirebaseFoodService.getFood(captureAny))
          .thenThrow(firebaseException);

      final result = await shopFoodRepository.getFood(foodId);

      verify(mockFirebaseFoodService.getFood(foodId)).called(1);
      expect(result, isA<Failure>());
      if (result is Failure) {
        expect(result.error, firebaseException);
      }
    });
  });

  group('updateFood', () {
    test(
        'should call firebaseFoodService.updateFood with mapped DTO and return Success<Food> on successful update',
        () async {
      when(mockFirebaseFoodService.updateFood(captureAny))
          .thenAnswer((_) async => updatedBurgerFoodDTOExample);

      final result = await shopFoodRepository.updateFood(baseBurgerFoodExample, null);
      verify(mockFirebaseFoodService
              .updateFood(FoodDTO.mapEntityToFoodDTO(baseBurgerFoodExample)))
          .called(1);

      expect(result, isA<Success>());

      if (result is Success) {
        expect(result.data, Food.mapFoodDTOToFood(updatedBurgerFoodDTOExample));
      }
    });

    test(
        'should return Failure when firebaseFoodService.updateFood throws an exception',
        () async {
      when(mockFirebaseFoodService.updateFood(captureAny))
          .thenThrow(firebaseException);

      final result = await shopFoodRepository.updateFood(baseBurgerFoodExample, null);

      verify(mockFirebaseFoodService
              .updateFood(FoodDTO.mapEntityToFoodDTO(baseBurgerFoodExample)))
          .called(1);

      expect(result, isA<Failure>());
      if (result is Failure) {
        expect(result.error, firebaseException);
      }
    });

    test('should correctly map Food entity to FoodDTO before calling service',
        () async {
      when(mockFirebaseFoodService.updateFood(captureAny))
          .thenAnswer((_) async => updatedBurgerFoodDTOExample);

      await shopFoodRepository.updateFood(baseBurgerFoodExample, null);

      final captured =
          verify(mockFirebaseFoodService.updateFood(captureAny)).captured;
      expect(captured.length, 1);
      final capturedDto = captured.first as FoodDTO;

      expect(capturedDto.id, baseBurgerFoodExample.id);
      expect(capturedDto.foodName, baseBurgerFoodExample.foodName);
      expect(capturedDto.category,
          baseBurgerFoodExample.category.map((c) => c.id).toList());
      expect(capturedDto.quantity, baseBurgerFoodExample.quantity);
      expect(capturedDto.idCustomUser, baseBurgerFoodExample.userId);
    });

    test(
        'should correctly map updated FoodDTO from service back to Food entity',
        () async {
      when(mockFirebaseFoodService.updateFood(captureAny))
          .thenAnswer((_) async => updatedBurgerFoodDTOExample);

      final result = await shopFoodRepository.updateFood(baseBurgerFoodExample, null);

      expect(result, isA<Success>());
      if (result is Success) {
        final actualFoodEntity = result.data as Food;
        expect(actualFoodEntity.id, updatedBurgerFoodDTOExample.id);
        expect(actualFoodEntity.foodName, updatedBurgerFoodDTOExample.foodName);
        expect(actualFoodEntity.userId,
            updatedBurgerFoodDTOExample.idCustomUser);
      }
    });
  });

  group('getFoodListByUser', () {
    test(
        'should call firebaseFoodService.getFoodListByUser with correct userId and return Success<List<Food>> on success',
        () async {
      when(mockFirebaseFoodService.getFoodListByUser(captureAny))
          .thenAnswer((_) async => foodDTOList);

      final expectedList =
          foodDTOList.map((food) => Food.mapFoodDTOToFood(food)).toList();

      final result = await shopFoodRepository.getFoodListByUser(userId);

      verify(mockFirebaseFoodService.getFoodListByUser(userId)).called(1);

      expect(result, isA<Success>());

      if (result is Success) {
        final actualFoodList = result.data as List<Food>;

        for (int i = 0; i < actualFoodList.length; i++) {
          expect(actualFoodList[i], expectedList[i]);
        }
      }
    });

    test(
        'should return Success with an empty list if firebaseFoodService.getFoodListByUser returns an empty list',
        () async {
      when(mockFirebaseFoodService.getFoodListByUser(captureAny))
          .thenAnswer((_) async => []);

      final result = await shopFoodRepository.getFoodListByUser(userId);

      verify(mockFirebaseFoodService.getFoodListByUser(userId)).called(1);
      expect(result, isA<Success>());
      if (result is Success) {
        final actualFoodList = result.data as List<Food>;
        expect(actualFoodList, isEmpty);
      }
    });

    test(
        'should return Failure when firebaseFoodService.getFoodListByUser throws an exception',
        () async {
      when(mockFirebaseFoodService.getFoodListByUser(captureAny))
          .thenThrow(firebaseException);

      final result = await shopFoodRepository.getFoodListByUser(userId);

      verify(mockFirebaseFoodService.getFoodListByUser(userId)).called(1);

      expect(result, isA<Failure>());

      if (result is Failure) {
        expect(result.error, firebaseException);
      }
    });

    test(
        'should correctly map each FoodDTO in the list from service to a Food entity',
        () async {
      when(mockFirebaseFoodService.getFoodListByUser(captureAny))
          .thenAnswer((_) async => foodDTOList);

      final expectedList =
          foodDTOList.map((food) => Food.mapFoodDTOToFood(food)).toList();

      final result = await shopFoodRepository.getFoodListByUser(userId);

      verify(mockFirebaseFoodService.getFoodListByUser(userId)).called(1);

      expect(result, isA<Success>());
      if (result is Success) {
        final actualFoodList = result.data as List<Food>;
        expect(actualFoodList.length, foodDTOList.length);

        for (int i = 0; i < actualFoodList.length; i++) {
          expect(actualFoodList[i], expectedList[i]);
        }
      }
    });
  });
}

class MockFile extends Mock implements File {}
