import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../domain/entities/machine_manufacturer.dart';

class MachineManufacturerDetailPage extends StatefulWidget {
  final MachineManufacturer? existing;
  const MachineManufacturerDetailPage({super.key, this.existing});

  @override
  State<MachineManufacturerDetailPage> createState() =>
      _MachineManufacturerDetailPageState();
}

class _MachineManufacturerDetailPageState
    extends State<MachineManufacturerDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.existing?.name ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final entity = MachineManufacturer(
      id: widget.existing?.id,
      name: nameController.text.trim(),
    );
    final bloc = context.read<CrudBloc<MachineManufacturer>>();
    if (widget.existing == null) {
      bloc.add(AddItem(entity));
    } else {
      bloc.add(UpdateItem(entity));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Manufacturer' : 'Add Manufacturer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Manufacturer Details',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Enter the information for the machine manufacturer.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Name is required'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Update Manufacturer' : 'Add Manufacturer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
