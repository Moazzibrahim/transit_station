class Parking {
  final int id;
  final String name;
  final int capacity;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;

  Parking({
    required this.id,
    required this.name,
    required this.capacity,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      location: json['location'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
class Driver {
  final int id;
  final int parkingId;
  final String name;
  final String email;
  final String phone;
  final String image;
  final double salary;
  final int locationId;
  final int carsPerMonth;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String role;

  Driver({
    required this.id,
    required this.parkingId,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.salary,
    required this.locationId,
    required this.carsPerMonth,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      parkingId: json['parking_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'] ?? '',
      salary: json['salary'].toDouble(),
      locationId: json['location_id'],
      carsPerMonth: json['cars_per_mounth'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parking_id': parkingId,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'salary': salary,
      'location_id': locationId,
      'cars_per_mounth': carsPerMonth,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'role': role,
    };
  }
}
