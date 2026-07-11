import '../../../../core/base/generic_local_datasource.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl extends LocationRepository {
  final GenericLocalDataSource<Location> dataSource;

  LocationRepositoryImpl()
      : dataSource = GenericLocalDataSource<Location>(
          tableName: 'locations',
          toMap: (e) => LocationModel.fromEntity(e).toMap(),
          fromMap: (m) => LocationModel.fromMap(m),
          getId: (e) => e.id ?? 0,
        );

  @override
  Future<int> add(Location item) => dataSource.insert(item);

  @override
  Future<int> delete(int id) => dataSource.delete(id);

  @override
  Future<List<Location>> getAll() => dataSource.getAll();

  @override
  Future<Location?> getById(int id) => dataSource.getById(id);

  @override
  Future<int> update(Location item) => dataSource.update(item);
}
