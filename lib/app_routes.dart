import 'package:flutter/material.dart';

import 'home_page.dart';
import 'features/machine_manufacturer/presentation/pages/machine_manufacturer_list_page.dart';
import 'features/location/presentation/pages/location_list_page.dart';
import 'features/machine/presentation/pages/machine_list_page.dart';
import 'features/customer/presentation/pages/customer_list_page.dart';
import 'features/component/presentation/pages/component_list_page.dart';
import 'features/component_operation/presentation/pages/component_operation_list_page.dart';
import 'features/linked_master/presentation/pages/linked_master_view_page.dart';

class AppRoutes {
  static const home = '/';
  static const machineManufacturers = '/machine-manufacturers';
  static const locations = '/locations';
  static const machines = '/machines';
  static const customers = '/customers';
  static const components = '/components';
  static const componentOperations = '/component-operations';
  static const masterView = '/master-view';

  static Map<String, WidgetBuilder> get routes => {
        home: (_) => const HomePage(),
        machineManufacturers: (_) => const MachineManufacturerListPage(),
        locations: (_) => const LocationListPage(),
        machines: (_) => const MachineListPage(),
        customers: (_) => const CustomerListPage(),
        components: (_) => const ComponentListPage(),
        componentOperations: (_) => const ComponentOperationListPage(),
        masterView: (_) => const LinkedMasterViewPage(),
      };
}
