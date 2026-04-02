class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
  });

  final int id;
  final String email;
  final String passwordHash;
  final String salt;
  final DateTime createdAt;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'salt': salt,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AuthUser.fromMap(Map<String, Object?> map) {
    return AuthUser(
      id: map['id'] as int,
      email: map['email'] as String,
      passwordHash: map['passwordHash'] as String,
      salt: map['salt'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
