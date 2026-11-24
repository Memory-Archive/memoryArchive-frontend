import '../../../../core/networking/json_helpers.dart';
import '../../../../core/session/app_user.dart';

/// The user object the backend returns from signup and login.
///
/// Only `id`, `username` and `email` are required. Both camelCase and
/// snake_case keys are accepted.
class UserDto {
  const UserDto({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.bio,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: readRequiredString(json, const ['id', 'userId', 'user_id'], 'UserDto'),
        username: readRequiredString(json, const ['username'], 'UserDto'),
        email: readRequiredString(json, const ['email'], 'UserDto'),
        displayName: readString(json, const ['displayName', 'display_name']),
        bio: readString(json, const ['bio']),
      );

  factory UserDto.fromEntity(AppUser user) => UserDto(
        id: user.id,
        username: user.username,
        email: user.email,
        displayName: user.displayName,
        bio: user.bio,
      );

  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? bio;

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        if (displayName != null) 'displayName': displayName,
        if (bio != null) 'bio': bio,
      };

  AppUser toEntity() => AppUser(
        id: id,
        username: username,
        email: email,
        displayName: displayName,
        bio: bio,
      );
}
