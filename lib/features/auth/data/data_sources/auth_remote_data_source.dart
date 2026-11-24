import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/json_helpers.dart';
import '../../../../core/networking/token_pair.dart';
import '../models/login_response_dto.dart';
import '../models/user_dto.dart';

/// Talks to the backend's `/auth` routes. Throws on failure
/// ([DioException] or [DtoParsingException]); the repository catches.
abstract interface class AuthRemoteDataSource {
  Future<UserDto> signup({
    required String username,
    required String email,
    required String password,
    String? displayName,
  });

  Future<LoginResponseDto> login({
    required String email,
    required String password,
    String? deviceName,
  });

  Future<TokenPair> refresh(String refreshToken);

  Future<void> logout(String refreshToken);

  Future<void> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserDto> signup({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.signup,
      data: {
        'username': username,
        'email': email,
        'password': password,
        if (displayName != null && displayName.isNotEmpty) 'displayName': displayName,
      },
    );
    // 201 { message, data: <user> } or { message, data: { user } }
    final data = asJsonMap(unwrapData(response.data), 'signup');
    final userJson = data['user'] is Map ? asJsonMap(data['user'], 'signup.user') : data;
    return UserDto.fromJson(userJson);
  }

  @override
  Future<LoginResponseDto> login({
    required String email,
    required String password,
    String? deviceName,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
        if (deviceName != null) 'deviceName': deviceName,
      },
    );
    return LoginResponseDto.fromJson(asJsonMap(unwrapData(response.data), 'login'));
  }

  @override
  Future<TokenPair> refresh(String refreshToken) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.refresh,
      data: {'refreshToken': refreshToken},
    );
    return TokenPair.fromJson(asJsonMap(unwrapData(response.data), 'refresh'));
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _dio.post<dynamic>(ApiEndpoints.logout, data: {'refreshToken': refreshToken});
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _dio.post<dynamic>(ApiEndpoints.forgotPassword, data: {'email': email});
  }
}
