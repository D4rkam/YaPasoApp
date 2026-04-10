class AuthSession {
  final int? userId;
  final String username;
  final String name;
  final String email;
  final bool hasToken;

  const AuthSession({
    required this.userId,
    required this.username,
    required this.name,
    required this.email,
    required this.hasToken,
  });
}
