import '../../domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({super.id, required super.name, super.latitude, super.longitude});

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  factory LocationModel.fromEntity(Location e) => LocationModel(
        id: e.id,
        name: e.name,
        latitude: e.latitude,
        longitude: e.longitude,
      );

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'latitude': latitude, 'longitude': longitude};
  }
}
