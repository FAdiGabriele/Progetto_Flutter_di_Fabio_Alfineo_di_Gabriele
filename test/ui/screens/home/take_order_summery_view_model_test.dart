import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/domain/entities/food.dart';
import 'package:offro_cibo/domain/providers/user_provider.dart';
import 'package:offro_cibo/domain/repositories/take_food_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';
import 'package:offro_cibo/ui/screens/home/take_order_summary_screen/take_order_summery_view_model.dart';
import 'package:offro_cibo/ui/utils/ui_error.dart';

import 'take_order_summery_view_model_test.mocks.dart';

@GenerateMocks([TakeFoodRepositoryApi, UserProviderApi])
void main() {
  late MockTakeFoodRepositoryApi mockTakeFoodRepository;
  late MockUserProviderApi mockUserProvider;
  late TakeOrderSummeryViewModel viewModel;

  setUp(() {
    provideDummy<RequestStatus>(Failure(Exception()));
    provideDummy<RequestStatus>(Success(Object));
    mockTakeFoodRepository = MockTakeFoodRepositoryApi();
    mockUserProvider = MockUserProviderApi();
    viewModel = TakeOrderSummeryViewModel(
      takeFoodRepository: mockTakeFoodRepository,
      userProvider: mockUserProvider,
    );
  });

  final sampleFood = Food(
    id: 'food-123',
    foodName: 'Lasagna',
    category: [],
    quantity: 2,
    date: '25/07/2025',
    restaurantName: 'Ristorante da Mario',
    restaurantAddress: 'Via Roma 10',
    userId: 'user-abc',
    imageLink: '',
  );

  const testUserId = 'current-user-456';

  group('takeOrder', () {
    test('should call onSuccess when user is logged in and repository succeeds',
            () async {
          when(mockUserProvider.getUserId()).thenReturn(testUserId);
          when(mockTakeFoodRepository.takeFood(
            foodId: sampleFood.id!,
            portions: sampleFood.quantity,
            userId: testUserId,
          )).thenAnswer((_) async => Success(null));

          bool successCalled = false;
          String? errorReceived;

          await viewModel.takeOrder(
            food: sampleFood,
            onSuccessListener: () => successCalled = true,
            onFailureListener: (error) => errorReceived = error,
          );

          expect(successCalled, isTrue);
          expect(errorReceived, isNull);
          verify(mockUserProvider.getUserId()).called(1);
          verify(mockTakeFoodRepository.takeFood(
            foodId: sampleFood.id!,
            portions: sampleFood.quantity,
            userId: testUserId,
          )).called(1);
        });

    test('should call onFailure when user is not logged in', () async {
      when(mockUserProvider.getUserId()).thenReturn(null);
      String? errorReceived;

      await viewModel.takeOrder(
        food: sampleFood,
        onSuccessListener: () {},
        onFailureListener: (error) => errorReceived = error,
      );

      expect(errorReceived, FirebaseUIError.userNotFound.message);
      verify(mockUserProvider.getUserId()).called(1);
      verifyNever(mockTakeFoodRepository.takeFood(
          foodId: anyNamed('foodId'),
          portions: anyNamed('portions'),
          userId: anyNamed('userId')));
    });

    test('should call onFailure when food ID is null', () async {
      final foodWithNullId = Food(
        id: null,
        foodName: 'Test Food',
        category: [],
        quantity: 1,
        date: '25/07/2025',
        restaurantName: 'Test',
        restaurantAddress: 'Test Address',
        userId: 'user-abc',
        imageLink: '',
      );
      when(mockUserProvider.getUserId()).thenReturn(testUserId);
      String? errorReceived;

      await viewModel.takeOrder(
        food: foodWithNullId,
        onSuccessListener: () {},
        onFailureListener: (error) => errorReceived = error,
      );

      expect(errorReceived, UIError.genericError.message);
      verify(mockUserProvider.getUserId()).called(1);
      verifyNever(mockTakeFoodRepository.takeFood(
          foodId: anyNamed('foodId'),
          portions: anyNamed('portions'),
          userId: anyNamed('userId')));
    });

    test('should call onFailure when repository returns a Failure', () async {
      final exception = Exception('Network error');
      when(mockUserProvider.getUserId()).thenReturn(testUserId);
      when(mockTakeFoodRepository.takeFood(
        foodId: sampleFood.id!,
        portions: sampleFood.quantity,
        userId: testUserId,
      )).thenAnswer((_) async => Failure(exception));

      bool successCalled = false;
      String? errorReceived;

      await viewModel.takeOrder(
        food: sampleFood,
        onSuccessListener: () => successCalled = true,
        onFailureListener: (error) => errorReceived = error,
      );

      expect(successCalled, isFalse);
      expect(errorReceived, isNotNull);
      verify(mockTakeFoodRepository.takeFood(
        foodId: sampleFood.id!,
        portions: sampleFood.quantity,
        userId: testUserId,
      )).called(1);
    });
  });
}