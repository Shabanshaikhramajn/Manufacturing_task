import 'package:flutter/material.dart';

import 'app.dart';
import 'injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();
  runApp(const ManufacturingMesApp());
}
