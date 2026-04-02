class AuthRemoteDataSourceException implements Exception {
  const AuthRemoteDataSourceException(this.message);

  final String message;
}

abstract class AuthRemoteDataSource {
  Future<void> signUp({required String email, required String password});

  Future<void> login({required String email, required String password});
}

class DirectAuthRemoteDataSource implements AuthRemoteDataSource {
  static const String _allowedEmail = 'abc@gmail.com';
  static const String _allowedPassword = '123456789';

  @override
  Future<void> signUp({required String email, required String password}) async {
    throw const AuthRemoteDataSourceException(
      'Signup is disabled. Use the provided login credentials.',
    );
  }

  @override
  Future<void> login({required String email, required String password}) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail != _allowedEmail || password != _allowedPassword) {
      throw const AuthRemoteDataSourceException('Invalid email or password.');
    }
  }
}
