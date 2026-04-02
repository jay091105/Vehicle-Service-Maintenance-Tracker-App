import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_datasource.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  VehicleRepositoryImpl({required VehicleRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final VehicleRemoteDataSource _remoteDataSource;

  @override
  Stream<List<Vehicle>> getVehicles() {
    return _remoteDataSource.getVehicles();
  }

  @override
  Future<void> addVehicle(Vehicle vehicle) {
    return _remoteDataSource.addVehicle(vehicle);
  }

  @override
  Future<void> updateVehicle(Vehicle vehicle) {
    return _remoteDataSource.updateVehicle(vehicle);
  }

  @override
  Future<void> deleteVehicle(String vehicleId) {
    return _remoteDataSource.deleteVehicle(vehicleId);
  }
}
