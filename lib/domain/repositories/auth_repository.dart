import '../../data/models/custom_user_dto.dart';
import '../utils/request_status.dart';
import '../../data/data_sources/firebase_firestore_user_service.dart';
import '../../data/data_sources/firebase_auth_service.dart';

abstract class AuthRepositoryApi {
  Future<RequestStatus> login(String email, String password);

  Future<RequestStatus> register(
    String email,
    String password,
    String username,
  );

  Future<RequestStatus> logout();

  Future<RequestStatus> sendPasswordResetEmail(String email);
}

class AuthRepository implements AuthRepositoryApi {
  final FirebaseAuthServiceApi _firebaseAuthService;
  final FirebaseFirestoreUserServiceApi _firebaseUserService;

  AuthRepository(
      {required FirebaseAuthServiceApi firebaseAuthService,
      required FirebaseFirestoreUserServiceApi firebaseUserService})
      : _firebaseUserService = firebaseUserService,
        _firebaseAuthService = firebaseAuthService;

  @override
  Future<RequestStatus> login(String email, String password) async {
    try {
      await _firebaseAuthService.signInWithEmailAndPassword(email, password);
      await _firebaseUserService.getUserByEmail(email);
      return Success(true);
    } catch (error) {
      return Failure(error);
    }
  }

  @override
  Future<RequestStatus> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      final userUid = await _firebaseAuthService.createUserWithEmailAndPassword(
          email, password);

      final CustomUserDTO newUser = CustomUserDTO(
          id: userUid, name: username, email: email, food_quantity: 0);

      final addedUser = await _firebaseUserService.addUser(newUser);
      return Success(addedUser);
    } catch (error) {
      return Failure(error);
    }
  }

  @override
  Future<RequestStatus> logout() async {
    try {
      await _firebaseAuthService.signOut();
      return Success(true);
    } catch (error) {
      return Failure(error);
    }
  }

  @override
  Future<RequestStatus> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuthService.sendPasswordResetEmail(email);
      return Success(true);
    } catch (error) {
      return Failure(error);
    }
  }
}
