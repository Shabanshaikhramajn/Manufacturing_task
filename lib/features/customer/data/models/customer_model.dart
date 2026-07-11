import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({super.id, required super.name});

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(id: map['id'] as int?, name: map['name'] as String? ?? '');
  }

  factory CustomerModel.fromEntity(Customer e) => CustomerModel(id: e.id, name: e.name);

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}
