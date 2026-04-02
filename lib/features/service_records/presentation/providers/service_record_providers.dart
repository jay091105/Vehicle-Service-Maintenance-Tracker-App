import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/service_record_remote_datasource.dart';
import '../../data/repositories/service_record_repository_impl.dart';
import '../../domain/repositories/service_record_repository.dart';

final serviceFirebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final serviceFirebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final serviceRecordRemoteDataSourceProvider =
    Provider<ServiceRecordRemoteDataSource>((ref) {
      final auth = ref.watch(serviceFirebaseAuthProvider);
      final firestore = ref.watch(serviceFirebaseFirestoreProvider);
      return FirestoreServiceRecordRemoteDataSource(
        firestore: firestore,
        auth: auth,
      );
    });

final serviceRecordRepositoryProvider = Provider<ServiceRecordRepository>((
  ref,
) {
  final remoteDataSource = ref.watch(serviceRecordRemoteDataSourceProvider);

  return ServiceRecordRepositoryImpl(remoteDataSource: remoteDataSource);
});
