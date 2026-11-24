/// Small helpers for reading backend JSON safely.
///
/// Data sources call these when parsing a response. If the backend sends
/// something unexpected, a [DtoParsingException] is thrown, and
/// `safeApiCall` turns it into a friendly [ApiError] instead of a crash.
library;

class DtoParsingException implements Exception {
  DtoParsingException(this.message);

  final String message;

  @override
  String toString() => 'DtoParsingException: $message';
}

/// Every successful backend response looks like
/// `{ "message": "Logged in", "data": { ... } }`.
/// This returns the `data` part (or the whole body if there is no `data`).
Object? unwrapData(Object? body) {
  if (body is Map && body.containsKey('data')) return body['data'];
  return body;
}

Map<String, dynamic> asJsonMap(Object? value, String what) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  throw DtoParsingException('$what: expected a JSON object');
}

List<Object?> asJsonList(Object? value, String what) {
  if (value is List) return value;
  throw DtoParsingException('$what: expected a JSON list');
}

/// Reads the first key that has a value. Accepts both camelCase and
/// snake_case names, so the app keeps working if the backend switches style.
String? readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
  }
  return null;
}

String readRequiredString(Map<String, dynamic> json, List<String> keys, String what) {
  final value = readString(json, keys);
  if (value == null || value.isEmpty) {
    throw DtoParsingException('$what: missing "${keys.first}"');
  }
  return value;
}

int? readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
  }
  return null;
}

/// Parses `"2026-11-22"` (a calendar day) or a full ISO-8601 timestamp.
DateTime? readDate(Map<String, dynamic> json, List<String> keys) {
  final raw = readString(json, keys);
  if (raw == null) return null;
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return null;
  return parsed.isUtc ? parsed.toLocal() : parsed;
}
