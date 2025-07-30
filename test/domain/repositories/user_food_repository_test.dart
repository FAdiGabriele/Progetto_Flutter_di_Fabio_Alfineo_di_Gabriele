import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/data/data_sources/firebase_firestore_food_service.dart';
import 'package:offro_cibo/data/data_sources/firebase_firestore_user_service.dart';
import 'package:offro_cibo/data/models/food_dto.dart';
import 'package:offro_cibo/domain/entities/categories.dart';
import 'package:offro_cibo/domain/entities/food.dart';
import 'package:offro_cibo/domain/repositories/user_food_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';

import 'auth_repository_test.mocks.dart';
import 'shop_food_repository_test.mocks.dart';

@GenerateMocks(
    [FirebaseFirestoreFoodServiceApi, FirebaseFirestoreUserServiceApi])
void main() {
  late UserFoodRepository userFoodRepository;
  late MockFirebaseFirestoreFoodServiceApi mockFirebaseFoodService;
  late MockFirebaseFirestoreUserServiceApi mockFirebaseUserService;

  setUp(() {
    mockFirebaseFoodService = MockFirebaseFirestoreFoodServiceApi();
    mockFirebaseUserService = MockFirebaseFirestoreUserServiceApi();
    userFoodRepository = UserFoodRepository(
        firebaseFoodService: mockFirebaseFoodService,
        firebaseUserService: mockFirebaseUserService);
  });

  final String currentDate = DateTime.now().toString();
  const queryText = 'piz';
  const categoryIds = [Categories.pizza];
  final tException = Exception('Network error');

  final tFoodDTOListFromService = [
    FoodDTO(
      id: 'dto_001',
      foodName: 'Pizza Dolce Teramana',
      category: ['sweets'],
      quantity: 1,
      date: currentDate,
      restaurantName: 'Tony\'s Place',
      restaurantAddress: '123 Main St',
      idCustomUser: 'user_abc',
      imageLink: '',
    ),
    FoodDTO(
      id: 'dto_002',
      foodName: 'Margherita',
      category: [
        'pizza',
      ],
      quantity: 5,
      date: currentDate,
      restaurantName: 'The Snack Shack',
      restaurantAddress: '456 Oak Ave',
      idCustomUser: 'user_def',
      imageLink: '',
    ),
    FoodDTO(
      id: 'dto_003',
      foodName: 'Carbonara',
      category: ['pasta'],
      quantity: 1,
      date: currentDate,
      restaurantName: 'Luigi\'s Authentic Pizza & Pasta',
      restaurantAddress: '789 Pine Rd',
      idCustomUser: 'user_ghi',
      imageLink: '',
    ),
    FoodDTO(
      id: 'dto_004',
      foodName: 'Salad',
      category: ['vegan'],
      quantity: 1,
      date: currentDate,
      restaurantName: 'Green Leaf Cafe',
      restaurantAddress: '101 Health Blvd',
      idCustomUser: 'user_jkl',
      imageLink: '',
    ),
    FoodDTO(
      id: 'dto_005',
      foodName: 'Beef Burger',
      category: ['meat'],
      quantity: 1,
      date: currentDate,
      restaurantName: 'Burger Joint',
      restaurantAddress: '202 Fast Food Ln',
      idCustomUser: 'user_mno',
      imageLink: '',
    )
  ];

  final tExpectedFoodEntityList =
      tFoodDTOListFromService.map((dto) => Food.mapFoodDTOToFood(dto)).toList();

  group('UserFoodRepository', () {
    group('searchFood', () {
      test(
          'should call firebaseFoodService.searchFood with correct parameters '
          'and return Success<List<Food>> on successful data fetch and mapping',
          () async {
        when(mockFirebaseFoodService.searchFood(
          queryText: anyNamed("queryText"),
          categoryIds: anyNamed("categoryIds"),
        )).thenAnswer((_) async => tFoodDTOListFromService);

        final result = await userFoodRepository.searchFood(
          queryText: queryText,
          categories: categoryIds,
        );

        verify(mockFirebaseFoodService.searchFood(
          queryText: anyNamed("queryText"),
          categoryIds: anyNamed("categoryIds"),
        )).called(1);

        expect(result, isA<Success>());

        if (result is Success) {
          expect(listEquals(result.data as List<Food>, tExpectedFoodEntityList),
              isTrue);
        }
      });

      test(
          'should return Success with an empty list if service returns an empty DTO list',
          () async {
        when(mockFirebaseFoodService.searchFood(
          queryText: anyNamed("queryText"),
          categoryIds: anyNamed("categoryIds"),
        )).thenAnswer((_) async => []);

        final result = await userFoodRepository.searchFood(
          queryText: queryText,
          categories: categoryIds,
        );

        verify(mockFirebaseFoodService.searchFood(
          queryText: anyNamed("queryText"),
          categoryIds: anyNamed("categoryIds"),
        )).called(1);
        expect(result, isA<Success>());
        if (result is Success) {
          expect(result.data, isEmpty);
        }
      });

      test(
          'should return Failure when firebaseFoodService.searchFood throws an exception',
          () async {
        when(mockFirebaseFoodService.searchFood(
          queryText: anyNamed("queryText"),
          categoryIds: anyNamed("categoryIds"),
        )).thenThrow(tException);

        final result = await userFoodRepository.searchFood(
          queryText: queryText,
          categories: categoryIds,
        );

        verify(mockFirebaseFoodService.searchFood(
          queryText: anyNamed("queryText"),
          categoryIds: anyNamed("categoryIds"),
        )).called(1);
        expect(result, isA<Failure>());
        if (result is Failure) {
          expect(result.error, tException);
        }
      });

      test('should correctly map FoodDTO list to Food entity list', () async {
        when(mockFirebaseFoodService.searchFood(
          queryText: anyNamed("queryText"),
          categoryIds: anyNamed("categoryIds"),
        )).thenAnswer((_) async => tFoodDTOListFromService);

        final result = await userFoodRepository.searchFood(
          queryText: queryText,
          categories: categoryIds,
        );

        expect(result, isA<Success>());
        if (result is Success) {
          final foodList = result.data as List<Food>;
          expect(foodList.length, tFoodDTOListFromService.length);
          for (int i = 0; i < foodList.length; i++) {
            expect(
                foodList[i], Food.mapFoodDTOToFood(tFoodDTOListFromService[i]));
          }
        }
      });
    });
  });
}
