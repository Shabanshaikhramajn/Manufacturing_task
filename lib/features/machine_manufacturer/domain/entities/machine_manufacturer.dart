import 'package:equatable/equatable.dart';

class MachineManufacturer extends Equatable {
  final int? id;
  final String name;

  const MachineManufacturer({this.id, required this.name});

  MachineManufacturer copyWith({int? id, String? name}) {
    return MachineManufacturer(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
