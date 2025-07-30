import 'package:firebase_auth/firebase_auth.dart';

import 'app_string.dart';

enum UIError {
  emptyEmail(AppString.ui_error__empty_email),
  emptyUsername(AppString.ui_error__empty_username),
  emptyPassword(AppString.ui_error__empty_password),
  emptyConfirmPassword(AppString.ui_error__empty_confirm_password),
  invalidEmailFormat(AppString.ui_error__invalid_email_format),
  usernameTooShort(AppString.ui_error__username_too_short),
  passwordTooShort(AppString.ui_error__password_too_short),
  passwordsDoNotMatch(AppString.ui_error__passwords_do_not_match),

  emptyName(AppString.ui_error__empty_name),
  emptyCategoryList(AppString.ui_error__empty_category_list),
  invalidQuantity(AppString.ui_error__invalid_quantity),
  invalidDate(AppString.ui_error__invalid_date),
  futureDate(AppString.ui_error__future_date),
  emptyRestaurantName(AppString.ui_error__empty_restaurant_name),
  emptyRestaurantAddress(AppString.ui_error__empty_restaurant_address),

  genericError(AppString.ui_error__generic_error);

  final String message;

  const UIError(this.message);
}

enum FirebaseUIError {
  invalidEmail('invalid-email', AppString.firebase_auth_error__invalid_email),
  userDisabled('user-disabled', AppString.firebase_auth_error__user_disabled),
  userNotFound('user-not-found', AppString.firebase_auth_error__user_not_found),
  wrongPassword('wrong-password', AppString.firebase_auth_error__wrong_password),
  invalidCredential('invalid-credential', AppString.firebase_auth_error__invalid_credential),
  emailAlreadyInUse('email-already-in-use', AppString.firebase_auth_error__email_already_in_use),
  tooManyRequests('too-many-requests', AppString.firebase_auth_error__too_many_requests),
  internalError('internal-error', AppString.firebase_auth_error__internal_error),
  networkRequestFailed('network-request-failed', AppString.firebase_auth_error__network_request_failed),
  weakPassword('weak-password', AppString.firebase_auth_error__weak_password),
  genericError('generic-error', AppString.firebase_auth_error__generic_error),
  operationNotAllowed('operation-not-allowed', AppString.firebase_auth_error__generic_error);

  final String code;
  final String message;

  const FirebaseUIError(this.code, this.message);
}

String getErrorString(error) {
  if (error is FirebaseAuthException) {
    for (final firebaseUIError in FirebaseUIError.values) {
      if (firebaseUIError.code == error.code) {
        return firebaseUIError.message;
      }
    }
    return FirebaseUIError.genericError.message.toString();
  } else {
    return error.message;
  }
}