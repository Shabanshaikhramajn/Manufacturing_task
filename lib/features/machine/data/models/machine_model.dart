import '../../../../core/enums/machine_type_enum.dart';
import '../../domain/entities/machine.dart';

class MachineModel extends Machine {
  const MachineModel({
    super.id,
    required super.machineName,
    super.machineSerialNumber,
    super.machineManufacturerId,
    super.machineModel,
    super.yearOfManufacture,
    required super.typeOfMachine,
    super.locationId,
  });

  factory MachineModel.fromMap(Map<String, dynamic> map) {
    return MachineModel(
      id: map['id'] as int?,
      machineName: map['machine_name'] as String? ?? '',
      machineSerialNumber: map['machine_serial_number'] as String?,
      machineManufacturerId: map['machine_manufacturer_id'] as int?,
      machineModel: map['machine_model'] as String?,
      yearOfManufacture: map['year_of_manufacture'] as int?,
      typeOfMachine: MachineType.fromCode(map['type_of_machine'] as int? ?? 1),
      locationId: map['location_id'] as int?,
    );
  }

  factory MachineModel.fromEntity(Machine e) => MachineModel(
        id: e.id,
        machineName: e.machineName,
        machineSerialNumber: e.machineSerialNumber,
        machineManufacturerId: e.machineManufacturerId,
        machineModel: e.machineModel,
        yearOfManufacture: e.yearOfManufacture,
        typeOfMachine: e.typeOfMachine,
        locationId: e.locationId,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'machine_name': machineName,
      'machine_serial_number': machineSerialNumber,
      'machine_manufacturer_id': machineManufacturerId,
      'machine_model': machineModel,
      'year_of_manufacture': yearOfManufacture,
      'type_of_machine': typeOfMachine.code,
      'location_id': locationId,
    };
  }
}
