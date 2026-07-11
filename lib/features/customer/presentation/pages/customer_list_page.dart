import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/crud_bloc.dart';
import '../../../../core/bloc/crud_event.dart';
import '../../../../core/bloc/crud_state.dart';
import '../../../../core/widgets/master_list_scaffold.dart';
import '../../domain/entities/customer.dart';
import 'customer_detail_page.dart';
import '../../../../core/bloc/search_cubit.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const CustomerListBody(),
    );
  }
}

class CustomerListBody extends StatefulWidget {
  const CustomerListBody({super.key});

  @override
  State<CustomerListBody> createState() => CustomerListBodyState();
}

class CustomerListBodyState extends State<CustomerListBody> {
  @override
  void initState() {
    super.initState();
    context.read<CrudBloc<Customer>>().add(const LoadAll());
  }

  void openDetail(BuildContext context, {Customer? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CrudBloc<Customer>>(),
          child: CustomerDetailPage(existing: item),
        ),
      ),
    );
    if (mounted) context.read<CrudBloc<Customer>>().add(const LoadAll());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrudBloc<Customer>, CrudState<Customer>>(
      builder: (context, state) {
        return BlocBuilder<SearchCubit, String>(
          builder: (context, searchQuery) {
            List<Customer> items = [];
            if (state is CrudLoaded<Customer>) {
              items = state.items
                  .where((c) =>
                      c.name.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();
            }

            return MasterListScaffold(
              title: 'Customers',
              isLoading: state is CrudLoading<Customer>,
              errorMessage: state is CrudError<Customer> ? state.message : null,
              onAdd: () => openDetail(context),
              onRefresh: () => context.read<CrudBloc<Customer>>().add(const LoadAll()),
              columns: const [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Actions')),
              ],
              rows: items
                  .map((c) => DataRow(cells: [
                        DataCell(Text('${c.id}')),
                        DataCell(SizedBox(
                          width: 100,
                          child: Text(c.name,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),

                        ),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => openDetail(context, item: c),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => context
                                  .read<CrudBloc<Customer>>()
                                  .add(DeleteItem(c.id!)),
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
