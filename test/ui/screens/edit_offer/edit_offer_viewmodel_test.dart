import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/domain/entities/categories.dart';
import 'package:offro_cibo/domain/entities/food.dart';
import 'package:offro_cibo/domain/providers/user_provider.dart';
import 'package:offro_cibo/domain/repositories/shop_food_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';
import 'package:offro_cibo/ui/screens/edit_offer/edit_offer_view_model.dart';
import 'package:offro_cibo/ui/utils/ui_error.dart';

import 'edit_offer_viewmodel_test.mocks.dart';

@GenerateMocks([ShopFoodRepositoryApi, UserProviderApi])
void main() {
  late MockShopFoodRepositoryApi mockShopFoodRepository;
  late MockUserProviderApi mockUserProvider;
  late EditOfferViewModel viewModel;
  late Food sampleFood;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    provideDummy<RequestStatus>(Failure(Exception()));
    provideDummy<RequestStatus>(Success(Object));
    mockShopFoodRepository = MockShopFoodRepositoryApi();
    mockUserProvider = MockUserProviderApi();

    viewModel = EditOfferViewModel(
      shopFoodRepository: mockShopFoodRepository,
      userProvider: mockUserProvider,
    );

    sampleFood = Food(
      id: 'food123',
      foodName: 'Pasta Carbonara',
      category: [Categories.pasta],
      quantity: 2,
      date: '25/12/2024',
      restaurantName: 'Trattoria Roma',
      restaurantAddress: 'Via del Corso, 1',
      userId: 'user456',
      imageLink: 'http://example.com/image.png',
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('setDefaultValue', () {
    test('should populate controllers and fields with food data', () {
      viewModel.setDefaultValue(sampleFood);

      expect(viewModel.nameController.text, 'Pasta Carbonara');
      expect(viewModel.portionNumberController.text, '2');
      expect(viewModel.dayController.text, '25');
      expect(viewModel.monthController.text, '12');
      expect(viewModel.yearController.text, '2024');
      expect(viewModel.restaurantNameController.text, 'Trattoria Roma');
      expect(viewModel.restaurantAddressController.text, 'Via del Corso, 1');
      expect(viewModel.selectedCategories, [Categories.pasta]);
      expect(viewModel.imageLinkController, 'http://example.com/image.png');
    });

    test('should set fields to empty or default when food is null', () {
      viewModel.setDefaultValue(null);

      expect(viewModel.nameController.text, '');
      expect(viewModel.portionNumberController.text, '1');
      expect(viewModel.dayController.text, '');
      expect(viewModel.monthController.text, '');
      expect(viewModel.yearController.text, '');
      expect(viewModel.restaurantNameController.text, '');
      expect(viewModel.restaurantAddressController.text, '');
      expect(viewModel.selectedCategories, isEmpty);
      expect(viewModel.imageLinkController, '');
    });
  });

  group('checkBeforeSaveProduct', () {
    test('should fail if user is not logged in', () {
      when(mockUserProvider.getUserId()).thenReturn(null);
      String? receivedError;

      viewModel.checkBeforeSaveProduct(
        onSuccessListener: (food) {},
        onFailureListener: (error) => receivedError = error,
      );

      expect(receivedError, FirebaseUIError.userNotFound.message);
    });

    test('should fail if food name is empty', () {
      when(mockUserProvider.getUserId()).thenReturn('user456');
      String? receivedError;
      viewModel.nameController.text = '';

      viewModel.checkBeforeSaveProduct(
        onSuccessListener: (food) {},
        onFailureListener: (error) => receivedError = error,
      );

      expect(receivedError, UIError.emptyName.message);
    });

    test('should call onSuccess when all conditions are met', () {
      when(mockUserProvider.getUserId()).thenReturn('user456');
      bool onSuccessCalled = false;
      viewModel.setDefaultValue(sampleFood); // Populate with valid data

      viewModel.checkBeforeSaveProduct(
        onSuccessListener: (food) => onSuccessCalled = true,
        onFailureListener: (error) {},
      );

      expect(onSuccessCalled, isTrue);
    });
  });

  group('addProduct', () {
    test('should call onSuccess when repository adds food successfully',
            () async {
          when(mockShopFoodRepository.addFood(any, any))
              .thenAnswer((_) async => Success(true));
          bool onSuccessCalled = false;

          await viewModel.addProduct(
            food: sampleFood,
            onSuccessListener: () => onSuccessCalled = true,
            onFailureListener: (error) {},
          );

          expect(onSuccessCalled, isTrue);
          verify(mockShopFoodRepository.addFood(sampleFood, any)).called(1);
        });

    test('should call onFailure when repository fails to add food', () async {
      when(mockShopFoodRepository.addFood(any, any))
          .thenAnswer((_) async => Failure(Exception('DB error')));
      String? receivedError;

      await viewModel.addProduct(
        food: sampleFood,
        onSuccessListener: () {},
        onFailureListener: (error) => receivedError = error,
      );

      expect(receivedError, isNotNull);
      verify(mockShopFoodRepository.addFood(sampleFood, any)).called(1);
    });
  });

  group('editProduct', () {
    setUp(() {
      when(mockUserProvider.getUserId()).thenReturn('user456');
      viewModel.setDefaultValue(sampleFood);
    });

    test('should fail if offerId is null', () async {
      String? receivedError;

      await viewModel.editProduct(
        offerId: null,
        onSuccessListener: () {},
        onFailureListener: (error) => receivedError = error,
      );

      expect(receivedError, UIError.genericError.message);
    });

    test('should call onSuccess when repository updates food successfully',
            () async {
          when(mockShopFoodRepository.updateFood(any, any))
              .thenAnswer((_) async => Success(true));
          bool onSuccessCalled = false;

          await viewModel.editProduct(
            offerId: 'food123',
            onSuccessListener: () => onSuccessCalled = true,
            onFailureListener: (error) {},
          );

          expect(onSuccessCalled, isTrue);
          verify(mockShopFoodRepository.updateFood(any, any)).called(1);
        });

    test('should call onFailure when repository fails to update food',
            () async {
          when(mockShopFoodRepository.updateFood(any, any))
              .thenAnswer((_) async => Failure(Exception('Update error')));
          String? receivedError;

          await viewModel.editProduct(
            offerId: 'food123',
            onSuccessListener: () {},
            onFailureListener: (error) => receivedError = error,
          );

          expect(receivedError, isNotNull);
          verify(mockShopFoodRepository.updateFood(any, any)).called(1);
        });
  });
}