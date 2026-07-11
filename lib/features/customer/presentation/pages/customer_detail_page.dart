import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../domain/entities/customer.dart';

class CustomerDetailPage extends StatefulWidget {
  final Customer? existing;
  const CustomerDetailPage({super.key, this.existing});

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
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
    final entity = Customer(id: widget.existing?.id, name: nameController.text.trim());
    final bloc = context.read<CrudBloc<Customer>>();
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
      appBar: AppBar(title: Text(isEdit ? 'Edit Customer' : 'Add Customer')),
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
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
