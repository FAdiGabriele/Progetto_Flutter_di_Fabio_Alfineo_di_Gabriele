import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/utils/logger.dart';


abstract class FirebaseFirestoreTakeFoodServiceApi {
  Future<bool> takeFood(String foodId, int portions, String userId);
}

class FirebaseFirestoreTakeFoodService
    implements FirebaseFirestoreTakeFoodServiceApi {
  final _classTag = 'FirebaseFirestoreTakeFoodService';

  @override
  Future<bool> takeFood(String foodId, int portions, String userId) async {
    final DocumentReference foodDocRef =
        FirebaseFirestore.instance.collection('food').doc(foodId);
    final DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('custom_user').doc(userId);

    AppLogger.logger.d("$_classTag -> Document reference declared");

    final result = await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userDocRef);

      AppLogger.logger.d("$_classTag -> Snapshot created: ${userSnapshot.data()}");

      if (!userSnapshot.exists) {
        AppLogger.logger.d("$_classTag -> Snapshot doesn't exist");
        throw Exception("User with ID $userId does not exist.");
      }

      AppLogger.logger.d("$_classTag -> Snapshot exist");

      transaction.delete(foodDocRef);
      AppLogger.logger
          .d("$_classTag -> Food document $foodId marked for deletion.");

      transaction.update(
          userDocRef, {'food_quantity': FieldValue.increment(portions)});
    }).then((_) {
      AppLogger.logger.d(
          "$_classTag -> Transaction successful: Food deleted and user order count incremented.");

      return true;
    }).catchError((error) {
      AppLogger.logger.d("$_classTag -> Transaction failed: $error");
      throw error;
    });

    return result;
  }
}
