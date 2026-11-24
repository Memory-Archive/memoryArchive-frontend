import 'package:flutter_test/flutter_test.dart';
import 'package:memories_archive/core/networking/api_error.dart';
import 'package:memories_archive/core/networking/json_helpers.dart';
import 'package:memories_archive/core/networking/token_pair.dart';

void main() {
  group('ApiError.fromResponse reads the backend error body', () {
    test('validation details become field errors', () {
      final error = ApiError.fromResponse(400, {
        'message': 'Validation failed',
        'details': [
          {'location': 'body', 'path': 'email', 'message': 'Invalid email address'},
        ],
      });
      expect(error.type, ApiErrorType.validation);
      expect(error.messageFor('email'), 'Invalid email address');
    });

    test('401 is unauthorized', () {
      final error = ApiError.fromResponse(401, {'message': 'Invalid email or password'});
      expect(error.type, ApiErrorType.unauthorized);
    });

    test('501 is "not implemented"', () {
      final error = ApiError.fromResponse(501, {'message': 'Not implemented yet'});
      expect(error.isNotImplemented, isTrue);
    });

    test('500 hides the server message', () {
      final error = ApiError.fromResponse(500, {'message': 'ER_DUP_ENTRY at users...'});
      expect(error.message.contains('ER_DUP_ENTRY'), isFalse);
    });
  });

  group('Success bodies are unwrapped', () {
    test('unwrapData returns the data part', () {
      final body = {
        'message': 'Logged in',
        'data': {'accessToken': 'a', 'refreshToken': 'r'},
      };
      final tokens = TokenPair.fromJson(asJsonMap(unwrapData(body), 'test'));
      expect(tokens.accessToken, 'a');
      expect(tokens.refreshToken, 'r');
    });
  });
}
