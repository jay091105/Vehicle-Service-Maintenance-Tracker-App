import 'package:flutter/foundation.dart';

import '../datasources/auth_remote_datasource.dart';

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;
}

class AuthRepository {
  AuthRepository({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _remoteDataSource.signUp(email: email, password: password);
      debugPrint(
        '[AuthRepository] signup success for ${email.trim().toLowerCase()}',
      );
    } on AuthRemoteDataSourceException catch (error) {
      throw AuthFailure(error.message);
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _remoteDataSource.login(email: email, password: password);
      debugPrint(
        '[AuthRepository] login success for ${email.trim().toLowerCase()}',
      );
    } on AuthRemoteDataSourceException catch (error) {
      throw AuthFailure(error.message);
    }
  }
}
