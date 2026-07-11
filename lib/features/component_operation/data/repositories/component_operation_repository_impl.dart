import '../../../../core/base/generic_local_datasource.dart';
import '../../domain/entities/component_operation.dart';
import '../../domain/repositories/component_operation_repository.dart';
import '../models/component_operation_model.dart';

class ComponentOperationRepositoryImpl extends ComponentOperationRepository {
  final GenericLocalDataSource<ComponentOperation> dataSource;

  ComponentOperationRepositoryImpl()
      : dataSource = GenericLocalDataSource<ComponentOperation>(
          tableName: 'component_operations',
          toMap: (e) => ComponentOperationModel.fromEntity(e).toMap(),
          fromMap: (m) => ComponentOperationModel.fromMap(m),
          getId: (e) => e.id ?? 0,
        );

  @override
  Future<int> add(ComponentOperation item) => dataSource.insert(item);
  @override
  Future<int> delete(int id) => dataSource.delete(id);
  @override
  Future<List<ComponentOperation>> getAll() => dataSource.getAll();
  @override
  Future<ComponentOperation?> getById(int id) => dataSource.getById(id);
  @override
  Future<int> update(ComponentOperation item) => dataSource.update(item);
}
