import 'package:flutter_test/flutter_test.dart';
import 'package:offro_cibo/domain/utils/email_validator.dart';

void main() {
  group('EmailValidator', () {
    test('isEmailValid() should return true for a valid email', () {
      expect(EmailValidator.isEmailValid('test@example.com'), isTrue);
      expect(EmailValidator.isEmailValid('test.user@subdomain.example.co.uk'), isTrue);
      expect(EmailValidator.isEmailValid('test1234@example.net'), isTrue);
      expect(EmailValidator.isEmailValid('test_user@example.org'), isTrue);
      expect(EmailValidator.isEmailValid('test-user@example.it'), isTrue);
      expect(EmailValidator.isEmailValid('test+user@example.com'), isTrue);
      expect(EmailValidator.isEmailValid('test.user123@example.com'), isTrue);
      expect(EmailValidator.isEmailValid('test.user.123@example.com'), isTrue);
    });

    test('isEmailValid() should return false for an invalid email', () {
      expect(EmailValidator.isEmailValid('invalid-email'), isFalse);
      expect(EmailValidator.isEmailValid('test@'), isFalse);
      expect(EmailValidator.isEmailValid('@example.com'), isFalse);
      expect(EmailValidator.isEmailValid('test@example'), isFalse);
      expect(EmailValidator.isEmailValid('test@.com'), isFalse);
      expect(EmailValidator.isEmailValid('test@example.'), isFalse);
      expect(EmailValidator.isEmailValid('test@example..com'), isFalse);
      expect(EmailValidator.isEmailValid('test@.example.com'), isFalse);
      expect(EmailValidator.isEmailValid('test@example..com'), isFalse);
      expect(EmailValidator.isEmailValid('test@@example.com'), isFalse);
      expect(EmailValidator.isEmailValid('test@example@com'), isFalse);
      expect(EmailValidator.isEmailValid('test@example..com'), isFalse);
    });

    test('isEmailValid() should return false for empty email', () {
      expect(EmailValidator.isEmailValid(''), isFalse);
    });
  });
}