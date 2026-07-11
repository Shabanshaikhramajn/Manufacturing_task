import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final int? id;
  final String name;
  final double? latitude;
  final double? longitude;

  const Location({this.id, required this.name, this.latitude, this.longitude});

  Location copyWith({int? id, String? name, double? latitude, double? longitude}) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [id, name, latitude, longitude];
}
