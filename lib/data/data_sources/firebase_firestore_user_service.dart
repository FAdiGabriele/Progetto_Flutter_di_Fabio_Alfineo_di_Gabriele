import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/utils/logger.dart';
import '../models/custom_user_dto.dart';

abstract class FirebaseFirestoreUserServiceApi {
  Future<CustomUserDTO> addUser(CustomUserDTO newUser);
  Future<void> getUserByEmail(String email);
  Future<CustomUserDTO> getUserById(String id);
  Future<CustomUserDTO> updateUser(CustomUserDTO user);
}

class FirebaseFirestoreUserService implements FirebaseFirestoreUserServiceApi {
  static final _classTag = "FirebaseFirestoreUserService";
  
  @override
  Future<CustomUserDTO> addUser(CustomUserDTO newUser) async {
    try {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('custom_user')
          .doc(newUser.id);
      AppLogger.logger.d('$_classTag: User Added');

      await docRef.set(newUser.toMap());
      AppLogger.logger.d('$_classTag: User Added with ID: ${newUser.id}');

      return newUser;
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to add user: $error');
      rethrow;
    }
  }

  @override
  Future<void> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('custom_user')
          .where('email', isEqualTo: email)
          .get();

      final snapshot = querySnapshot.docs.first;
      AppLogger.logger.d('${snapshot.id} => ${snapshot.data}');
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to get users: $error');
      rethrow;
    }
  }

  @override
  Future<CustomUserDTO> updateUser(CustomUserDTO user) async {
    try {
      await FirebaseFirestore.instance
          .collection('custom_user')
          .doc(user.id)
          .update(user.toMap());

      AppLogger.logger.d('$_classTag: User Updated');
      return user;
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to update user: $error');
      rethrow;
    }
  }

  @override
  Future<CustomUserDTO> getUserById(String userId) async {
    try {
    final DocumentReference userDocRef =
    FirebaseFirestore.instance.collection('custom_user').doc(userId);

    final snapshot = await userDocRef.get();

    final user = snapshot.data() as Map<String, dynamic>;

    return CustomUserDTO.fromMap(user, userId);
    } catch (error) {
      AppLogger.logger.d('$_classTag: Failed to update user: $error');
      rethrow;
    }
  }
}
