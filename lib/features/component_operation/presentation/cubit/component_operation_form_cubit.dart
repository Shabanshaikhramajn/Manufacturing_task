import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/operation_type_enum.dart';

class ComponentOperationFormState extends Equatable {
  final int? componentId;
  final int? machineId;
  final OperationType type;

  const ComponentOperationFormState({
    this.componentId,
    this.machineId,
    this.type = OperationType.turning,
  });

  ComponentOperationFormState copyWith({
    int? componentId,
    int? machineId,
    OperationType? type,
  }) {
    return ComponentOperationFormState(
      componentId: componentId ?? this.componentId,
      machineId: machineId ?? this.machineId,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [componentId, machineId, type];
}

class ComponentOperationFormCubit extends Cubit<ComponentOperationFormState> {
  ComponentOperationFormCubit({int? initialComponentId, int? initialMachineId, OperationType? initialType})
      : super(ComponentOperationFormState(
          componentId: initialComponentId,
          machineId: initialMachineId,
          type: initialType ?? OperationType.turning,
        ));

  void updateComponentId(int? id) => emit(state.copyWith(componentId: id));
  void updateMachineId(int? id) => emit(state.copyWith(machineId: id));
  void updateType(OperationType type) => emit(state.copyWith(type: type));
}
