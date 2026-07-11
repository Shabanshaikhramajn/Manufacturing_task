import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../../core/enums/operation_type_enum.dart';
import '../../../component/domain/entities/component.dart';
import '../../../machine/domain/entities/machine.dart';
import '../../domain/entities/component_operation.dart';

import '../cubit/component_operation_form_cubit.dart';

class ComponentOperationDetailPage extends StatelessWidget {
  final ComponentOperation? existing;
  const ComponentOperationDetailPage({super.key, this.existing});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComponentOperationFormCubit(
        initialComponentId: existing?.componentId,
        initialMachineId: existing?.machineId,
        initialType: existing?.operationType,
      ),
      child: ComponentOperationDetailBody(existing: existing),
    );
  }
}

class ComponentOperationDetailBody extends StatefulWidget {
  final ComponentOperation? existing;
  const ComponentOperationDetailBody({this.existing});

  @override
  State<ComponentOperationDetailBody> createState() => ComponentOperationDetailBodyState();
}

class ComponentOperationDetailBodyState extends State<ComponentOperationDetailBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController codeController;
  late final TextEditingController nameController;
  late final TextEditingController descController;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    codeController = TextEditingController(text: e?.operationCode ?? '');
    nameController = TextEditingController(text: e?.operationName ?? '');
    descController = TextEditingController(text: e?.operationDescription ?? '');

    context.read<CrudBloc<Component>>().add(const LoadAll());
    context.read<CrudBloc<Machine>>().add(const LoadAll());
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final formState = context.read<ComponentOperationFormCubit>().state;
    final entity = ComponentOperation(
      id: widget.existing?.id,
      componentId: formState.componentId,
      machineId: formState.machineId,
      operationCode: codeController.text.trim(),
      operationName: nameController.text.trim(),
      operationDescription: descController.text.trim(),
      operationType: formState.type,
    );
    final bloc = context.read<CrudBloc<ComponentOperation>>();
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
    final cubit = context.read<ComponentOperationFormCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Component Operation' : 'Add Component Operation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Component dropdown
              BlocBuilder<CrudBloc<Component>, CrudState<Component>>(
                builder: (context, state) {
                  final options = state is CrudLoaded<Component> ? state.items : <Component>[];
                  return BlocBuilder<ComponentOperationFormCubit, ComponentOperationFormState>(
                    buildWhen: (prev, curr) => prev.componentId != curr.componentId,
                    builder: (context, formState) {
                      return DropdownButtonFormField<int>(
                        value: formState.componentId,
                        decoration: const InputDecoration(labelText: 'Component'),
                        items: options
                            .map((c) => DropdownMenuItem(value: c.id, child: Text(c.componentName)))
                            .toList(),
                        onChanged: cubit.updateComponentId,
                        validator: (v) => v == null ? 'Please select a component' : null,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
                BlocBuilder<CrudBloc<Machine>, CrudState<Machine>>(
                builder: (context, state) {
                  final options = state is CrudLoaded<Machine> ? state.items : <Machine>[];
                  return BlocBuilder<ComponentOperationFormCubit, ComponentOperationFormState>(
                    buildWhen: (prev, curr) => prev.machineId != curr.machineId,
                    builder: (context, formState) {
                      return DropdownButtonFormField<int>(
                        value: formState.machineId,
                        decoration: const InputDecoration(labelText: 'Machine'),
                        items: options
                            .map((m) => DropdownMenuItem(value: m.id, child: Text(m.machineName)))
                            .toList(),
                        onChanged: cubit.updateMachineId,
                        validator: (v) => v == null ? 'Please select a machine' : null,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Operation Code'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Operation Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Operation Description'),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Description required' : null,
              ),

              const SizedBox(height: 16),

              BlocBuilder<ComponentOperationFormCubit, ComponentOperationFormState>(
                buildWhen: (prev, curr) => prev.type != curr.type,
                builder: (context, formState) {
                  return DropdownButtonFormField<OperationType>(
                    value: formState.type,
                    decoration: const InputDecoration(labelText: 'Operation Type'),
                    items: OperationType.values
                        .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) cubit.updateType(v);
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
