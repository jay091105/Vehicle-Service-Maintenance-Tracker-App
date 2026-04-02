import 'package:flutter/foundation.dart';

import '../../data/repositories/auth_repository.dart';

class AuthController {
  AuthController({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint(
        '[AuthController] login requested for ${email.trim().toLowerCase()}',
      );
      await _repository.login(email: email, password: password);
      debugPrint('[AuthController] login completed');
      return null;
    } on AuthFailure catch (error) {
      debugPrint('[AuthController] login auth error: ${error.message}');
      return error.message;
    } catch (error, stackTrace) {
      debugPrint('[AuthController] login unexpected error: $error');
      debugPrint('$stackTrace');
      return 'Unexpected login error: $error';
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint(
        '[AuthController] signup requested for ${email.trim().toLowerCase()}',
      );
      await _repository.signUp(email: email, password: password);
      debugPrint('[AuthController] signup completed');
      return null;
    } on AuthFailure catch (error) {
      debugPrint('[AuthController] signup auth error: ${error.message}');
      return error.message;
    } catch (error, stackTrace) {
      debugPrint('[AuthController] signup unexpected error: $error');
      debugPrint('$stackTrace');
      return 'Unexpected signup error: $error';
    }
  }
}
