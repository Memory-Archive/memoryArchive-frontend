import 'json_helpers.dart';

/// The access + refresh tokens returned by `POST /auth/login` and
/// `POST /auth/refresh`.
class TokenPair {
  const TokenPair({required this.accessToken, required this.refreshToken});

  /// Reads the tokens from the `data` object. Accepts them at the top level
  /// (`{ accessToken, refreshToken, ... }`) or inside a `tokens` object.
  factory TokenPair.fromJson(Map<String, dynamic> json) {
    final source = json['tokens'] is Map ? asJsonMap(json['tokens'], 'tokens') : json;
    return TokenPair(
      accessToken: readRequiredString(source, const ['accessToken', 'access_token'], 'TokenPair'),
      refreshToken:
          readRequiredString(source, const ['refreshToken', 'refresh_token'], 'TokenPair'),
    );
  }

  final String accessToken;
  final String refreshToken;
}
