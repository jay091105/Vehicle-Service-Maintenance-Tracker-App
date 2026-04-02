import '../entities/service_record.dart';

abstract class ServiceRecordRepository {
  Stream<List<ServiceRecord>> watchServiceRecords();

  Future<List<ServiceRecord>> getServiceRecords();

  Future<void> addServiceRecord(ServiceRecord record);

  Future<void> updateServiceRecord(ServiceRecord record);

  Future<void> deleteServiceRecord(String recordId);
}
