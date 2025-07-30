import 'package:firebase_auth/firebase_auth.dart';
import 'package:offro_cibo/domain/utils/logger.dart';

abstract class UserProviderApi{
  String? getUserId();
}

class UserProvider implements UserProviderApi{
  static final String _classTag = "UserProvider";

  @override
  String? getUserId(){
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      AppLogger.logger.d("$_classTag: user not available");
      return null;
    }
  }
}
