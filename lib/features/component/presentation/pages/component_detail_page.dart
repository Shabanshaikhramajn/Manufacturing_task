import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../domain/entities/component.dart';
import '../cubit/component_form_cubit.dart';

class ComponentDetailPage extends StatelessWidget {
  final Component? existing;
  const ComponentDetailPage({super.key, this.existing});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComponentFormCubit(
        initialCustomerId: existing?.customerId,
        initialName: existing?.componentName,
        initialPartNo: existing?.partNo,
        initialEcn: existing?.ecn,
      ),
      child: ComponentDetailBody(existing: existing),
    );
  }
}

class ComponentDetailBody extends StatefulWidget {
  final Component? existing;
  const ComponentDetailBody({super.key, this.existing});

  @override
  State<ComponentDetailBody> createState() => ComponentDetailBodyState();
}

class ComponentDetailBodyState extends State<ComponentDetailBody> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController partNoController;
  late final TextEditingController ecnController;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    nameController = TextEditingController(text: e?.componentName ?? '');
    partNoController = TextEditingController(text: e?.partNo ?? '');
    ecnController = TextEditingController(text: e?.ecn ?? '');
    context.read<CrudBloc<Customer>>().add(const LoadAll());
  }

  @override
  void dispose() {
    nameController.dispose();
    partNoController.dispose();
    ecnController.dispose();
    super.dispose();
  }

  void save() {
    if (!formKey.currentState!.validate()) return;
    final formState = context.read<ComponentFormCubit>().state;
    final entity = Component(
      id: widget.existing?.id,
      customerId: formState.customerId,
      componentName: nameController.text.trim(),
      partNo: partNoController.text.trim(),
      ecn: ecnController.text.trim(),
    );
    final bloc = context.read<CrudBloc<Component>>();
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
    final cubit = context.read<ComponentFormCubit>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Component' : 'Add Component'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Component Details', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Enter the information for the manufacturing component.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      BlocBuilder<CrudBloc<Customer>, CrudState<Customer>>(
                        builder: (context, state) {
                          final options = state is CrudLoaded<Customer> ? state.items : <Customer>[];
                          return BlocBuilder<ComponentFormCubit, ComponentFormState>(
                            buildWhen: (previous, current) => previous.customerId != current.customerId,
                            builder: (context, formState) {
                              return DropdownButtonFormField<int>(
                                value: formState.customerId,
                                decoration: const InputDecoration(
                                  labelText: 'Customer',
                                ),
                                items: options
                                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                                    .toList(),
                                onChanged: cubit.updateCustomerId,
                                validator: (v) => v == null ? 'Please select a customer' : null,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Component Name',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Component name required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: partNoController,
                        decoration: const InputDecoration(
                          labelText: 'Part Number',
                          ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Part number required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: ecnController,
                        decoration: const InputDecoration(
                          labelText: 'ECN',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'ECN required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: save,
                child: Text(isEdit ? 'Update Component' : 'Create Component'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
