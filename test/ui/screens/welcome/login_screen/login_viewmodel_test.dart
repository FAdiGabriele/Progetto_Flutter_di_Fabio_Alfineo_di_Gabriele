import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/domain/repositories/auth_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';
import 'package:offro_cibo/ui/screens/welcome/login_screen/login_viewmodel.dart';
import 'package:offro_cibo/ui/utils/ui_error.dart';

import 'login_viewmodel_test.mocks.dart';

@GenerateMocks([AuthRepositoryApi])
void main() {
  late LoginViewModel viewModel;
  late MockAuthRepositoryApi mockAuthRepository;

  setUp(() {
    provideDummy<RequestStatus>(Failure(Exception()));
    provideDummy<RequestStatus>(Success(Object));
    mockAuthRepository = MockAuthRepositoryApi();
    viewModel = LoginViewModel(authRepository: mockAuthRepository);
  });

  tearDown(() {
    viewModel.dispose();
  });

    group('LoginViewModel - login', () {
      test('login - Invalid Email', () async {
        viewModel.emailController.text = 'invalid-email';
        viewModel.passwordController.text = 'password123';

        String? capturedError;
        await viewModel.login(
          onSuccessListener: () {},
          onFailureListener: (error) {
            capturedError = error;
          },
        );

        expect(capturedError, UIError.invalidEmailFormat.message);
      });

      test('login - Empty Email', () async {
        viewModel.emailController.text = '';
        viewModel.passwordController.text = 'password123';

        String? capturedError;
        await viewModel.login(
          onSuccessListener: () {},
          onFailureListener: (error) {
            capturedError = error;
          },
        );

        expect(capturedError, UIError.emptyEmail.message);
      });

      test('login - Empty Password', () async {
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = '';

        String? capturedError;
        await viewModel.login(
          onSuccessListener: () {},
          onFailureListener: (error) {
            capturedError = error;
          },
        );

        expect(capturedError, UIError.emptyPassword.message);
      });

      test('login - Repository Failure', () async {
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        const errorMessage = 'Repository Error';
        when(mockAuthRepository.login(any, any))
            .thenAnswer((_) async => Failure(Exception(errorMessage)));

        String? capturedError;
        await viewModel.login(
          onSuccessListener: () {},
          onFailureListener: (error) {
            capturedError = error;
          },
        );

        expect(capturedError, errorMessage);
      });

      test('login - Repository Success', () async {
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        when(mockAuthRepository.login(any, any))
            .thenAnswer((_) async => Success(Object));

        bool successCalled = false;
        await viewModel.login(
          onSuccessListener: () {
            successCalled = true;
          },
          onFailureListener: (error) {},
        );

        expect(successCalled, true);
      });
    });
}
