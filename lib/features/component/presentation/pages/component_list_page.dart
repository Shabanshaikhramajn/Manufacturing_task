import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../../core/widgets/master_list_scaffold.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../domain/entities/component.dart';
import 'component_detail_page.dart';
import '../../../../core/bloc/search_cubit.dart';

class ComponentListPage extends StatelessWidget {
  const ComponentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const ComponentListBody(),
    );
  }
}

class ComponentListBody extends StatefulWidget {
  const ComponentListBody({super.key});

  @override
  State<ComponentListBody> createState() => ComponentListBodyState();
}

class ComponentListBodyState extends State<ComponentListBody> {
  @override
  void initState() {
    super.initState();
    context.read<CrudBloc<Component>>().add(const LoadAll());
    context.read<CrudBloc<Customer>>().add(const LoadAll());
  }

  void openDetail(BuildContext context, {Component? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<CrudBloc<Component>>()),
            BlocProvider.value(value: context.read<CrudBloc<Customer>>()),
          ],
          child: ComponentDetailPage(existing: item),
        ),
      ),
    );
    if (mounted) context.read<CrudBloc<Component>>().add(const LoadAll());
  }

  String customerName(BuildContext context, int? id) {
    final state = context.read<CrudBloc<Customer>>().state;
    if (id == null || state is! CrudLoaded<Customer>) return '-';
    final match = state.items.where((c) => c.id == id);
    return match.isEmpty ? '-' : match.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrudBloc<Component>, CrudState<Component>>(
      builder: (context, state) {
        return BlocBuilder<SearchCubit, String>(
          builder: (context, searchQuery) {
            List<Component> items = [];
            if (state is CrudLoaded<Component>) {
              items = state.items.where((c) {
                final name = c.componentName.toLowerCase();
                final partNo = (c.partNo ?? '').toLowerCase();
                final query = searchQuery.toLowerCase();
                return name.contains(query) || partNo.contains(query);
              }).toList();
            }

            return MasterListScaffold(
              title: 'Components',
              isLoading: state is CrudLoading<Component>,
              errorMessage: state is CrudError<Component> ? state.message : null,
              onAdd: () => openDetail(context),
              onRefresh: () => context.read<CrudBloc<Component>>().add(const LoadAll()),
              columns: const [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Customer')),
                DataColumn(label: Text('Component Name')),
                DataColumn(label: Text('Part No')),
                DataColumn(label: Text('ECN')),
                DataColumn(label: Text('Actions')),
              ],
              rows: items
                  .map((c) => DataRow(cells: [
                        DataCell(Text('${c.id}')),
                        DataCell(Text(customerName(context, c.customerId))),
                        DataCell(Text(c.componentName, style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(c.partNo ?? '-')),
                        DataCell(Text(c.ecn ?? '-')),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => openDetail(context, item: c),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () =>
                                  context.read<CrudBloc<Component>>().add(DeleteItem(c.id!)),
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
