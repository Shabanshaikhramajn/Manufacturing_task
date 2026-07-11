import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../component/domain/entities/component.dart';
import '../../../component_operation/domain/entities/component_operation.dart';
import '../../../machine/domain/entities/machine.dart';
import '../../../machine_manufacturer/domain/entities/machine_manufacturer.dart';
import '../../../location/domain/entities/location.dart';
import '../cubit/linked_master_view_cubit.dart';
import '../cubit/linked_master_view_state.dart';
import '../widgets/linked_data_table.dart';

class LinkedMasterViewPage extends StatelessWidget {
  const LinkedMasterViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LinkedMasterViewCubit(),
      child: const LinkedMasterViewBody(),
    );
  }
}

class LinkedMasterViewBody extends StatefulWidget {
  const LinkedMasterViewBody({super.key});

  @override
  State<LinkedMasterViewBody> createState() => LinkedMasterViewBodyState();
}

class LinkedMasterViewBodyState extends State<LinkedMasterViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<CrudBloc<Component>>().add(const LoadAll());
    context.read<CrudBloc<ComponentOperation>>().add(const LoadAll());
    context.read<CrudBloc<Machine>>().add(const LoadAll());
    context.read<CrudBloc<MachineManufacturer>>().add(const LoadAll());
    context.read<CrudBloc<Location>>().add(const LoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<LinkedMasterViewCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Master View')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Component Linked Data', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Select a component and Machine or Component Operation to see its data.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
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
                    BlocBuilder<CrudBloc<Component>, CrudState<Component>>(
                      builder: (context, state) {
                        final options = state is CrudLoaded<Component> ? state.items : <Component>[];
                        return BlocBuilder<LinkedMasterViewCubit, LinkedMasterViewState>(
                          builder: (context, viewState) {
                            return DropdownButtonFormField<int>(
                              value: viewState.selectedComponentId,
                              decoration: const InputDecoration(
                                labelText: 'Component',
                                border: InputBorder.none,
                              ),
                              items: options
                                  .map((c) => DropdownMenuItem(
                                        value: c.id,
                                        child: Text('${c.componentName} (#${c.id})'),
                                      ))
                                  .toList(),
                              onChanged: cubit.selectComponent,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<LinkedMasterViewCubit, LinkedMasterViewState>(
                      builder: (context, viewState) {
                        return DropdownButtonFormField<LinkedView>(
                          value: viewState.view,
                          decoration: const InputDecoration(
                            labelText: 'View related',
                            border: InputBorder.none,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: LinkedView.componentOperation,
                              child: Text('Component Operation'),
                            ),
                            DropdownMenuItem(
                              value: LinkedView.machine,
                              child: Text('Machine'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) cubit.selectView(v);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<LinkedMasterViewCubit, LinkedMasterViewState>(
              builder: (context, viewState) {
                if (viewState.selectedComponentId == null) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                       const SizedBox(height: 8),
                        Text(
                          'Select a component above to see its linked data.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }
                return LinkedDataTable(
                  componentId: viewState.selectedComponentId!,
                  view: viewState.view,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
