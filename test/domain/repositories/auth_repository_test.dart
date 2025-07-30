import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/data/data_sources/firebase_auth_service.dart';
import 'package:offro_cibo/data/data_sources/firebase_firestore_user_service.dart';
import 'package:offro_cibo/data/models/custom_user_dto.dart';
import 'package:offro_cibo/domain/repositories/auth_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([FirebaseAuthServiceApi, FirebaseFirestoreUserServiceApi])
void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuthServiceApi mockFirebaseAuthService;
  late MockFirebaseFirestoreUserServiceApi mockFirebaseUserService;

  setUp(() {
    mockFirebaseAuthService = MockFirebaseAuthServiceApi();
    mockFirebaseUserService = MockFirebaseFirestoreUserServiceApi();
    authRepository = AuthRepository(
      firebaseAuthService: mockFirebaseAuthService,
      firebaseUserService: mockFirebaseUserService,
    );
  });

  group('AuthRepository - login', () {
    test('login - Success', () async {
      const email = 'test@example.com';
      const password = 'password123';

      when(mockFirebaseAuthService.signInWithEmailAndPassword(email, password))
          .thenAnswer((_) async => {});
      when(mockFirebaseUserService.getUserByEmail(email)).thenAnswer((_) async => '');

      final result = await authRepository.login(email, password);

      expect(result, isA<Success>());
      expect((result as Success).data, true);

      verify(mockFirebaseAuthService.signInWithEmailAndPassword(
              email, password))
          .called(1);
      verify(mockFirebaseUserService.getUserByEmail(email)).called(1);
    });

    test('login - FirebaseAuthService Failure', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const errorMessage = 'FirebaseAuth Error';

      when(mockFirebaseAuthService.signInWithEmailAndPassword(email, password))
          .thenThrow(errorMessage);

      final result = await authRepository.login(email, password);

      expect(result, isA<Failure>());
      expect((result as Failure).error, errorMessage);

      verify(mockFirebaseAuthService.signInWithEmailAndPassword(
              email, password))
          .called(1);
      verifyNever(mockFirebaseUserService.getUserByEmail(email));
    });

    test('login - FirebaseFireStoreService Failure', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const errorMessage = 'FirebaseFireStore Error';

      when(mockFirebaseAuthService.signInWithEmailAndPassword(email, password))
          .thenAnswer((_) async => {});
      when(mockFirebaseUserService.getUserByEmail(email)).thenThrow(errorMessage);

      final result = await authRepository.login(email, password);

      expect(result, isA<Failure>());
      expect((result as Failure).error, errorMessage);

      verify(mockFirebaseAuthService.signInWithEmailAndPassword(
              email, password))
          .called(1);
      verify(mockFirebaseUserService.getUserByEmail(email)).called(1);
    });
  });

  group('AuthRepository - register', () {
    test('register - Success', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const username = 'testuser';
      const userUid = 'some-user-uid';

      final customUser = CustomUserDTO(
        id: userUid,
        name: username,
        email: email,
        food_quantity: 0,
      );

      when(mockFirebaseAuthService.createUserWithEmailAndPassword(
              email, password))
          .thenAnswer((_) async => userUid);
      when(mockFirebaseUserService.addUser(captureAny))
          .thenAnswer((_) async => customUser);

      final result = await authRepository.register(email, password, username);

      expect(result, isA<Success>());
      expect((result as Success).data, customUser);

      verify(mockFirebaseAuthService.createUserWithEmailAndPassword(
              email, password))
          .called(1);
      verify(mockFirebaseUserService.addUser(customUser)).called(1);
    });

    test('register - FirebaseAuthService Failure', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const username = 'testuser';
      const errorMessage = 'FirebaseAuth Error';

      when(mockFirebaseAuthService.createUserWithEmailAndPassword(
              email, password))
          .thenThrow(errorMessage);

      final result = await authRepository.register(email, password, username);

      expect(result, isA<Failure>());
      expect((result as Failure).error, errorMessage);

      verify(mockFirebaseAuthService.createUserWithEmailAndPassword(
              email, password))
          .called(1);
      verifyNever(mockFirebaseUserService.addUser(any));
    });

    test('register - FirebaseFireStoreService Failure', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const username = 'testuser';
      const userUid = 'some-user-uid';
      const errorMessage = 'FirebaseFireStore Error';

      when(mockFirebaseAuthService.createUserWithEmailAndPassword(
              email, password))
          .thenAnswer((_) async => userUid);
      when(mockFirebaseUserService.addUser(any)).thenThrow(errorMessage);

      final result = await authRepository.register(email, password, username);

      expect(result, isA<Failure>());
      expect((result as Failure).error, errorMessage);

      verify(mockFirebaseAuthService.createUserWithEmailAndPassword(
              email, password))
          .called(1);
      verify(mockFirebaseUserService.addUser(any)).called(1);
    });
  });

  group('AuthRepository - logout', () {
    test('logout - Success', () async {
      when(mockFirebaseAuthService.signOut()).thenAnswer((_) async => {});

      final result = await authRepository.logout();

      expect(result, isA<Success>());
      expect((result as Success).data, true);

      verify(mockFirebaseAuthService.signOut()).called(1);
    });

    test('logout - FirebaseAuthService Failure', () async {
      const errorMessage = 'FirebaseAuth Error';

      when(mockFirebaseAuthService.signOut()).thenThrow(errorMessage);

      final result = await authRepository.logout();

      expect(result, isA<Failure>());
      expect((result as Failure).error, errorMessage);

      verify(mockFirebaseAuthService.signOut()).called(1);
    });
  });

  group('AuthRepository - sendPasswordResetEmail', () {
    test('sendPasswordResetEmail - Success', () async {
      const email = 'test@example.com';

      when(mockFirebaseAuthService.sendPasswordResetEmail(email))
          .thenAnswer((_) async => {});

      final result = await authRepository.sendPasswordResetEmail(email);

      expect(result, isA<Success>());
      expect((result as Success).data, true);

      verify(mockFirebaseAuthService.sendPasswordResetEmail(email)).called(1);
    });

    test('sendPasswordResetEmail - FirebaseAuthService Failure', () async {
      const email = 'test@example.com';
      const errorMessage = 'FirebaseAuth Error';

      when(mockFirebaseAuthService.sendPasswordResetEmail(email))
          .thenThrow(errorMessage);

      final result = await authRepository.sendPasswordResetEmail(email);

      expect(result, isA<Failure>());
      expect((result as Failure).error, errorMessage);

      verify(mockFirebaseAuthService.sendPasswordResetEmail(email)).called(1);
    });
  });
}
