import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/vehicle_remote_datasource.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

final vehicleFirebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final vehicleFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final vehicleRemoteDataSourceProvider = Provider<VehicleRemoteDataSource>((
  ref,
) {
  final auth = ref.watch(vehicleFirebaseAuthProvider);
  final firestore = ref.watch(vehicleFirestoreProvider);
  return FirestoreVehicleRemoteDataSource(firestore: firestore, auth: auth);
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final remoteDataSource = ref.watch(vehicleRemoteDataSourceProvider);
  return VehicleRepositoryImpl(remoteDataSource: remoteDataSource);
});

final vehiclesStreamProvider = StreamProvider<List<Vehicle>>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return repository.getVehicles();
});
