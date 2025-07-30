import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/utils/logger.dart';


abstract class FirebaseAuthServiceApi {
  Future<String?> createUserWithEmailAndPassword(String email, String password);
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}

class FirebaseAuthService implements FirebaseAuthServiceApi{
  static final _classTag = "FirebaseAuthService";

  @override
  Future<String?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.logger.d('$_classTag: User created: ${credential.user?.uid}');

      return credential.user?.uid;
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to create user: $error');
      rethrow;
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.logger.d("$_classTag: User signed in: ${credential.user?.uid}");
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to sign in : $error');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      AppLogger.logger.d('$_classTag: User signed out');
    } catch (error){
      AppLogger.logger.d('$_classTag: Failed to sign out: $error');
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      AppLogger.logger.d('$_classTag: Password reset email sent to: $email');
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to send password reset: $error');
      rethrow;
    }
  }
}
