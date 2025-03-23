import 'package:flutter_test/flutter_test.dart';
import 'package:mise_en_place/utils/password_validation.dart';

void main() {
  group('PasswordValidator Tests', () {
    test('Valid password passes validation', () {
      expect(PasswordValidator.validatePassword('Strong@123'), null);
    });

    test('Password without uppercase fails validation', () {
      expect(
        PasswordValidator.validatePassword('strong@123'),
        'Password must be 8+ characters long, with upper, lower, number, and special character.',
      );
    });

    test('Password without lowercase fails validation', () {
      expect(
        PasswordValidator.validatePassword('STRONG@123'),
        'Password must be 8+ characters long, with upper, lower, number, and special character.',
      );
    });

    test('Password without number fails validation', () {
      expect(
        PasswordValidator.validatePassword('Strong@'),
        'Password must be 8+ characters long, with upper, lower, number, and special character.',
      );
    });

    test('Password without special character fails validation', () {
      expect(
        PasswordValidator.validatePassword('Strong123'),
        'Password must be 8+ characters long, with upper, lower, number, and special character.',
      );
    });

    test('Password shorter than 8 characters fails validation', () {
      expect(
        PasswordValidator.validatePassword('Str@1'),
        'Password must be 8+ characters long, with upper, lower, number, and special character.',
      );
    });
  });
}
