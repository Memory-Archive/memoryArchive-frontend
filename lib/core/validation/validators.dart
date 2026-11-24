/// Form validators. The limits are the backend's own input rules
/// (backend documentation, "Input rules"), so the app never sends something
/// the server will reject:
/// * usernames: 3–30 characters, letters, numbers, `_` and `.`
/// * passwords: 8–128 characters
/// * emails: lowercased before saving
typedef Validator = String? Function(String? value);

abstract final class AuthRules {
  static const int usernameMin = 3;
  static const int usernameMax = 30;
  static const int passwordMin = 8;
  static const int passwordMax = 128;

  static final RegExp usernamePattern = RegExp(r'^[A-Za-z0-9_.]+$');
  static final RegExp emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
}

abstract final class Validators {
  /// Runs the validators in order and returns the first message.
  static Validator compose(List<Validator> validators) => (value) {
        for (final validator in validators) {
          final message = validator(value);
          if (message != null) return message;
        }
        return null;
      };

  static Validator required(String message) =>
      (value) => (value == null || value.trim().isEmpty) ? message : null;

  static Validator email() => (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return null; // `required` handles empty fields.
        return AuthRules.emailPattern.hasMatch(text) ? null : 'Enter a valid email address';
      };

  static Validator username() => (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return null;
        if (text.length < AuthRules.usernameMin) {
          return 'Use at least ${AuthRules.usernameMin} characters';
        }
        if (text.length > AuthRules.usernameMax) {
          return 'Use ${AuthRules.usernameMax} characters or fewer';
        }
        if (!AuthRules.usernamePattern.hasMatch(text)) {
          return 'Use only letters, numbers, dots and underscores';
        }
        return null;
      };

  /// For creating a password (sign up). Log in only checks that the
  /// password isn't empty.
  static Validator newPassword() => (value) {
        final text = value ?? '';
        if (text.isEmpty) return null;
        if (text.length < AuthRules.passwordMin) {
          return 'Use at least ${AuthRules.passwordMin} characters';
        }
        if (text.length > AuthRules.passwordMax) {
          return 'Use ${AuthRules.passwordMax} characters or fewer';
        }
        return null;
      };

  static Validator matches(String Function() other, String message) =>
      (value) => (value ?? '') == other() ? null : message;
}
