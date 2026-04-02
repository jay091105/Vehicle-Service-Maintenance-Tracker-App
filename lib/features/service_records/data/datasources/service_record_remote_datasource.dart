import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/service_record_model.dart';

abstract class ServiceRecordRemoteDataSource {
  Stream<List<ServiceRecordModel>> watchServiceRecords();

  Future<void> addServiceRecord(ServiceRecordModel record);

  Future<void> updateServiceRecord(ServiceRecordModel record);

  Future<void> deleteServiceRecord(String recordId);
}

class FirestoreServiceRecordRemoteDataSource
    implements ServiceRecordRemoteDataSource {
  FirestoreServiceRecordRemoteDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _recordsCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('service_records');
  }

  String _requireUserId() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw StateError('User is not authenticated.');
    }
    return uid;
  }

  @override
  Stream<List<ServiceRecordModel>> watchServiceRecords() {
    final userId = _requireUserId();
    return _recordsCollection(
      userId,
    ).orderBy('serviceDate', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ServiceRecordModel.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }

  @override
  Future<void> addServiceRecord(ServiceRecordModel record) async {
    final userId = _requireUserId();
    await _recordsCollection(userId).doc(record.id).set(record.toMap());
  }

  @override
  Future<void> updateServiceRecord(ServiceRecordModel record) async {
    final userId = _requireUserId();
    await _recordsCollection(userId).doc(record.id).update(record.toMap());
  }

  @override
  Future<void> deleteServiceRecord(String recordId) async {
    final userId = _requireUserId();
    await _recordsCollection(userId).doc(recordId).delete();
  }
}
