import 'package:flutter_test/flutter_test.dart';
import 'package:memories_archive/core/validation/validators.dart';

void main() {
  group('Validators.newPassword (backend rule: 8–128 characters)', () {
    final validate = Validators.newPassword();

    test('rejects 7 characters', () => expect(validate('1234567'), isNotNull));
    test('accepts 8 characters', () => expect(validate('12345678'), isNull));
    test('accepts 128 characters', () => expect(validate('a' * 128), isNull));
    test('rejects 129 characters', () => expect(validate('a' * 129), isNotNull));
  });

  group('Validators.username (backend rule: 3–30, letters, numbers, _ and .)', () {
    final validate = Validators.username();

    test('accepts sara.h', () => expect(validate('sara.h'), isNull));
    test('accepts sara_99', () => expect(validate('sara_99'), isNull));
    test('rejects 2 characters', () => expect(validate('ab'), isNotNull));
    test('rejects 31 characters', () => expect(validate('a' * 31), isNotNull));
    test('rejects spaces', () => expect(validate('sara h'), isNotNull));
    test('rejects @', () => expect(validate('sara@h'), isNotNull));
  });

  group('Validators.email', () {
    final validate = Validators.compose([
      Validators.required('Enter your email'),
      Validators.email(),
    ]);

    test('empty asks for the email', () => expect(validate(''), 'Enter your email'));
    test('rejects sara@', () => expect(validate('sara@'), 'Enter a valid email address'));
    test('accepts sara@example.com', () => expect(validate('sara@example.com'), isNull));
  });
}
