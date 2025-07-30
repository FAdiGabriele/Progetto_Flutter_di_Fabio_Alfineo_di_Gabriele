import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/data/data_sources/firebase_firestore_take_food_service.dart';
import 'package:offro_cibo/domain/repositories/take_food_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';

import 'take_food_repository_test.mocks.dart';

@GenerateMocks([FirebaseFirestoreTakeFoodServiceApi])
void main() {
  late MockFirebaseFirestoreTakeFoodServiceApi mockFirebaseService;
  late TakeFoodRepository repository;

  setUp(() {
    mockFirebaseService = MockFirebaseFirestoreTakeFoodServiceApi();
    repository =
        TakeFoodRepository(firebaseTakeFoodService: mockFirebaseService);
  });

  const foodId = 'food-123';
  const portions = 2;
  const userId = 'user-abc';

  group('takeFood', () {
    test('should return Success when firebase service executes successfully',
            () async {
          when(mockFirebaseService.takeFood(any, any, any))
              .thenAnswer((_) async => true);

          final result = await repository.takeFood(
            foodId: foodId,
            portions: portions,
            userId: userId,
          );

          expect(result, isA<Success>());
          verify(mockFirebaseService.takeFood(foodId, portions, userId)).called(1);
        });

    test('should return Failure when firebase service throws an exception',
            () async {
          final exception = Exception('Firebase connection failed');
          when(mockFirebaseService.takeFood(any, any, any)).thenThrow(exception);

          final result = await repository.takeFood(
            foodId: foodId,
            portions: portions,
            userId: userId,
          );

          expect(result, isA<Failure>());
          expect((result as Failure).error, exception);
          verify(mockFirebaseService.takeFood(foodId, portions, userId)).called(1);
        });
  });
}