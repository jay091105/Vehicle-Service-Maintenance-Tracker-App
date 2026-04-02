import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/service_record_remote_datasource.dart';
import '../../data/repositories/service_record_repository_impl.dart';
import '../../domain/repositories/service_record_repository.dart';

final serviceRecordRemoteDataSourceProvider =
    Provider<ServiceRecordRemoteDataSource>((ref) {
      return InMemoryServiceRecordRemoteDataSource();
    });

final serviceRecordRepositoryProvider = Provider<ServiceRecordRepository>((
  ref,
) {
  final remoteDataSource = ref.watch(serviceRecordRemoteDataSourceProvider);

  return ServiceRecordRepositoryImpl(remoteDataSource: remoteDataSource);
});
