import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ComponentFormState extends Equatable {
  final int? customerId;
  final String name;
  final String partNo;
  final String ecn;

  const ComponentFormState({
    this.customerId,
    this.name = '',
    this.partNo = '',
    this.ecn = '',
  });

  ComponentFormState copyWith({
    int? customerId,
    String? name,
    String? partNo,
    String? ecn,
  }) {
    return ComponentFormState(
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      partNo: partNo ?? this.partNo,
      ecn: ecn ?? this.ecn,
    );
  }

  @override
  List<Object?> get props => [customerId, name, partNo, ecn];
}

class ComponentFormCubit extends Cubit<ComponentFormState> {
  ComponentFormCubit({int? initialCustomerId, String? initialName, String? initialPartNo, String? initialEcn})
      : super(ComponentFormState(
          customerId: initialCustomerId,
          name: initialName ?? '',
          partNo: initialPartNo ?? '',
          ecn: initialEcn ?? '',
        ));

  void updateCustomerId(int? id) => emit(state.copyWith(customerId: id));
  void updateName(String name) => emit(state.copyWith(name: name));
  void updatePartNo(String partNo) => emit(state.copyWith(partNo: partNo));
  void updateEcn(String ecn) => emit(state.copyWith(ecn: ecn));
}
