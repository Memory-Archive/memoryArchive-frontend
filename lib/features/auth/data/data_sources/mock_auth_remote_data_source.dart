import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/mock_http_error.dart';
import '../../../../core/networking/token_pair.dart';
import '../models/login_response_dto.dart';
import '../models/user_dto.dart';
import 'auth_remote_data_source.dart';

/// Fake backend for `--dart-define=USE_MOCK=true`. Behaves like the real
/// one, including its error bodies:
/// * any email and password log in, except `wrong@example.com` (401);
/// * signing up with `taken@example.com` returns 409 with a field error;
/// * forgot password returns 501, like the real backend this semester.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  final Map<String, UserDto> _accounts = {};
  int _tokenCounter = 0;

  @override
  Future<UserDto> signup({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    await mockDelay();
    if (email == 'taken@example.com' || _accounts.containsKey(email)) {
      throw mockHttpError(ApiEndpoints.signup, 409, {
        'message': 'Email already registered',
        'details': [
          {'location': 'body', 'path': 'email', 'message': 'This email is already registered'},
        ],
      });
    }
    final user = UserDto(
      id: 'mock-${email.hashCode.abs()}',
      username: username,
      email: email,
      displayName: displayName,
    );
    _accounts[email] = user;
    return user;
  }

  @override
  Future<LoginResponseDto> login({
    required String email,
    required String password,
    String? deviceName,
  }) async {
    await mockDelay();
    if (email == 'wrong@example.com') {
      throw mockHttpError(ApiEndpoints.login, 401, {'message': 'Invalid email or password'});
    }
    final user = _accounts[email] ??
        UserDto(
          id: 'mock-${email.hashCode.abs()}',
          username: email.split('@').first,
          email: email,
          displayName: 'Sara Hassan',
        );
    return LoginResponseDto(user: user, tokens: _newTokens());
  }

  @override
  Future<TokenPair> refresh(String refreshToken) async {
    await mockDelay(300);
    return _newTokens();
  }

  @override
  Future<void> logout(String refreshToken) => mockDelay(200);

  @override
  Future<void> forgotPassword(String email) async {
    await mockDelay();
    throw mockHttpError(ApiEndpoints.forgotPassword, 501, {'message': 'Not implemented yet'});
  }

  TokenPair _newTokens() {
    _tokenCounter++;
    return TokenPair(accessToken: 'mock-access-$_tokenCounter', refreshToken: 'mock-refresh-$_tokenCounter');
  }
}
