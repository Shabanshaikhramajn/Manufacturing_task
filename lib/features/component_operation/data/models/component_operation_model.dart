import '../../../../core/enums/operation_type_enum.dart';
import '../../domain/entities/component_operation.dart';

class ComponentOperationModel extends ComponentOperation {
  const ComponentOperationModel({
    super.id,
    super.componentId,
    super.machineId,
    super.operationCode,
    required super.operationName,
    super.operationDescription,
    required super.operationType,
  });

  factory ComponentOperationModel.fromMap(Map<String, dynamic> map) {
    return ComponentOperationModel(
      id: map['id'] as int?,
      componentId: map['component_id'] as int?,
      machineId: map['machine_id'] as int?,
      operationCode: map['operation_code'] as String?,
      operationName: map['operation_name'] as String? ?? '',
      operationDescription: map['operation_description'] as String?,
      operationType: OperationType.fromCode(map['operation_type'] as int? ?? 1),
    );
  }

  factory ComponentOperationModel.fromEntity(ComponentOperation e) =>
      ComponentOperationModel(
        id: e.id,
        componentId: e.componentId,
        machineId: e.machineId,
        operationCode: e.operationCode,
        operationName: e.operationName,
        operationDescription: e.operationDescription,
        operationType: e.operationType,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'component_id': componentId,
      'machine_id': machineId,
      'operation_code': operationCode,
      'operation_name': operationName,
      'operation_description': operationDescription,
      'operation_type': operationType.code,
    };
  }
}
