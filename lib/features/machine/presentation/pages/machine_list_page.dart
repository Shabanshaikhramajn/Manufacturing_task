import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../../core/widgets/master_list_scaffold.dart';
import '../../../machine_manufacturer/domain/entities/machine_manufacturer.dart';
import '../../../location/domain/entities/location.dart';
import '../../domain/entities/machine.dart';
import 'machine_detail_page.dart';

class MachineListPage extends StatefulWidget {
  const MachineListPage({super.key});

  @override
  State<MachineListPage> createState() => MachineListPageState();
}

class MachineListPageState extends State<MachineListPage> {
  @override
  void initState() {
    super.initState();
    context.read<CrudBloc<Machine>>().add(const LoadAll());
    context.read<CrudBloc<MachineManufacturer>>().add(const LoadAll());
    context.read<CrudBloc<Location>>().add(const LoadAll());
  }

  void openDetail(BuildContext context, {Machine? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<CrudBloc<Machine>>()),
            BlocProvider.value(value: context.read<CrudBloc<MachineManufacturer>>()),
            BlocProvider.value(value: context.read<CrudBloc<Location>>()),
          ],
          child: MachineDetailPage(existing: item),
        ),
      ),
    );
    if (mounted) context.read<CrudBloc<Machine>>().add(const LoadAll());
  }

  String manufacturerName(BuildContext context, int? id) {
    final state = context.read<CrudBloc<MachineManufacturer>>().state;
    if (id == null || state is! CrudLoaded<MachineManufacturer>) return '-';
    final match = state.items.where((m) => m.id == id);
    return match.isEmpty ? '-' : match.first.name;
  }

  String locationName(BuildContext context, int? id) {
    final state = context.read<CrudBloc<Location>>().state;
    if (id == null || state is! CrudLoaded<Location>) return '-';
    final match = state.items.where((l) => l.id == id);
    return match.isEmpty ? '-' : match.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrudBloc<Machine>, CrudState<Machine>>(
      builder: (context, state) {
        List<Machine> items = [];
        if (state is CrudLoaded<Machine>) items = state.items;

        return MasterListScaffold(
          title: 'Machines',
          isLoading: state is CrudLoading<Machine>,
          errorMessage: state is CrudError<Machine> ? state.message : null,
          onAdd: () => openDetail(context),
          onRefresh: () => context.read<CrudBloc<Machine>>().add(const LoadAll()),
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Serial No')),
            DataColumn(label: Text('Manufacturer')),
            DataColumn(label: Text('Model')),
            DataColumn(label: Text('Year')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Location')),
            DataColumn(label: Text('Actions')),
          ],
          rows: items
              .map((m) => DataRow(cells: [
                    DataCell(Text('${m.id}')),
                    DataCell(Text(m.machineName)),
                    DataCell(Text(m.machineSerialNumber ?? '-')),
                    DataCell(Text(manufacturerName(context, m.machineManufacturerId))),
                    DataCell(Text(m.machineModel ?? '-')),
                    DataCell(Text('${m.yearOfManufacture ?? '-'}')),
                    DataCell(Text(m.typeOfMachine.label)),
                    DataCell(Text(locationName(context, m.locationId))),
                    DataCell(Row(children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => openDetail(context, item: m),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () =>
                            context.read<CrudBloc<Machine>>().add(DeleteItem(m.id!)),
                      ),
                    ])),
                  ]))
              .toList(),
        );
      },
    );
  }
}
