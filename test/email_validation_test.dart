import 'package:flutter_test/flutter_test.dart';
import 'package:mise_en_place/utils/email_validation.dart';

void main() {
  group('EmailValidator Tests', () {
    test('Valid email passes validation', () {
      expect(EmailValidator.validateEmail('test@example.com'), null);
    });

    test('Empty email fails validation', () {
      expect(EmailValidator.validateEmail(''), 'Enter a valid email');
    });

    test('Invalid email format fails validation', () {
      expect(EmailValidator.validateEmail('invalid-email'), 'Enter a valid email');
    });
  });
}
