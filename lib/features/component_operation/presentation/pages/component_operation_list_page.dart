import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../../core/widgets/master_list_scaffold.dart';
import '../../../component/domain/entities/component.dart';
import '../../../machine/domain/entities/machine.dart';
import '../../domain/entities/component_operation.dart';
import 'component_operation_detail_page.dart';

class ComponentOperationListPage extends StatefulWidget {
  const ComponentOperationListPage({super.key});

  @override
  State<ComponentOperationListPage> createState() => _ComponentOperationListPageState();
}

class _ComponentOperationListPageState extends State<ComponentOperationListPage> {
  @override
  void initState() {
    super.initState();
    context.read<CrudBloc<ComponentOperation>>().add(const LoadAll());
    context.read<CrudBloc<Component>>().add(const LoadAll());
    context.read<CrudBloc<Machine>>().add(const LoadAll());
  }

  void openDetail(BuildContext context, {ComponentOperation? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<CrudBloc<ComponentOperation>>()),
            BlocProvider.value(value: context.read<CrudBloc<Component>>()),
            BlocProvider.value(value: context.read<CrudBloc<Machine>>()),
          ],
          child: ComponentOperationDetailPage(existing: item),
        ),
      ),
    );
    if (mounted) context.read<CrudBloc<ComponentOperation>>().add(const LoadAll());
  }

  String componentName(BuildContext context, int? id) {
    final state = context.read<CrudBloc<Component>>().state;
    if (id == null || state is! CrudLoaded<Component>) return '-';
    final match = state.items.where((c) => c.id == id);
    return match.isEmpty ? '-' : match.first.componentName;
  }

  String machineName(BuildContext context, int? id) {
    final state = context.read<CrudBloc<Machine>>().state;
    if (id == null || state is! CrudLoaded<Machine>) return '-';
    final match = state.items.where((m) => m.id == id);
    return match.isEmpty ? '-' : match.first.machineName;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrudBloc<ComponentOperation>, CrudState<ComponentOperation>>(
      builder: (context, state) {
        List<ComponentOperation> items = [];
        if (state is CrudLoaded<ComponentOperation>) items = state.items;

        return MasterListScaffold(
          title: 'Component Operations',
          isLoading: state is CrudLoading<ComponentOperation>,
          errorMessage: state is CrudError<ComponentOperation> ? state.message : null,
          onAdd: () => openDetail(context),
          onRefresh: () => context.read<CrudBloc<ComponentOperation>>().add(const LoadAll()),
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Component')),
            DataColumn(label: Text('Machine')),
            DataColumn(label: Text('Operation Code')),
            DataColumn(label: Text('Operation Name')),
            DataColumn(label: Text('Operation Type')),
            DataColumn(label: Text('Actions')),
          ],
          rows: items
              .map((o) => DataRow(cells: [
                    DataCell(Text('${o.id}')),
                    DataCell(Text(componentName(context, o.componentId))),
                    DataCell(Text(machineName(context, o.machineId))),
                    DataCell(Text(o.operationCode ?? '-')),
                    DataCell(Text(o.operationName)),
                    DataCell(Text(o.operationType.label)),
                    DataCell(Row(children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue,),
                        onPressed: () => openDetail(context, item: o),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey,),
                        onPressed: () => context
                            .read<CrudBloc<ComponentOperation>>()
                            .add(DeleteItem(o.id!)),
                      ),
                    ])),
                  ]))
              .toList(),
        );
      },
    );
  }
}
