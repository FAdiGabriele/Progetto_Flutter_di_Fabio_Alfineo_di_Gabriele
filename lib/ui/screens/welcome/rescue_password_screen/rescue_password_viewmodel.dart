import 'package:flutter/material.dart';

import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/utils/email_validator.dart';
import '../../../../domain/utils/request_status.dart';
import '../../../utils/ui_error.dart';

class RescuePasswordViewModel extends ChangeNotifier {
  final AuthRepositoryApi _authRepository;
  final emailController = TextEditingController();

  bool _isButtonEnabled = false;

  bool get isButtonEnabled => _isButtonEnabled;

  RescuePasswordViewModel({required AuthRepositoryApi authRepository})
      : _authRepository = authRepository {
    emailController.addListener(_checkTextField);
  }

  void _checkTextField() {
    _isButtonEnabled = emailController.text.isNotEmpty;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendPasswordResetEmail({
    required VoidCallback onSuccessListener,
    required void Function(String error) onFailureListener,
  }) async {
    final uiError = _checkConditions(email: emailController.text);
    if (uiError != null) {
      onFailureListener(uiError.message);
      return;
    }

    final resultState =
        await _authRepository.sendPasswordResetEmail(emailController.text);

    if (resultState is Failure) {
      final error = getErrorString(resultState.error);
      onFailureListener(error);
    } else {
      onSuccessListener();
    }
  }

  UIError? _checkConditions({
    required String email,
  }) {
    if (email.isEmpty) {
      return UIError.emptyEmail;
    }

    if (!EmailValidator.isEmailValid(email)) {
      return UIError.invalidEmailFormat;
    }

    return null;
  }
}
