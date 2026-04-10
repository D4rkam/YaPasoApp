class AuthUserDto {
  final int? id;
  final String username;
  final String name;
  final String email;
  final Map<String, dynamic>? token;
  final Map<String, dynamic> raw;

  const AuthUserDto({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.token,
    required this.raw,
  });

  bool get hasToken {
    final access = token?['access_token']?.toString() ?? '';
    return access.isNotEmpty;
  }

  factory AuthUserDto.fromMap(Map<String, dynamic> map) {
    return AuthUserDto(
      id: _safeInt(map['id']),
      username: map['username']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      token: _safeMap(map['token']),
      raw: Map<String, dynamic>.from(map),
    );
  }

  Map<String, dynamic> toStorageMap() => raw;
}

int? _safeInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

Map<String, dynamic>? _safeMap(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
