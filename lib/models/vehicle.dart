const String vehicleTable = 'Vehicles';

class VehicleField {
  static const String id = 'id';
  static const String manufacturer = 'manufacturer';
  static const String model = 'model';
  static const String description = 'description';
  static const String vehicleType = 'vehicleType';
  static const String imagePath = 'imagePath';
}

class Vehicle {
  final int id;
  final String manufacturer;
  final String model;
  final String description;
  final String vehicleType;
  final String imagePath;

  Vehicle({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.description,
    required this.vehicleType,
    required this.imagePath,
  });

  static Vehicle fromJson(Map<String, Object?> json) => Vehicle(
        id: json[VehicleField.id] as int,
        manufacturer: json[VehicleField.manufacturer].toString(),
        model: json[VehicleField.model].toString(),
        description: json[VehicleField.description].toString(),
        vehicleType: json[VehicleField.vehicleType].toString(),
        imagePath: json[VehicleField.imagePath].toString(),
      );

  Map<String, Object?> toJson() => {
        VehicleField.id: id,
        VehicleField.manufacturer: manufacturer,
        VehicleField.model: model,
        VehicleField.description: description,
        VehicleField.vehicleType: vehicleType,
        VehicleField.imagePath: imagePath,
      };

  Vehicle copy({
    int? id,
    String? manufacturer,
    String? model,
    String? description,
    String? vehicleType,
    String? imagePath,
  }) =>
      Vehicle(
        id: id ?? this.id,
        manufacturer: manufacturer ?? this.manufacturer,
        model: model ?? this.model,
        description: description ?? this.description,
        vehicleType: vehicleType ?? this.vehicleType,
        imagePath: imagePath ?? this.imagePath,
      );
}
