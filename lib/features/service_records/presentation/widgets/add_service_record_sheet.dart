import 'package:flutter/material.dart';

class AddServiceRecordResult {
  AddServiceRecordResult({
    required this.vehicleName,
    required this.serviceType,
    required this.serviceDate,
    this.notes,
    this.mileage,
  });

  final String vehicleName;
  final String serviceType;
  final DateTime serviceDate;
  final String? notes;
  final int? mileage;
}

class AddServiceRecordSheet extends StatefulWidget {
  const AddServiceRecordSheet({super.key});

  @override
  State<AddServiceRecordSheet> createState() => _AddServiceRecordSheetState();
}

class _AddServiceRecordSheetState extends State<AddServiceRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleController = TextEditingController();
  final _serviceTypeController = TextEditingController();
  final _notesController = TextEditingController();
  final _mileageController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _vehicleController.dispose();
    _serviceTypeController.dispose();
    _notesController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Service Record',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehicleController,
                decoration: const InputDecoration(labelText: 'Vehicle Name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _serviceTypeController,
                decoration: const InputDecoration(labelText: 'Service Type'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Mileage (km)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${_selectedDate.toLocal().toString().split(' ').first}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submit,
                child: const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final mileage = int.tryParse(_mileageController.text.trim());
    final notes = _notesController.text.trim();

    Navigator.of(context).pop(
      AddServiceRecordResult(
        vehicleName: _vehicleController.text.trim(),
        serviceType: _serviceTypeController.text.trim(),
        serviceDate: _selectedDate,
        mileage: mileage,
        notes: notes.isEmpty ? null : notes,
      ),
    );
  }
}
