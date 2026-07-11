import 'package:equatable/equatable.dart';
import '../../../../core/enums/operation_type_enum.dart';

class ComponentOperation extends Equatable {
  final int? id;
  final int? componentId;
  final int? machineId;
  final String? operationCode;
  final String operationName;
  final String? operationDescription;
  final OperationType operationType;

  const ComponentOperation({
    this.id,
    this.componentId,
    this.machineId,
    this.operationCode,
    required this.operationName,
    this.operationDescription,
    required this.operationType,
  });

  ComponentOperation copyWith({
    int? id,
    int? componentId,
    int? machineId,
    String? operationCode,
    String? operationName,
    String? operationDescription,
    OperationType? operationType,
  }) {
    return ComponentOperation(
      id: id ?? this.id,
      componentId: componentId ?? this.componentId,
      machineId: machineId ?? this.machineId,
      operationCode: operationCode ?? this.operationCode,
      operationName: operationName ?? this.operationName,
      operationDescription: operationDescription ?? this.operationDescription,
      operationType: operationType ?? this.operationType,
    );
  }

  @override
  List<Object?> get props => [
    id,
    componentId,
    machineId,
    operationCode,
    operationName,
    operationDescription,
    operationType,
  ];
}
