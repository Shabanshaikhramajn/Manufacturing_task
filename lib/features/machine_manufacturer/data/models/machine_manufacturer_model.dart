import '../../domain/entities/machine_manufacturer.dart';

class MachineManufacturerModel extends MachineManufacturer {
  const MachineManufacturerModel({super.id, required super.name});

  factory MachineManufacturerModel.fromMap(Map<String, dynamic> map) {
    return MachineManufacturerModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
    );
  }

  factory MachineManufacturerModel.fromEntity(MachineManufacturer e) {
    return MachineManufacturerModel(id: e.id, name: e.name);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
