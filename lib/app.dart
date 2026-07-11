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
        title: 'Manufacturing',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.blueAccent,
          useMaterial3: true,
          brightness: Brightness.light,
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          dataTableTheme: DataTableThemeData(
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
            dataRowColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) return Colors.blue[50];
              return null;
            }),
          ),
        ),
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
      ),
    );
  }
}
