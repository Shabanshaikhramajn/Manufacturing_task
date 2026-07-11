import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../../core/widgets/master_list_scaffold.dart';
import '../../domain/entities/location.dart';
import 'location_detail_page.dart';

import '../../../../core/bloc/search_cubit.dart';

class LocationListPage extends StatelessWidget {
  const LocationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const LocationListBody(),
    );
  }
}

class LocationListBody extends StatefulWidget {
  const LocationListBody();

  @override
  State<LocationListBody> createState() => LocationListBodyState();
}

class LocationListBodyState extends State<LocationListBody> {
  @override
  void initState() {
    super.initState();
    context.read<CrudBloc<Location>>().add(const LoadAll());
  }

  void openDetail(BuildContext context, {Location? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CrudBloc<Location>>(),
          child: LocationDetailPage(existing: item),
        ),
      ),
    );
    if (mounted) context.read<CrudBloc<Location>>().add(const LoadAll());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrudBloc<Location>, CrudState<Location>>(
      builder: (context, state) {
        return BlocBuilder<SearchCubit, String>(
          builder: (context, searchQuery) {
            List<Location> items = [];
            if (state is CrudLoaded<Location>) {
              items = state.items.where((l) =>l.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
            }
          return MasterListScaffold(
              title: 'Locations',
              isLoading: state is CrudLoading<Location>,
              errorMessage: state is CrudError<Location> ? state.message : null,
              onAdd: () => openDetail(context),
              onRefresh: () => context.read<CrudBloc<Location>>().add(const LoadAll()),
              columns: const [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Latitude')),
                DataColumn(label: Text('Longitude')),
                DataColumn(label: Text('Actions')),
              ],
              rows: items
                  .map((l) => DataRow(cells: [
                        DataCell(Text('${l.id}')),
                        DataCell(Text(l.name,
                            style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text('${l.latitude ?? ''}')),
                        DataCell(Text('${l.longitude ?? ''}')),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => openDetail(context, item: l),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => context
                                  .read<CrudBloc<Location>>()
                                  .add(DeleteItem(l.id!)),
                            ),
                          ],
                        )),
                      ]))
                  .toList(),
            );
          },
        );
      },
    );
  }
}
