import '../../domain/entities/service_record.dart';

class ServiceRecordModel extends ServiceRecord {
  const ServiceRecordModel({
    required super.id,
    required super.vehicleName,
    required super.serviceType,
    required super.serviceDate,
    super.notes,
    super.mileage,
  });

  factory ServiceRecordModel.fromMap(Map<dynamic, dynamic> map) {
    return ServiceRecordModel(
      id: map['id'] as String,
      vehicleName: map['vehicleName'] as String,
      serviceType: map['serviceType'] as String,
      serviceDate: DateTime.parse(map['serviceDate'] as String),
      notes: map['notes'] as String?,
      mileage: map['mileage'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleName': vehicleName,
      'serviceType': serviceType,
      'serviceDate': serviceDate.toIso8601String(),
      'notes': notes,
      'mileage': mileage,
    };
  }
}
