import 'package:equatable/equatable.dart';

class Component extends Equatable {
  final int? id;
  final int? customerId;
  final String componentName;
  final String? partNo;
  final String? ecn;

  const Component({
    this.id,
    this.customerId,
    required this.componentName,
    this.partNo,
    this.ecn,
  });

  Component copyWith({
    int? id,
    int? customerId,
    String? componentName,
    String? partNo,
    String? ecn,
  }) {
    return Component(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      componentName: componentName ?? this.componentName,
      partNo: partNo ?? this.partNo,
      ecn: ecn ?? this.ecn,
    );
  }

  @override
  List<Object?> get props => [id, customerId, componentName, partNo, ecn];
}
