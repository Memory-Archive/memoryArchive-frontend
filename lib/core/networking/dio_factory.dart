import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_endpoints.dart';
import '../constants/env.dart';
import '../session/session_manager.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

/// The one Dio every feature uses (registered in get_it).
Dio createDio({required TokenStorage tokenStorage, required SessionManager session}) {
  final options = BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: Env.connectTimeout,
    receiveTimeout: Env.receiveTimeout,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
    headers: {'Accept': 'application/json'},
  );

  final refreshClient = Dio(options);
  final dio = Dio(options)
    ..interceptors.add(
      AuthInterceptor(tokenStorage: tokenStorage, session: session, refreshClient: refreshClient),
    );

  if (kDebugMode) dio.interceptors.add(_SafeLogInterceptor());
  return dio;
}

/// Debug-only log of method, path and status. Never logs headers or bodies,
/// and logs nothing at all for `/auth/...` requests.
class _SafeLogInterceptor extends Interceptor {
  bool _skip(RequestOptions options) => options.path.startsWith(ApiEndpoints.authPrefix);

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (!_skip(response.requestOptions)) {
      debugPrint('[API] ${response.requestOptions.method} ${response.requestOptions.path} → ${response.statusCode}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!_skip(err.requestOptions)) {
      debugPrint('[API] ${err.requestOptions.method} ${err.requestOptions.path} → '
          '${err.response?.statusCode ?? err.type.name}');
    }
    handler.next(err);
  }
}
