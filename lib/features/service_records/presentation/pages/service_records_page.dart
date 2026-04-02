import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';
import '../../domain/entities/service_record.dart';
import '../controllers/service_records_controller.dart';
import '../widgets/add_service_record_sheet.dart';
import '../widgets/service_record_card.dart';

class ServiceRecordsPage extends ConsumerWidget {
  const ServiceRecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsState = ref.watch(serviceRecordsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Service Tracker')),
      body: recordsState.when(
        data: (records) {
          if (records.isEmpty) {
            return const Center(
              child: Text('No service records yet. Tap + to add one.'),
            );
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              return ServiceRecordCard(record: records[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Failed to load records: $error'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onAddRecord(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Service'),
      ),
    );
  }

  Future<void> _onAddRecord(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<AddServiceRecordResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddServiceRecordSheet(),
    );

    if (result == null) {
      return;
    }

    final record = ServiceRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      vehicleName: result.vehicleName,
      serviceType: result.serviceType,
      serviceDate: result.serviceDate,
      mileage: result.mileage,
      notes: result.notes,
    );

    await ref.read(serviceRecordsControllerProvider.notifier).addRecord(record);

    await NotificationService.instance.showServiceReminder(
      vehicleName: result.vehicleName,
      serviceType: result.serviceType,
    );
  }
}
