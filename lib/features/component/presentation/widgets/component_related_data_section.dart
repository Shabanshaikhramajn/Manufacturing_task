import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../machine/domain/entities/machine.dart';
import '../../../machine_manufacturer/domain/entities/machine_manufacturer.dart';
import '../../../location/domain/entities/location.dart';
import '../../../component_operation/domain/entities/component_operation.dart';

enum RelatedView { machine, componentOperation }

class RelatedViewCubit extends Cubit<RelatedView> {
  RelatedViewCubit() : super(RelatedView.componentOperation);
  void selectView(RelatedView view) => emit(view);
}

class ComponentRelatedDataSection extends StatelessWidget {
  final int componentId;
  const ComponentRelatedDataSection({super.key, required this.componentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RelatedViewCubit(),
      child: _ComponentRelatedDataSectionBody(componentId: componentId),
    );
  }
}

class _ComponentRelatedDataSectionBody extends StatelessWidget {
  final int componentId;
  const _ComponentRelatedDataSectionBody({required this.componentId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<RelatedViewCubit>();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Linked Data', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              'Pick what you want to see for this component.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            BlocBuilder<RelatedViewCubit, RelatedView>(
              builder: (context, view) {
                return DropdownButtonFormField<RelatedView>(
                  value: view,
                  decoration: const InputDecoration(
                    labelText: 'View related',
                    prefixIcon: Icon(Icons.link),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: RelatedView.componentOperation,
                      child: Text('Component Operation'),
                    ),
                    DropdownMenuItem(
                      value: RelatedView.machine,
                      child: Text('Machine'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) cubit.selectView(value);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<RelatedViewCubit, RelatedView>(
              builder: (context, view) {
                return BlocBuilder<CrudBloc<ComponentOperation>, CrudState<ComponentOperation>>(
                  builder: (context, opState) {
                    final allOps = opState is CrudLoaded<ComponentOperation> ? opState.items : <ComponentOperation>[];
                    final ops = allOps.where((o) => o.componentId == componentId).toList();

                    if (view == RelatedView.componentOperation) {
                      return _ComponentOperationTable(ops: ops);
                    }
                    return LinkedMachinesTable(ops: ops);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ComponentOperationTable extends StatelessWidget {
  final List<ComponentOperation> ops;
  const _ComponentOperationTable({required this.ops});

  @override
  Widget build(BuildContext context) {
    if (ops.isEmpty) {
      return const EmptyLinkedState(message: 'No operations recorded for this component yet.');
    }

    return BlocBuilder<CrudBloc<Machine>, CrudState<Machine>>(
      builder: (context, machineState) {
        final machines = machineState is CrudLoaded<Machine> ? machineState.items : <Machine>[];
        String machineName(int? id) {
          if (id == null) return '-';
          final match = machines.where((m) => m.id == id);
          return match.isEmpty ? '-' : match.first.machineName;
        }

        return RelatedTable(
          columns: const ['Operation Code', 'Operation Name', 'Machine', 'Operation Type'],
          rows: ops
              .map((o) => [
                    o.operationCode ?? '-',
                    o.operationName,
                    machineName(o.machineId),
                    o.operationType.label,
                  ])
              .toList(),
        );
      },
    );
  }
}

class LinkedMachinesTable extends StatelessWidget {
  final List<ComponentOperation> ops;
  const LinkedMachinesTable({required this.ops});

  @override
  Widget build(BuildContext context) {
    final machineIds = ops.map((o) => o.machineId).whereType<int>().toSet();

    if (machineIds.isEmpty) {
      return const EmptyLinkedState(
        message: 'No machine is linked yet. Add a component operation for this component first.',
      );
    }

    return BlocBuilder<CrudBloc<Machine>, CrudState<Machine>>(
      builder: (context, machineState) {
        final machines = machineState is CrudLoaded<Machine> ? machineState.items : <Machine>[];
        final linkedMachines = machines.where((m) => machineIds.contains(m.id)).toList();

        return BlocBuilder<CrudBloc<MachineManufacturer>, CrudState<MachineManufacturer>>(
          builder: (context, manufacturerState) {
            final manufacturers =
                manufacturerState is CrudLoaded<MachineManufacturer> ? manufacturerState.items : <MachineManufacturer>[];
            String manufacturerName(int? id) {
              if (id == null) return '-';
              final match = manufacturers.where((m) => m.id == id);
              return match.isEmpty ? '-' : match.first.name;
            }

            return BlocBuilder<CrudBloc<Location>, CrudState<Location>>(
              builder: (context, locationState) {
                final locations = locationState is CrudLoaded<Location> ? locationState.items : <Location>[];
                String locationName(int? id) {
                  if (id == null) return '-';
                  final match = locations.where((l) => l.id == id);
                  return match.isEmpty ? '-' : match.first.name;
                }

                return RelatedTable(
                  columns: const ['Machine Name', 'Serial No', 'Manufacturer', 'Type', 'Location'],
                  rows: linkedMachines
                      .map((m) => [
                            m.machineName,
                            m.machineSerialNumber ?? '-',
                            manufacturerName(m.machineManufacturerId),
                            m.typeOfMachine.label,
                            locationName(m.locationId),
                          ])
                      .toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}

class RelatedTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  const RelatedTable({required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.primaryContainer.withOpacity(0.5),
          ),
          columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
          rows: rows
              .map((r) => DataRow(cells: r.map((cell) => DataCell(Text(cell))).toList()))
              .toList(),
        ),
      ),
    );
  }
}

class EmptyLinkedState extends StatelessWidget {
  final String message;
  const EmptyLinkedState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[400], size: 32),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
