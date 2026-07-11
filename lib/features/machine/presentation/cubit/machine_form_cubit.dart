import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/machine_type_enum.dart';

class MachineFormState extends Equatable {
  final int? manufacturerId;
  final int? locationId;
  final MachineType type;

  const MachineFormState({
    this.manufacturerId,
    this.locationId,
    this.type = MachineType.cncTurningCenter,
  });

  MachineFormState copyWith({
    int? manufacturerId,
    int? locationId,
    MachineType? type,
  }) {
    return MachineFormState(
      manufacturerId: manufacturerId ?? this.manufacturerId,
      locationId: locationId ?? this.locationId,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [manufacturerId, locationId, type];
}

class MachineFormCubit extends Cubit<MachineFormState> {
  MachineFormCubit({int? initialManufacturerId, int? initialLocationId, MachineType? initialType})
      : super(MachineFormState(
          manufacturerId: initialManufacturerId,
          locationId: initialLocationId,
          type: initialType ?? MachineType.cncTurningCenter,
        ));

  void updateManufacturerId(int? id) => emit(state.copyWith(manufacturerId: id));
  void updateLocationId(int? id) => emit(state.copyWith(locationId: id));
  void updateType(MachineType type) => emit(state.copyWith(type: type));
}
