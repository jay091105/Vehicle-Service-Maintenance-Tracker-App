import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSourceException implements Exception {
  const AuthRemoteDataSourceException(this.message);

  final String message;
}

abstract class AuthRemoteDataSource {
  Future<void> signUp({required String email, required String password});

  Future<void> login({required String email, required String password});

  Stream<User?> authStateChanges();
}

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw const AuthRemoteDataSourceException(
          'Unable to create account. Missing user id.',
        );
      }

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': normalizedEmail,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (error) {
      throw AuthRemoteDataSourceException(_mapAuthError(error));
    } on FirebaseException catch (error) {
      throw AuthRemoteDataSourceException(
        'Failed to save user profile: ${error.message ?? error.code}',
      );
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthRemoteDataSourceException(_mapAuthError(error));
    }
  }

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  String _mapAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
