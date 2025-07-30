import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/domain/entities/food.dart';
import 'package:offro_cibo/domain/repositories/auth_repository.dart';
import 'package:offro_cibo/domain/repositories/shop_food_repository.dart';
import 'package:offro_cibo/domain/providers/user_provider.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';
import 'package:offro_cibo/ui/screens/home/shop_home_content_screen/shop_home_view_model.dart';
import 'package:offro_cibo/ui/utils/ui_error.dart';
import 'package:offro_cibo/ui/utils/ui_request_status.dart';

import 'shop_home_viewmodel_test.mocks.dart';

@GenerateMocks([AuthRepositoryApi, ShopFoodRepositoryApi, UserProviderApi])
void main() {
  late MockAuthRepositoryApi mockAuthRepository;
  late MockShopFoodRepositoryApi mockShopFoodRepository;
  late MockUserProviderApi mockUserProvider;
  late ShopHomeViewModel viewModel;

  const testUserId = 'user-123';
  const testOfferId = 'offer-456';

  setUp(() {
    provideDummy<RequestStatus>(Failure(Exception()));
    provideDummy<RequestStatus>(Success(Object));
    mockAuthRepository = MockAuthRepositoryApi();
    mockShopFoodRepository = MockShopFoodRepositoryApi();
    mockUserProvider = MockUserProviderApi();
  });

  Future<void> createViewModel() async {
    viewModel = ShopHomeViewModel(
      authRepository: mockAuthRepository,
      shopFoodRepository: mockShopFoodRepository,
      userProvider: mockUserProvider,
    );
    await Future.delayed(Duration.zero);
  }

  group('Initialization (_getShopOffers)', () {
    test(
        'should set status to ShowData when user is found and repository returns food list',
        () async {
      final foodList = [
        Food(
            id: '1',
            foodName: 'Test Food',
            category: [],
            quantity: 1,
            date: '25/07/2025',
            restaurantName: 'Test',
            restaurantAddress: 'Test Address',
            userId: testUserId,
            imageLink: '')
      ];
      when(mockUserProvider.getUserId()).thenReturn(testUserId);
      when(mockShopFoodRepository.getFoodListByUser(testUserId))
          .thenAnswer((_) async => Success(foodList));

      await createViewModel();

      expect(viewModel.shopOffersUiRequestStatus, isA<ShowData>());
      final data =
          (viewModel.shopOffersUiRequestStatus as ShowData).data as List<Food>;
      expect(data, foodList);
      verify(mockUserProvider.getUserId()).called(1);
      verify(mockShopFoodRepository.getFoodListByUser(testUserId)).called(1);
    });

    test('should set status to ShowError when user is not found', () async {
      when(mockUserProvider.getUserId()).thenReturn(null);

      await createViewModel();

      expect(viewModel.shopOffersUiRequestStatus, isA<ShowError>());
      final error = (viewModel.shopOffersUiRequestStatus as ShowError).error;
      expect(error, FirebaseUIError.userNotFound);
      verify(mockUserProvider.getUserId()).called(1);
      verifyNever(mockShopFoodRepository.getFoodListByUser(any));
    });

    test('should set status to ShowError when repository returns a failure',
        () async {
      final exception = Exception('Database error');
      when(mockUserProvider.getUserId()).thenReturn(testUserId);
      when(mockShopFoodRepository.getFoodListByUser(testUserId))
          .thenAnswer((_) async => Failure(exception));

      await createViewModel();

      expect(viewModel.shopOffersUiRequestStatus, isA<ShowError>());
      final error = (viewModel.shopOffersUiRequestStatus as ShowError).error;
      expect(error, exception);
    });
  });

  group('deleteOffer', () {
    setUp(() {
      when(mockUserProvider.getUserId()).thenReturn(testUserId);
      when(mockShopFoodRepository.getFoodListByUser(any))
          .thenAnswer((_) async => Success([]));
      viewModel = ShopHomeViewModel(
        authRepository: mockAuthRepository,
        shopFoodRepository: mockShopFoodRepository,
        userProvider: mockUserProvider,
      );
    });

    test('should call onSuccess when deletion is successful', () async {
      when(mockShopFoodRepository.deleteFood(testOfferId))
          .thenAnswer((_) async => Success(null));
      bool successCalled = false;
      String? errorReceived;

      await viewModel.deleteOffer(
        offerId: testOfferId,
        onSuccessListener: () => successCalled = true,
        onFailureListener: (error) => errorReceived = error,
      );

      expect(successCalled, isTrue);
      expect(errorReceived, isNull);
      verify(mockShopFoodRepository.deleteFood(testOfferId)).called(1);
    });

    test('should call onFailure when deletion fails', () async {
      final exception = Exception('Deletion failed');
      when(mockShopFoodRepository.deleteFood(testOfferId))
          .thenAnswer((_) async => Failure(exception));
      bool successCalled = false;
      String? errorReceived;

      await viewModel.deleteOffer(
        offerId: testOfferId,
        onSuccessListener: () => successCalled = true,
        onFailureListener: (error) => errorReceived = error,
      );

      expect(successCalled, isFalse);
      expect(errorReceived, isNotNull);
      verify(mockShopFoodRepository.deleteFood(testOfferId)).called(1);
    });

    test('should call onFailure when offerId is null', () async {
      String? errorReceived;

      await viewModel.deleteOffer(
        offerId: null,
        onSuccessListener: () {},
        onFailureListener: (error) => errorReceived = error,
      );

      expect(errorReceived, UIError.genericError.message);
      verifyNever(mockShopFoodRepository.deleteFood(any));
    });
  });

  group('logout', () {
    setUp(() {
      when(mockUserProvider.getUserId()).thenReturn(testUserId);
      when(mockShopFoodRepository.getFoodListByUser(any))
          .thenAnswer((_) async => Success([]));
      viewModel = ShopHomeViewModel(
        authRepository: mockAuthRepository,
        shopFoodRepository: mockShopFoodRepository,
        userProvider: mockUserProvider,
      );
    });

    test('should call onSuccess when logout is successful', () async {
      when(mockAuthRepository.logout()).thenAnswer((_) async => Success(null));
      bool successCalled = false;

      await viewModel.logout(
        onSuccessListener: () => successCalled = true,
        onFailureListener: (error) {},
      );

      expect(successCalled, isTrue);
      verify(mockAuthRepository.logout()).called(1);
    });

    test('should call onFailure when logout fails', () async {
      final exception = Exception('Logout failed');
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => Failure(exception));
      String? errorReceived;

      await viewModel.logout(
        onSuccessListener: () {},
        onFailureListener: (error) => errorReceived = error,
      );

      expect(errorReceived, isNotNull);
      verify(mockAuthRepository.logout()).called(1);
    });
  });
}
