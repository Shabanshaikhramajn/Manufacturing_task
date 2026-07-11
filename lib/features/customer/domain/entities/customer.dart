import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int? id;
  final String name;

  const Customer({this.id, required this.name});

  Customer copyWith({int? id, String? name}) {
    return Customer(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];
}
