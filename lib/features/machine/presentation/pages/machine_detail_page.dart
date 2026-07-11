import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../../core/enums/machine_type_enum.dart';
import '../../../machine_manufacturer/domain/entities/machine_manufacturer.dart';
import '../../../location/domain/entities/location.dart';
import '../../domain/entities/machine.dart';

import '../cubit/machine_form_cubit.dart';

class MachineDetailPage extends StatelessWidget {
  final Machine? existing;
  const MachineDetailPage({super.key, this.existing});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MachineFormCubit(
        initialManufacturerId: existing?.machineManufacturerId,
        initialLocationId: existing?.locationId,
        initialType: existing?.typeOfMachine,
      ),
      child: MachineDetailBody(existing: existing),
    );
  }
}

class MachineDetailBody extends StatefulWidget {
  final Machine? existing;
  const MachineDetailBody({this.existing});

  @override
  State<MachineDetailBody> createState() => MachineDetailBodyState();
}

class MachineDetailBodyState extends State<MachineDetailBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController serialController;
  late final TextEditingController modelController;
  late final TextEditingController yearController;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    nameController = TextEditingController(text: e?.machineName ?? '');
    serialController = TextEditingController(text: e?.machineSerialNumber ?? '');
    modelController = TextEditingController(text: e?.machineModel ?? '');
    yearController = TextEditingController(text: e?.yearOfManufacture?.toString() ?? '');


    context.read<CrudBloc<MachineManufacturer>>().add(const LoadAll());
    context.read<CrudBloc<Location>>().add(const LoadAll());
  }

  @override
  void dispose() {
    nameController.dispose();
    serialController.dispose();
    modelController.dispose();
    yearController.dispose();
    super.dispose();
  }

  void save() {
    if (!_formKey.currentState!.validate()) return;
    final formState = context.read<MachineFormCubit>().state;
    final entity = Machine(
      id: widget.existing?.id,
      machineName: nameController.text.trim(),
      machineSerialNumber: serialController.text.trim(),
      machineManufacturerId: formState.manufacturerId,
      machineModel: modelController.text.trim(),
      yearOfManufacture: int.tryParse(yearController.text.trim()),
      typeOfMachine: formState.type,
      locationId: formState.locationId,
    );
    final bloc = context.read<CrudBloc<Machine>>();
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
    final cubit = context.read<MachineFormCubit>();
    
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Machine' : 'Add Machine')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Machine Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Machine name required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: serialController,
                decoration: const InputDecoration(labelText: 'Machine Serial Number'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Serial number required' : null,
              ),
              const SizedBox(height: 16),

              // Manufacturer dropdown
              BlocBuilder<CrudBloc<MachineManufacturer>, CrudState<MachineManufacturer>>(
                builder: (context, state) {
                  final options = state is CrudLoaded<MachineManufacturer> ? state.items : <MachineManufacturer>[];
                  return BlocBuilder<MachineFormCubit, MachineFormState>(
                    buildWhen: (prev, curr) => prev.manufacturerId != curr.manufacturerId,
                    builder: (context, formState) {
                      return DropdownButtonFormField<int>(
                        value: formState.manufacturerId,
                        decoration: const InputDecoration(labelText: 'Machine Manufacturer'),
                        items: options
                            .map((m) => DropdownMenuItem(value: m.id, child: Text(m.name)))
                            .toList(),
                        onChanged: cubit.updateManufacturerId,
                        validator: (v) => v == null ? 'Please select a manufacturer' : null,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Machine Model'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Machine model required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year of Manufacture'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Year required' : null,
              ),
              const SizedBox(height: 16),

              // Type of Machine dropdown
              BlocBuilder<MachineFormCubit, MachineFormState>(
                buildWhen: (prev, curr) => prev.type != curr.type,
                builder: (context, formState) {
                  return DropdownButtonFormField<MachineType>(
                    value: formState.type,
                    decoration: const InputDecoration(labelText: 'Type of Machine'),
                    items: MachineType.values
                        .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) cubit.updateType(v);
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Location dropdown
              BlocBuilder<CrudBloc<Location>, CrudState<Location>>(
                builder: (context, state) {
                  final options = state is CrudLoaded<Location> ? state.items : <Location>[];
                  return BlocBuilder<MachineFormCubit, MachineFormState>(
                    buildWhen: (prev, curr) => prev.locationId != curr.locationId,
                    builder: (context, formState) {
                      return DropdownButtonFormField<int>(
                        value: formState.locationId,
                        decoration: const InputDecoration(labelText: 'Location'),
                        items: options
                            .map((l) => DropdownMenuItem(value: l.id, child: Text(l.name)))
                            .toList(),
                        onChanged: cubit.updateLocationId,
                        validator: (v) => v == null ? 'Please select a location' : null,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
              ElevatedButton(onPressed: save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
