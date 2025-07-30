import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:offro_cibo/domain/repositories/auth_repository.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';
import 'package:offro_cibo/ui/screens/welcome/rescue_password_screen/rescue_password_viewmodel.dart';
import 'package:offro_cibo/ui/utils/ui_error.dart';

import '../login_screen/login_viewmodel_test.mocks.dart';

@GenerateMocks([AuthRepositoryApi])
void main() {
  late RescuePasswordViewModel viewModel;
  late MockAuthRepositoryApi mockAuthRepository;

  setUp(() {
    provideDummy<RequestStatus>(Failure(Exception()));
    provideDummy<RequestStatus>(Success(Object));
    mockAuthRepository = MockAuthRepositoryApi();
    viewModel = RescuePasswordViewModel(authRepository: mockAuthRepository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('RescuePasswordViewModel - sendPasswordResetEmail', () {
    test('sendPasswordResetEmail - Empty Email', () async {
      viewModel.emailController.text = '';

      String? capturedError;
      await viewModel.sendPasswordResetEmail(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.emptyEmail.message);
    });

    test('sendPasswordResetEmail - Invalid Email Format', () async {
      viewModel.emailController.text = 'invalid-email';

      String? capturedError;
      await viewModel.sendPasswordResetEmail(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, UIError.invalidEmailFormat.message);
    });

    test('sendPasswordResetEmail - Repository Failure', () async {
      viewModel.emailController.text = 'test@example.com';

      const errorMessage = 'Repository Error';
      when(mockAuthRepository.sendPasswordResetEmail(any))
          .thenAnswer((_) async => Failure(Exception(errorMessage)));

      String? capturedError;
      await viewModel.sendPasswordResetEmail(
        onSuccessListener: () {},
        onFailureListener: (error) {
          capturedError = error;
        },
      );

      expect(capturedError, errorMessage);
    });

    test('sendPasswordResetEmail - Repository Success', () async {
      viewModel.emailController.text = 'test@example.com';

      when(mockAuthRepository.sendPasswordResetEmail(any))
          .thenAnswer((_) async => Success(Object));

      bool successCalled = false;
      await viewModel.sendPasswordResetEmail(
        onSuccessListener: () {
          successCalled = true;
        },
        onFailureListener: (error) {},
      );

      expect(successCalled, true);
    });
  });
}