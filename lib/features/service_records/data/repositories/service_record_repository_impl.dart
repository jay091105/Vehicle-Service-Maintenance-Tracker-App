import '../../domain/entities/service_record.dart';
import '../../domain/repositories/service_record_repository.dart';
import '../datasources/service_record_remote_datasource.dart';
import '../models/service_record_model.dart';

class ServiceRecordRepositoryImpl implements ServiceRecordRepository {
  ServiceRecordRepositoryImpl({
    required ServiceRecordRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ServiceRecordRemoteDataSource _remoteDataSource;

  @override
  Stream<List<ServiceRecord>> watchServiceRecords() {
    return _remoteDataSource.watchServiceRecords();
  }

  @override
  Future<void> addServiceRecord(ServiceRecord record) async {
    final model = ServiceRecordModel(
      id: record.id,
      vehicleName: record.vehicleName,
      serviceType: record.serviceType,
      serviceDate: record.serviceDate,
      notes: record.notes,
      mileage: record.mileage,
    );

    await _remoteDataSource.addServiceRecord(model);
  }

  @override
  Future<List<ServiceRecord>> getServiceRecords() async {
    return _remoteDataSource.watchServiceRecords().first;
  }

  @override
  Future<void> updateServiceRecord(ServiceRecord record) async {
    final model = ServiceRecordModel(
      id: record.id,
      vehicleName: record.vehicleName,
      serviceType: record.serviceType,
      serviceDate: record.serviceDate,
      notes: record.notes,
      mileage: record.mileage,
    );
    await _remoteDataSource.updateServiceRecord(model);
  }

  @override
  Future<void> deleteServiceRecord(String recordId) async {
    await _remoteDataSource.deleteServiceRecord(recordId);
  }
}
