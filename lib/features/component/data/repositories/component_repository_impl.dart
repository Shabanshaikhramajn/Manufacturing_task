import '../../../../core/base/generic_local_datasource.dart';
import '../../domain/entities/component.dart';
import '../../domain/repositories/component_repository.dart';
import '../models/component_model.dart';

class ComponentRepositoryImpl extends ComponentRepository {
  final GenericLocalDataSource<Component> dataSource;

  ComponentRepositoryImpl()
    : dataSource = GenericLocalDataSource<Component>(
        tableName: 'components',
        toMap: (e) => ComponentModel.fromEntity(e).toMap(),
        fromMap: (m) => ComponentModel.fromMap(m),
        getId: (e) => e.id ?? 0,
      );

  @override
  Future<int> add(Component item) => dataSource.insert(item);
  @override
  Future<int> delete(int id) => dataSource.delete(id);
  @override
  Future<List<Component>> getAll() => dataSource.getAll();
  @override
  Future<Component?> getById(int id) => dataSource.getById(id);
  @override
  Future<int> update(Component item) => dataSource.update(item);
}
