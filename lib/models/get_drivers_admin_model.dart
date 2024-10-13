class Driver {
  final int? id;
  final int? parkingId;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final int? salary;
  final int? locationId;
  final int? carsPerMonth;
  final String? locationAddress;  
  final String? parkingName;      
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Driver({
    this.id,
    this.parkingId,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.salary,
    this.locationId,
    this.carsPerMonth,
    this.locationAddress,
    this.parkingName,
    this.createdAt,
    this.updatedAt,
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
      carsPerMonth: json['cars_per_mounth'],  // Fixed typo
      locationAddress: json['location_address'],
      parkingName: json['parking_name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
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
      'location_address': locationAddress,
      'parking_name': parkingName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Drivers {
  final List<Driver>? drivers;

  Drivers({this.drivers});

  factory Drivers.fromJson(Map<String, dynamic> json) {
    return Drivers(
      drivers: json['drivers'] != null
          ? List<Driver>.from(json['drivers'].map((driver) => Driver.fromJson(driver)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drivers': drivers?.map((driver) => driver.toJson()).toList(),
    };
  }
}
