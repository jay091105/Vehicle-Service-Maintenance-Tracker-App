class ServiceRecord {
  const ServiceRecord({
    required this.id,
    required this.vehicleName,
    required this.serviceType,
    required this.serviceDate,
    this.notes,
    this.mileage,
  });

  final String id;
  final String vehicleName;
  final String serviceType;
  final DateTime serviceDate;
  final String? notes;
  final int? mileage;
}
