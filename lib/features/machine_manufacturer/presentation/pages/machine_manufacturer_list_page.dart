import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../../core/widgets/master_list_scaffold.dart';
import '../../domain/entities/machine_manufacturer.dart';
import 'machine_manufacturer_detail_page.dart';

import '../../../../core/bloc/search_cubit.dart';

class MachineManufacturerListPage extends StatelessWidget {
  const MachineManufacturerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const _MachineManufacturerListBody(),
    );
  }
}

class _MachineManufacturerListBody extends StatefulWidget {
  const _MachineManufacturerListBody();

  @override
  State<_MachineManufacturerListBody> createState() =>
      _MachineManufacturerListBodyState();
}

class _MachineManufacturerListBodyState
    extends State<_MachineManufacturerListBody> {
  @override
  void initState() {
    super.initState();
    context.read<CrudBloc<MachineManufacturer>>().add(const LoadAll());
  }

  void openDetail(BuildContext context, {MachineManufacturer? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CrudBloc<MachineManufacturer>>(),
          child: MachineManufacturerDetailPage(existing: item),
        ),
      ),
    );
    if (mounted) {
      context.read<CrudBloc<MachineManufacturer>>().add(const LoadAll());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrudBloc<MachineManufacturer>, CrudState<MachineManufacturer>>(
      builder: (context, state) {
        return BlocBuilder<SearchCubit, String>(
          builder: (context, searchQuery) {
            List<MachineManufacturer> items = [];
            if (state is CrudLoaded<MachineManufacturer>) {
              items = state.items
                  .where((m) =>m.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
            }

            return MasterListScaffold(
              title: 'Machine Manufacturers',
              isLoading: state is CrudLoading<MachineManufacturer>,
              errorMessage: state is CrudError<MachineManufacturer> ? state.message : null,
              onAdd: () => openDetail(context),
              onRefresh: () =>
                  context.read<CrudBloc<MachineManufacturer>>().add(const LoadAll()),
              columns: const [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Actions')),
              ],
              rows: items
                  .map(
                    (m) => DataRow(cells: [
                      DataCell(Text('${m.id}')),
                      DataCell(
                        SizedBox(
                          width: 100,
                          child: Text(
                            m.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataCell(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => openDetail(context, item: m),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () => context
                                .read<CrudBloc<MachineManufacturer>>()
                                .add(DeleteItem(m.id!)),
                          ),
                        ],
                      )),
                    ]),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}
