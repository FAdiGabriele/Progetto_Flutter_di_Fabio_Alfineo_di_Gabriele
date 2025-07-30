import 'package:flutter_test/flutter_test.dart';
import 'package:offro_cibo/domain/utils/date_validator.dart';

void main() {
  group('DateValidator', () {
    group('getValidDateOrNull', () {
      test('should return a valid DateTime for valid date strings', () {
        final result = DateValidator.getValidDateOrNull('2023', '10', '26');
        expect(result, isNotNull);
        expect(result, equals(DateTime(2023, 10, 26)));
      });

      test('should return null for invalid day string', () {
        final result = DateValidator.getValidDateOrNull('2023', '10', 'abc');
        expect(result, isNull);
      });

      test('should return null for invalid month string', () {
        final result = DateValidator.getValidDateOrNull('2023', 'xyz', '26');
        expect(result, isNull);
      });

      test('should return null for invalid year string', () {
        final result = DateValidator.getValidDateOrNull('year', '10', '26');
        expect(result, isNull);
      });

      test('should return null for empty day string', () {
        final result = DateValidator.getValidDateOrNull('2023', '10', '');
        expect(result, isNull);
      });

      test('should return null for empty month string', () {
        final result = DateValidator.getValidDateOrNull('2023', '', '26');
        expect(result, isNull);
      });

      test('should return null for empty year string', () {
        final result = DateValidator.getValidDateOrNull('', '10', '26');
        expect(result, isNull);
      });

      test('should return null for day out of range (e.g., 32)', () {
        final result = DateValidator.getValidDateOrNull('2023', '10', '32');
        expect(result, isNull);
      });

      test('should return null for month out of range (e.g., 13)', () {
        final result = DateValidator.getValidDateOrNull('2023', '13', '26');
        expect(result, isNull);
      });

      test('should return null for month as 0', () {
        final result = DateValidator.getValidDateOrNull('2023', '0', '26');
        expect(result, isNull);
      });

      test('should return null for day as 0', () {
        final result = DateValidator.getValidDateOrNull('2023', '10', '0');
        expect(result, isNull);
      });


      test('should return null for February 29 on a non-leap year', () {
        final result = DateValidator.getValidDateOrNull('2023', '02', '29');
        expect(result, isNull);
      });

      test('should return a valid DateTime for February 29 on a leap year', () {
        final result = DateValidator.getValidDateOrNull('2024', '02', '29');
        expect(result, isNotNull);
        expect(result, equals(DateTime(2024, 2, 29)));
      });

      test('should return a valid DateTime for single digit day and month', () {
        final result = DateValidator.getValidDateOrNull('2023', '7', '5');
        expect(result, isNotNull);
        expect(result, equals(DateTime(2023, 7, 5)));
      });

      test('should return null for year less than 1', () {
        final result = DateValidator.getValidDateOrNull('0', '10', '20');
        expect(result, isNull);
      });

      test('should return null for year greater than 9999', () {
        final result = DateValidator.getValidDateOrNull('10000', '10', '20');
        expect(result, isNull);
      });
    });

    group('isFutureDate', () {
      test('should return true for a date in the future', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        expect(DateValidator.isFutureDate(futureDate), isTrue);
      });

      test('should return false for a date in the past', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 1));
        expect(DateValidator.isFutureDate(pastDate), isFalse);
      });

      test('should return false for the current date and time (or very close to it)', () {
        final now = DateTime.now();
        expect(DateValidator.isFutureDate(now), isFalse);

        final verySlightlyInPast = now.subtract(const Duration(milliseconds: 10));
        expect(DateValidator.isFutureDate(verySlightlyInPast), isFalse);
      });

      test('should return true for a time later today', () {
        final laterToday = DateTime.now().add(const Duration(hours: 2));
        expect(DateValidator.isFutureDate(laterToday), isTrue);
      });

      test('should return false for a time earlier today', () {
        final earlierToday = DateTime.now().subtract(const Duration(hours: 2));
        expect(DateValidator.isFutureDate(earlierToday), isFalse);
      });
    });
  });
}