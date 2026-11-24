import '../../../../core/networking/json_helpers.dart';
import '../../../../core/networking/token_pair.dart';
import 'user_dto.dart';

/// `data` of `POST /auth/login`: the user, both tokens and their expiry times.
class LoginResponseDto {
  const LoginResponseDto({required this.user, required this.tokens});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => LoginResponseDto(
        user: UserDto.fromJson(asJsonMap(json['user'], 'login.user')),
        tokens: TokenPair.fromJson(json),
      );

  final UserDto user;
  final TokenPair tokens;
}
