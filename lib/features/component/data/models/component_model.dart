import '../../domain/entities/component.dart';

class ComponentModel extends Component {
  const ComponentModel({
    super.id,
    super.customerId,
    required super.componentName,
    super.partNo,
    super.ecn,
  });

  factory ComponentModel.fromMap(Map<String, dynamic> map) {
    return ComponentModel(
      id: map['id'] as int?,
      customerId: map['customer_id'] as int?,
      componentName: map['component_name'] as String? ?? '',
      partNo: map['part_no'] as String?,
      ecn: map['ecn'] as String?,
    );
  }

  factory ComponentModel.fromEntity(Component e) => ComponentModel(
    id: e.id,
    customerId: e.customerId,
    componentName: e.componentName,
    partNo: e.partNo,
    ecn: e.ecn,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'component_name': componentName,
      'part_no': partNo,
      'ecn': ecn,
    };
  }
}
