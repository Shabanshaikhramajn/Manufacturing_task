import '../../../../core/base/generic_local_datasource.dart';
import '../../domain/entities/machine_manufacturer.dart';
import '../../domain/repositories/machine_manufacturer_repository.dart';
import '../models/machine_manufacturer_model.dart';

class MachineManufacturerRepositoryImpl extends MachineManufacturerRepository {
  final GenericLocalDataSource<MachineManufacturer> dataSource;

  MachineManufacturerRepositoryImpl()
      : dataSource = GenericLocalDataSource<MachineManufacturer>(
          tableName: 'machine_manufacturers',
          toMap: (e) => MachineManufacturerModel.fromEntity(e).toMap(),
          fromMap: (m) => MachineManufacturerModel.fromMap(m),
          getId: (e) => e.id ?? 0,
        );

  @override
  Future<int> add(MachineManufacturer item) => dataSource.insert(item);

  @override
  Future<int> delete(int id) => dataSource.delete(id);

  @override
  Future<List<MachineManufacturer>> getAll() => dataSource.getAll();

  @override
  Future<MachineManufacturer?> getById(int id) => dataSource.getById(id);

  @override
  Future<int> update(MachineManufacturer item) => dataSource.update(item);
}
