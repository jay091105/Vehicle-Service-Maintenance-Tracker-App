import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/service_record.dart';
import '../../domain/usecases/add_service_record.dart';
import '../../domain/usecases/get_service_records.dart';
import '../providers/service_record_providers.dart';

class ServiceRecordsController
    extends AutoDisposeAsyncNotifier<List<ServiceRecord>> {
  late final GetServiceRecords _getServiceRecords;
  late final AddServiceRecord _addServiceRecord;
  late final StreamSubscription<List<ServiceRecord>> _recordsSubscription;

  @override
  Future<List<ServiceRecord>> build() async {
    _getServiceRecords = ref.read(getServiceRecordsUseCaseProvider);
    _addServiceRecord = ref.read(addServiceRecordUseCaseProvider);

    final repository = ref.read(serviceRecordRepositoryProvider);
    _recordsSubscription = repository.watchServiceRecords().listen(
      (records) {
        state = AsyncData(records);
      },
      onError: (error, stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );
    ref.onDispose(_recordsSubscription.cancel);

    return _getServiceRecords();
  }

  Future<void> addRecord(ServiceRecord record) async {
    await _addServiceRecord(record);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _getServiceRecords());
  }
}

final serviceRecordsControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      ServiceRecordsController,
      List<ServiceRecord>
    >(ServiceRecordsController.new);

final getServiceRecordsUseCaseProvider = Provider<GetServiceRecords>((ref) {
  final repository = ref.watch(serviceRecordRepositoryProvider);
  return GetServiceRecords(repository);
});

final addServiceRecordUseCaseProvider = Provider<AddServiceRecord>((ref) {
  final repository = ref.watch(serviceRecordRepositoryProvider);
  return AddServiceRecord(repository);
});
