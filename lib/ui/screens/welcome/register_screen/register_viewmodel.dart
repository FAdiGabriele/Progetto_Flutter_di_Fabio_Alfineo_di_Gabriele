import 'package:flutter/material.dart';

import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/utils/email_validator.dart';
import '../../../../domain/utils/request_status.dart';
import '../../../utils/ui_error.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepositoryApi _authRepository;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RegisterViewModel({required AuthRepositoryApi authRepository})
      : _authRepository = authRepository;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register({
    required VoidCallback onSuccessListener,
    required void Function(String error) onFailureListener,
  }) async {
    final uiError = _checkConditions(
      email: emailController.text,
      password: passwordController.text,
      username: usernameController.text,
      confirmPassword: confirmPasswordController.text,
    );
    if (uiError != null) {
      onFailureListener(uiError.message);
      return;
    }

    final resultState = await _authRepository.register(
      emailController.text,
      passwordController.text,
      usernameController.text,
    );

    if (resultState is Failure) {
      final error = getErrorString(resultState.error);
      onFailureListener(error);
    } else {
      onSuccessListener();
    }
  }

  UIError? _checkConditions({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) {
    if (email.isEmpty) {
      return UIError.emptyEmail;
    }

    if (username.isEmpty) {
      return UIError.emptyUsername;
    }

    if (password.isEmpty) {
      return UIError.emptyPassword;
    }

    if (confirmPassword.isEmpty) {
      return UIError.emptyConfirmPassword;
    }

    if (!EmailValidator.isEmailValid(email)) {
      return UIError.invalidEmailFormat;
    }

    if (username.length < 3) {
      return UIError.usernameTooShort;
    }

    if (password.length < 6) {
      return UIError.passwordTooShort;
    }

    if (password != confirmPassword) {
      return UIError.passwordsDoNotMatch;
    }

    return null;
  }
}
