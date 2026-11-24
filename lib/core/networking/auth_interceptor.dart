import 'package:dio/dio.dart';

import '../constants/api_endpoints.dart';
import '../session/session_manager.dart';
import '../storage/token_storage.dart';
import 'json_helpers.dart';
import 'token_pair.dart';

enum _RefreshOutcome { refreshed, rejected, failed }

/// Adds `Authorization: Bearer <accessToken>` to every request except
/// `/auth/...`, and refreshes the tokens once when the backend answers 401.
///
/// How it matches the backend:
/// * Access tokens last 15 minutes. When one expires, the backend returns 401,
///   this interceptor calls `POST /auth/refresh` with the refresh token, saves
///   the new pair (the backend rotates refresh tokens) and repeats the request.
/// * If the refresh is rejected (expired, revoked or reused token), the user
///   is logged out and the router shows the log-in screen.
/// * It's a [QueuedInterceptor], so several requests failing at the same time
///   trigger only one refresh. Using an old refresh token twice would make the
///   backend log the user out on every device.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required SessionManager session,
    required Dio refreshClient,
  })  : _tokens = tokenStorage,
        _session = session,
        _refreshClient = refreshClient;

  final TokenStorage _tokens;
  final SessionManager _session;

  /// A plain Dio without this interceptor, used for the refresh call and the
  /// retried request.
  final Dio _refreshClient;

  static const String _retriedKey = 'authRetried';

  static bool _isAuthPath(RequestOptions options) =>
      options.path.startsWith(ApiEndpoints.authPrefix);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_isAuthPath(options)) {
      final token = await _tokens.readAccessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    if (!isUnauthorized || _isAuthPath(options) || options.extra[_retriedKey] == true) {
      handler.next(err);
      return;
    }

    // If another request already refreshed while this one was waiting in the
    // queue, just retry with the new token.
    final current = await _tokens.readAccessToken();
    String? newToken;
    if (current != null && options.headers['Authorization'] != 'Bearer $current') {
      newToken = current;
    } else {
      final outcome = await _refresh();
      if (outcome == _RefreshOutcome.rejected) {
        await _tokens.clear();
        _session.setUnauthenticated();
        handler.next(err);
        return;
      }
      if (outcome == _RefreshOutcome.failed) {
        // Server unreachable: keep the session, report the original error.
        handler.next(err);
        return;
      }
      newToken = await _tokens.readAccessToken();
    }

    if (newToken == null) {
      handler.next(err);
      return;
    }

    options.headers['Authorization'] = 'Bearer $newToken';
    options.extra[_retriedKey] = true;
    try {
      final response = await _refreshClient.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<_RefreshOutcome> _refresh() async {
    final refreshToken = await _tokens.readRefreshToken();
    if (refreshToken == null) return _RefreshOutcome.rejected;
    try {
      final response = await _refreshClient.post<dynamic>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
      );
      final pair = TokenPair.fromJson(asJsonMap(unwrapData(response.data), 'refresh'));
      await _tokens.saveTokens(accessToken: pair.accessToken, refreshToken: pair.refreshToken);
      return _RefreshOutcome.refreshed;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 400 || status == 401 || status == 403) return _RefreshOutcome.rejected;
      return _RefreshOutcome.failed;
    } on DtoParsingException {
      return _RefreshOutcome.failed;
    }
  }
}
