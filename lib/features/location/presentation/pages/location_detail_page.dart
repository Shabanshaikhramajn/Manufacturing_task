import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../domain/entities/location.dart';

class LocationDetailPage extends StatefulWidget {
  final Location? existing;
  const LocationDetailPage({super.key, this.existing});

  @override
  State<LocationDetailPage> createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController latController;
  late final TextEditingController lngController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.existing?.name ?? '');
    latController = TextEditingController(text: widget.existing?.latitude?.toString() ?? '');
    lngController = TextEditingController(text: widget.existing?.longitude?.toString() ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    latController.dispose();
    lngController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final entity = Location(
      id: widget.existing?.id,
      name: nameController.text.trim(),
      latitude: double.tryParse(latController.text.trim()),
      longitude: double.tryParse(lngController.text.trim()),
    );
    final bloc = context.read<CrudBloc<Location>>();
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
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Location' : 'Add Location')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: latController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lngController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              ),
              const SizedBox(height: 18),

             ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
