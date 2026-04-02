import 'dart:async';

import '../models/service_record_model.dart';

abstract class ServiceRecordRemoteDataSource {
  Stream<List<ServiceRecordModel>> watchServiceRecords();

  Future<void> addServiceRecord(ServiceRecordModel record);

  Future<void> updateServiceRecord(ServiceRecordModel record);

  Future<void> deleteServiceRecord(String recordId);
}

class InMemoryServiceRecordRemoteDataSource
    implements ServiceRecordRemoteDataSource {
  InMemoryServiceRecordRemoteDataSource()
    : _recordsController =
          StreamController<List<ServiceRecordModel>>.broadcast() {
    _recordsController.add(const []);
  }

  final List<ServiceRecordModel> _records = [];
  final StreamController<List<ServiceRecordModel>> _recordsController;

  void _emitRecords() {
    final sorted = [..._records]
      ..sort((a, b) => b.serviceDate.compareTo(a.serviceDate));
    _recordsController.add(sorted);
  }

  @override
  Stream<List<ServiceRecordModel>> watchServiceRecords() {
    return _recordsController.stream;
  }

  @override
  Future<void> addServiceRecord(ServiceRecordModel record) async {
    _records.add(record);
    _emitRecords();
  }

  @override
  Future<void> updateServiceRecord(ServiceRecordModel record) async {
    final index = _records.indexWhere((item) => item.id == record.id);
    if (index == -1) {
      return;
    }

    _records[index] = record;
    _emitRecords();
  }

  @override
  Future<void> deleteServiceRecord(String recordId) async {
    _records.removeWhere((item) => item.id == recordId);
    _emitRecords();
  }
}
