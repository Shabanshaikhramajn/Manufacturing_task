import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../machine/domain/entities/machine.dart';
import '../../../machine_manufacturer/domain/entities/machine_manufacturer.dart';
import '../../../location/domain/entities/location.dart';
import '../../../component_operation/domain/entities/component_operation.dart';
import '../cubit/linked_master_view_state.dart' show LinkedView;


class LinkedDataTable extends StatelessWidget {
  final int componentId;
  final LinkedView view;
  const LinkedDataTable({super.key, required this.componentId, required this.view});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrudBloc<ComponentOperation>, CrudState<ComponentOperation>>(
      builder: (context, opState) {
        final allOps = opState is CrudLoaded<ComponentOperation> ? opState.items : <ComponentOperation>[];
        final ops = allOps.where((o) => o.componentId == componentId).toList();

        return view == LinkedView.componentOperation
            ? _ComponentOperationTable(ops: ops)
            : LinkedMachinesTable(ops: ops);
      },
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

        return DataTableCard(
          columns: const ['Op Code', 'Op Name', 'Machine', 'Op Type'],
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
            final manufacturers = manufacturerState is CrudLoaded<MachineManufacturer>
                ? manufacturerState.items
                : <MachineManufacturer>[];
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

                return DataTableCard(
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

class DataTableCard extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  const DataTableCard({required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
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
