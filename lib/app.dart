import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart';
import 'app_routes.dart';

import 'core/bloc/crud_bloc.dart';

import 'features/machine_manufacturer/domain/entities/machine_manufacturer.dart';
import 'features/machine_manufacturer/domain/repositories/machine_manufacturer_repository.dart';
import 'features/location/domain/entities/location.dart';
import 'features/location/domain/repositories/location_repository.dart';
import 'features/machine/domain/entities/machine.dart';
import 'features/machine/domain/repositories/machine_repository.dart';
import 'features/customer/domain/entities/customer.dart';
import 'features/customer/domain/repositories/customer_repository.dart';
import 'features/component/domain/entities/component.dart';
import 'features/component/domain/repositories/component_repository.dart';
import 'features/component_operation/domain/entities/component_operation.dart';
import 'features/component_operation/domain/repositories/component_operation_repository.dart';

/// Every entity gets one CrudBloc<T> provided app-wide so any screen
/// (e.g. Machine's manufacturer/location dropdowns) can read the
/// already-loaded lookup data without re-wiring providers per route.
class ManufacturingMesApp extends StatelessWidget {
  const ManufacturingMesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CrudBloc<MachineManufacturer>>(
          create: (_) => CrudBloc<MachineManufacturer>(
            getIt<MachineManufacturerRepository>(),
          ),
        ),
        BlocProvider<CrudBloc<Location>>(
          create: (_) => CrudBloc<Location>(getIt<LocationRepository>()),
        ),
        BlocProvider<CrudBloc<Machine>>(
          create: (_) => CrudBloc<Machine>(getIt<MachineRepository>()),
        ),
        BlocProvider<CrudBloc<Customer>>(
          create: (_) => CrudBloc<Customer>(getIt<CustomerRepository>()),
        ),
        BlocProvider<CrudBloc<Component>>(
          create: (_) => CrudBloc<Component>(getIt<ComponentRepository>()),
        ),
        BlocProvider<CrudBloc<ComponentOperation>>(
          create: (_) => CrudBloc<ComponentOperation>(
            getIt<ComponentOperationRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Manufacturing MES',
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
      ),
    );
  }
}
