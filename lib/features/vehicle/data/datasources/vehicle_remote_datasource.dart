import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/vehicle.dart';

abstract class VehicleRemoteDataSource {
  Stream<List<Vehicle>> getVehicles();

  Future<void> addVehicle(Vehicle vehicle);

  Future<void> updateVehicle(Vehicle vehicle);

  Future<void> deleteVehicle(String vehicleId);
}

class FirestoreVehicleRemoteDataSource implements VehicleRemoteDataSource {
  FirestoreVehicleRemoteDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _vehiclesCollection {
    return _firestore.collection('vehicles');
  }

  String _requireUserId() {
    final userId = _auth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      throw StateError('User is not authenticated.');
    }
    return userId;
  }

  @override
  Stream<List<Vehicle>> getVehicles() {
    final userId = _requireUserId();
    return _vehiclesCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Vehicle(
              id: doc.id,
              userId: data['userId'] as String,
              name: data['name'] as String,
              model: data['model'] as String,
              number: data['number'] as String,
              fuelType: data['fuelType'] as String,
            );
          }).toList();
        });
  }

  @override
  Future<void> addVehicle(Vehicle vehicle) async {
    final userId = _requireUserId();
    await _vehiclesCollection.doc(vehicle.id).set({
      'id': vehicle.id,
      'userId': userId,
      'name': vehicle.name,
      'model': vehicle.model,
      'number': vehicle.number,
      'fuelType': vehicle.fuelType,
    });
  }

  @override
  Future<void> updateVehicle(Vehicle vehicle) async {
    final userId = _requireUserId();
    await _vehiclesCollection.doc(vehicle.id).update({
      'id': vehicle.id,
      'userId': userId,
      'name': vehicle.name,
      'model': vehicle.model,
      'number': vehicle.number,
      'fuelType': vehicle.fuelType,
    });
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    _requireUserId();
    await _vehiclesCollection.doc(vehicleId).delete();
  }
}
