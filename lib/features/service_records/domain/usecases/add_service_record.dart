import '../entities/service_record.dart';
import '../repositories/service_record_repository.dart';

class AddServiceRecord {
  const AddServiceRecord(this._repository);

  final ServiceRecordRepository _repository;

  Future<void> call(ServiceRecord record) {
    return _repository.addServiceRecord(record);
  }
}
