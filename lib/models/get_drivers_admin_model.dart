class Driver {
  final int id;
  final int parkingId;
  final String name;
  final String email;
  final String phone;
  final String image;
  final int salary;
  final int locationId;
  final int carsPerMonth;
  final DateTime createdAt;
  final DateTime updatedAt;

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
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      parkingId: json['parking_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      salary: json['salary'],
      locationId: json['location_id'],
      carsPerMonth: json['cars_per_mounth'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
    };
  }
}

class Drivers {
  final List<Driver> drivers;

  Drivers({required this.drivers});

  factory Drivers.fromJson(Map<String, dynamic> json) {
    return Drivers(
      drivers: List<Driver>.from(
        json['drivers'].map((driver) => Driver.fromJson(driver)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drivers': drivers.map((driver) => driver.toJson()).toList(),
    };
  }
}
