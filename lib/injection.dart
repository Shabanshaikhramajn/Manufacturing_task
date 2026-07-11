import 'package:get_it/get_it.dart';

import 'features/machine_manufacturer/domain/repositories/machine_manufacturer_repository.dart';
import 'features/machine_manufacturer/data/repositories/machine_manufacturer_repository_impl.dart';
import 'features/location/domain/repositories/location_repository.dart';
import 'features/location/data/repositories/location_repository_impl.dart';
import 'features/machine/domain/repositories/machine_repository.dart';
import 'features/machine/data/repositories/machine_repository_impl.dart';
import 'features/customer/domain/repositories/customer_repository.dart';
import 'features/customer/data/repositories/customer_repository_impl.dart';
import 'features/component/domain/repositories/component_repository.dart';
import 'features/component/data/repositories/component_repository_impl.dart';
import 'features/component_operation/domain/repositories/component_operation_repository.dart';
import 'features/component_operation/data/repositories/component_operation_repository_impl.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  getIt.registerLazySingleton<MachineManufacturerRepository>(
    () => MachineManufacturerRepositoryImpl(),
  );
  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(),
  );
  getIt.registerLazySingleton<MachineRepository>(
    () => MachineRepositoryImpl(),
  );
  getIt.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(),
  );
  getIt.registerLazySingleton<ComponentRepository>(
    () => ComponentRepositoryImpl(),
  );
  getIt.registerLazySingleton<ComponentOperationRepository>(
    () => ComponentOperationRepositoryImpl(),
  );
}
