import '../entities/service_record.dart';
import '../repositories/service_record_repository.dart';

class GetServiceRecords {
  const GetServiceRecords(this._repository);

  final ServiceRecordRepository _repository;

  Future<List<ServiceRecord>> call() {
    return _repository.getServiceRecords();
  }
}
