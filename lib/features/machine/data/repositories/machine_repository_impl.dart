import '../../../../core/base/generic_local_datasource.dart';
import '../../domain/entities/machine.dart';
import '../../domain/repositories/machine_repository.dart';
import '../models/machine_model.dart';

class MachineRepositoryImpl extends MachineRepository {
  final GenericLocalDataSource<Machine> dataSource;

  MachineRepositoryImpl()
      : dataSource = GenericLocalDataSource<Machine>(
          tableName: 'machines',
          toMap: (e) => MachineModel.fromEntity(e).toMap(),
          fromMap: (m) => MachineModel.fromMap(m),
          getId: (e) => e.id ?? 0,
        );

  @override
  Future<int> add(Machine item) => dataSource.insert(item);
  @override
  Future<int> delete(int id) => dataSource.delete(id);
  @override
  Future<List<Machine>> getAll() => dataSource.getAll();
  @override
  Future<Machine?> getById(int id) => dataSource.getById(id);
  @override
  Future<int> update(Machine item) => dataSource.update(item);
}
