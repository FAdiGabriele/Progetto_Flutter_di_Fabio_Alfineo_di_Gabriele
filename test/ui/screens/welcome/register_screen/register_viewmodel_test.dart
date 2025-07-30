import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/domain/repositories/auth_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';
import 'package:offro_cibo/ui/screens/welcome/register_screen/register_viewmodel.dart';
import 'package:offro_cibo/ui/utils/ui_error.dart';

import '../login_screen/login_viewmodel_test.mocks.dart';

@GenerateMocks([AuthRepositoryApi])
void main() {
  late RegisterViewModel viewModel;
  late MockAuthRepositoryApi mockAuthRepository;

  setUp(() {
    provideDummy<RequestStatus>(Failure(Exception()));
    provideDummy<RequestStatus>(Success(Object));
    mockAuthRepository = MockAuthRepositoryApi();
    viewModel = RegisterViewModel(authRepository: mockAuthRepository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('RegisterViewModel - register', () {
    test('register - Empty Email', () async {
      viewModel.emailController.text = '';
      viewModel.usernameController.text = 'testuser';
      viewModel.passwordController.text = 'password123';
      viewModel.confirmPasswordController.text = 'password123';

      String? capturedError;
      await viewModel.register(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.emptyEmail.message);
    });

    test('register - Empty Username', () async {
      viewModel.emailController.text = 'test@example.com';
      viewModel.usernameController.text = '';
      viewModel.passwordController.text = 'password123';
      viewModel.confirmPasswordController.text = 'password123';

      String? capturedError;
      await viewModel.register(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.emptyUsername.message);
    });

    test('register - Empty Password', () async {
      viewModel.emailController.text = 'test@example.com';
      viewModel.usernameController.text = 'testuser';
      viewModel.passwordController.text = '';
      viewModel.confirmPasswordController.text = 'password123';

      String? capturedError;
      await viewModel.register(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.emptyPassword.message);
    });

    test('register - Empty Confirm Password', () async {
      viewModel.emailController.text = 'test@example.com';
      viewModel.usernameController.text = 'testuser';
      viewModel.passwordController.text = 'password123';
      viewModel.confirmPasswordController.text = '';

      String? capturedError;
      await viewModel.register(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.emptyConfirmPassword.message);
    });

    test('register - Invalid Email Format', () async {
      viewModel.emailController.text = 'invalid-email';
      viewModel.usernameController.text = 'testuser';
      viewModel.passwordController.text = 'password123';
      viewModel.confirmPasswordController.text = 'password123';

      String? capturedError;
      await viewModel.register(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.invalidEmailFormat.message);
    });

    test('register - Username Too Short', () async {
      viewModel.emailController.text = 'test@example.com';
      viewModel.usernameController.text = 'te';
      viewModel.passwordController.text = 'password123';
      viewModel.confirmPasswordController.text = 'password123';

      String? capturedError;
      await viewModel.register(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.usernameTooShort.message);
    });

    test('register - Password Too Short', () async {
      viewModel.emailController.text = 'test@example.com';
      viewModel.usernameController.text = 'testuser';
      viewModel.passwordController.text = 'pass';
      viewModel.confirmPasswordController.text = 'pass';

      String? capturedError;
      await viewModel.register(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.passwordTooShort.message);
    });

    test('register - Passwords Do Not Match', () async {
      viewModel.emailController.text = 'test@example.com';
      viewModel.usernameController.text = 'testuser';
      viewModel.passwordController.text = 'password123';
      viewModel.confirmPasswordController.text = 'differentPassword';

      String? capturedError;
      await viewModel.register(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.passwordsDoNotMatch.message);
    });

    test('register - Repository Failure', () async {
      viewModel.emailController.text = 'test@example.com';
      viewModel.usernameController.text = 'testuser';
      viewModel.passwordController.text = 'password123';
      viewModel.confirmPasswordController.text = 'password123';

      const errorMessage = 'Repository Error';
      when(mockAuthRepository.register(any, any, any))
          .thenAnswer((_) async => Failure(Exception(errorMessage)));

      String? capturedError;
      await viewModel.register(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, errorMessage);
    });

    test('register - Repository Success', () async {
      viewModel.emailController.text = 'test@example.com';
      viewModel.usernameController.text = 'testuser';
      viewModel.passwordController.text = 'password123';
      viewModel.confirmPasswordController.text = 'password123';

      when(mockAuthRepository.register(any, any, any))
          .thenAnswer((_) async => Success(Object));

      bool successCalled = false;
      await viewModel.register(
        onSuccessListener: () {
          successCalled = true;
        },
        onFailureListener: (error) {},
      );

      expect(successCalled, true);
    });
  });
}