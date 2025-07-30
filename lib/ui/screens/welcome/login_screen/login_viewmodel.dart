import 'package:flutter/material.dart';

import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/utils/email_validator.dart';
import '../../../utils/ui_error.dart';
import '../../../../domain/utils/request_status.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepositoryApi _authRepository;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginViewModel({required AuthRepositoryApi authRepository})
    : _authRepository = authRepository;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login({
    required void Function() onSuccessListener,
    required void Function(String error) onFailureListener,
  }) async {
    final uiError = _checkConditions(
        email: emailController.text, password: passwordController.text);
    if (uiError != null) {
      onFailureListener(uiError.message);
      return;
    }

    final resultState = await _authRepository.login(
        emailController.text, passwordController.text);

    if (resultState is Failure) {
      final error = getErrorString(resultState.error);
      onFailureListener(error);
    } else {
      onSuccessListener();
    }
  }

  UIError? _checkConditions({
    required String email,
    required String password,
  }) {
    if (email.isEmpty) {
      return UIError.emptyEmail;
    }

    if (password.isEmpty) {
      return UIError.emptyPassword;
    }

    if (!EmailValidator.isEmailValid(email)) {
      return UIError.invalidEmailFormat;
    }

    return null;
  }
}
