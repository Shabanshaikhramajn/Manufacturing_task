import '../../../../core/base/generic_local_datasource.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl extends CustomerRepository {
  final GenericLocalDataSource<Customer> dataSource;

  CustomerRepositoryImpl()
      : dataSource = GenericLocalDataSource<Customer>(
          tableName: 'customers',
          toMap: (e) => CustomerModel.fromEntity(e).toMap(),
          fromMap: (m) => CustomerModel.fromMap(m),
          getId: (e) => e.id ?? 0,
        );

  @override
  Future<int> add(Customer item) => dataSource.insert(item);
  @override
  Future<int> delete(int id) => dataSource.delete(id);
  @override
  Future<List<Customer>> getAll() => dataSource.getAll();
  @override
  Future<Customer?> getById(int id) => dataSource.getById(id);
  @override
  Future<int> update(Customer item) => dataSource.update(item);
}
