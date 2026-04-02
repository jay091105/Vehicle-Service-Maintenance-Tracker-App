import 'package:flutter/material.dart';

import '../../domain/entities/service_record.dart';

class ServiceRecordCard extends StatelessWidget {
  const ServiceRecordCard({super.key, required this.record});

  final ServiceRecord record;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.vehicleName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(record.serviceType),
            const SizedBox(height: 8),
            Text(
              'Date: ${record.serviceDate.toLocal().toString().split(' ').first}',
            ),
            if (record.mileage != null) Text('Mileage: ${record.mileage} km'),
            if (record.notes != null && record.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Notes: ${record.notes}'),
              ),
          ],
        ),
      ),
    );
  }
}
