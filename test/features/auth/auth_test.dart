import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_saas_starter/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('Email Validation', () {
      test('should return null for valid email', () {
        expect(Validators.email('test@example.com'), null);
        expect(Validators.email('user.name@domain.co.uk'), null);
      });

      test('should return error for invalid email', () {
        expect(Validators.email(''), isNotNull);
        expect(Validators.email('invalid'), isNotNull);
        expect(Validators.email('test@'), isNotNull);
        expect(Validators.email('@example.com'), isNotNull);
      });
    });

    group('Password Validation', () {
      test('should return null for valid password', () {
        expect(Validators.password('password123'), null);
        expect(Validators.password('SecurePass@123'), null);
      });

      test('should return error for invalid password', () {
        expect(Validators.password(''), isNotNull);
        expect(Validators.password('12345'), isNotNull);
        expect(Validators.password('pass'), isNotNull);
      });

      test('should enforce minimum length', () {
        expect(Validators.password('12345'), isNotNull);
        expect(Validators.password('123456'), null);
      });
    });

    group('Confirm Password Validation', () {
      test('should return null when passwords match', () {
        expect(Validators.confirmPassword('password', 'password'), null);
      });

      test('should return error when passwords do not match', () {
        expect(Validators.confirmPassword('password', 'different'), isNotNull);
      });

      test('should return error for empty confirmation', () {
        expect(Validators.confirmPassword('', 'password'), isNotNull);
      });
    });
  });
}

