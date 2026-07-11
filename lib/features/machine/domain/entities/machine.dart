import 'package:equatable/equatable.dart';
import '../../../../core/enums/machine_type_enum.dart';

class Machine extends Equatable {
  final int? id;
  final String machineName;
  final String? machineSerialNumber;
  final int? machineManufacturerId;
  final String? machineModel;
  final int? yearOfManufacture;
  final MachineType typeOfMachine;
  final int? locationId;

  const Machine({
    this.id,
    required this.machineName,
    this.machineSerialNumber,
    this.machineManufacturerId,
    this.machineModel,
    this.yearOfManufacture,
    required this.typeOfMachine,
    this.locationId,
  });

  Machine copyWith({
    int? id,
    String? machineName,
    String? machineSerialNumber,
    int? machineManufacturerId,
    String? machineModel,
    int? yearOfManufacture,
    MachineType? typeOfMachine,
    int? locationId,
  }) {
    return Machine(
      id: id ?? this.id,
      machineName: machineName ?? this.machineName,
      machineSerialNumber: machineSerialNumber ?? this.machineSerialNumber,
      machineManufacturerId: machineManufacturerId ?? this.machineManufacturerId,
      machineModel: machineModel ?? this.machineModel,
      yearOfManufacture: yearOfManufacture ?? this.yearOfManufacture,
      typeOfMachine: typeOfMachine ?? this.typeOfMachine,
      locationId: locationId ?? this.locationId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        machineName,
        machineSerialNumber,
        machineManufacturerId,
        machineModel,
        yearOfManufacture,
        typeOfMachine,
        locationId,
      ];
}
