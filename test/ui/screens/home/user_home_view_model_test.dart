import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/domain/entities/categories.dart';
import 'package:offro_cibo/domain/entities/food.dart';
import 'package:offro_cibo/domain/providers/user_provider.dart';
import 'package:offro_cibo/domain/repositories/auth_repository.dart';
import 'package:offro_cibo/domain/repositories/user_food_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';
import 'package:offro_cibo/ui/screens/home/user_home_content_screen/user_home_view_model.dart';
import 'package:offro_cibo/ui/utils/ui_error.dart';
import 'package:offro_cibo/ui/utils/ui_request_status.dart';

import 'user_home_view_model_test.mocks.dart';

@GenerateMocks([AuthRepositoryApi, UserFoodRepositoryApi, UserProviderApi])
void main() {
  late MockAuthRepositoryApi mockAuthRepository;
  late MockUserFoodRepositoryApi mockUserFoodRepository;
  late MockUserProviderApi mockUserProvider;
  late UserHomeViewModel viewModel;

  setUp(() {
    provideDummy<RequestStatus>(Failure(Exception()));
    provideDummy<RequestStatus>(Success(Object));
    mockAuthRepository = MockAuthRepositoryApi();
    mockUserFoodRepository = MockUserFoodRepositoryApi();
    mockUserProvider = MockUserProviderApi();
    viewModel = UserHomeViewModel(
      authRepository: mockAuthRepository,
      userFoodRepository: mockUserFoodRepository,
      userProvider: mockUserProvider,
    );
  });

  group('searchFood', () {
    final foodList = [
      Food(
          id: '1',
          foodName: 'Pizza',
          category: [Categories.pizza],
          quantity: 1,
          date: '25/12/2025',
          restaurantName: 'Pizzeria Napoli',
          restaurantAddress: 'Via Roma, 1',
          userId: 'shop-1',
          imageLink: '')
    ];
    const query = 'piz';
    final categories = [Categories.pizza];

    test('should update status to ShowData on successful search', () async {
      final listener = Listener();
      viewModel.addListener(listener);
      when(mockUserFoodRepository.searchFood(
              queryText: query, categories: categories))
          .thenAnswer((_) async => Success(foodList));

      await viewModel.searchFood(query, categories);

      expect(viewModel.userResultsUiRequestStatus, isA<ShowData>());
      final data =
          (viewModel.userResultsUiRequestStatus as ShowData).data as List<Food>;
      expect(data, foodList);
      verify(listener.call()).called(2);
    });

    test('should update status to ShowError on search failure', () async {
      final listener = Listener();
      viewModel.addListener(listener);
      final exception = Exception('Search failed');
      when(mockUserFoodRepository.searchFood(
              queryText: query, categories: categories))
          .thenAnswer((_) async => Failure(exception));

      await viewModel.searchFood(query, categories);

      expect(viewModel.userResultsUiRequestStatus, isA<ShowError>());
      final error = (viewModel.userResultsUiRequestStatus as ShowError).error;
      expect(error, exception);
      verify(listener.call()).called(2);
    });
  });

  group('getFoodCounter', () {
    const testUserId = 'user-123';
    test('should update status to ShowData on successful count fetch',
        () async {
      when(mockUserProvider.getUserId()).thenReturn(testUserId);
      when(mockUserFoodRepository.getFoodCounter(userId: testUserId))
          .thenAnswer((_) async => Success(5));

      await viewModel.getFoodCounter();

      expect(viewModel.userCounterUiRequestStatus, isA<ShowData>());
      final count = (viewModel.userCounterUiRequestStatus as ShowData).data;
      expect(count, 5);
    });

    test('should update status to ShowError when user ID is null', () async {
      when(mockUserProvider.getUserId()).thenReturn(null);

      await viewModel.getFoodCounter();

      expect(viewModel.userCounterUiRequestStatus, isA<ShowError>());
      final error = (viewModel.userCounterUiRequestStatus as ShowError).error;
      expect(error, UIError.genericError.message);
      verifyNever(
          mockUserFoodRepository.getFoodCounter(userId: anyNamed('userId')));
    });

    test('should update status to ShowError on repository failure', () async {
      final exception = Exception('Counter failed');
      when(mockUserProvider.getUserId()).thenReturn(testUserId);
      when(mockUserFoodRepository.getFoodCounter(userId: testUserId))
          .thenAnswer((_) async => Failure(exception));

      await viewModel.getFoodCounter();

      expect(viewModel.userCounterUiRequestStatus, isA<ShowError>());
      final error = (viewModel.userCounterUiRequestStatus as ShowError).error;
      expect(error, exception);
    });
  });

  group('logout', () {
    test('should call onSuccessListener on successful logout', () async {
      when(mockAuthRepository.logout()).thenAnswer((_) async => Success(null));
      bool successCalled = false;
      String? errorReceived;

      await viewModel.logout(
        onSuccessListener: () => successCalled = true,
        onFailureListener: (error) => errorReceived = error,
      );

      expect(successCalled, isTrue);
      expect(errorReceived, isNull);
      verify(mockAuthRepository.logout()).called(1);
    });

    test('should call onFailureListener on logout failure', () async {
      final exception = Exception('Logout failed');
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => Failure(exception));
      bool successCalled = false;
      String? errorReceived;

      await viewModel.logout(
        onSuccessListener: () => successCalled = true,
        onFailureListener: (error) => errorReceived = error,
      );

      expect(successCalled, isFalse);
      expect(errorReceived, isNotNull);
      verify(mockAuthRepository.logout()).called(1);
    });
  });
}

class Listener extends Mock {
  void call();
}
