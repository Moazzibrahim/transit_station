class ProfileResponse {
  final ProfileDriver? profile;

  ProfileResponse({this.profile});

  // Factory method to parse from JSON
  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      profile: json['profile'] != null ? ProfileDriver.fromJson(json['profile']) : null,
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'profile': profile?.toJson(),
    };
  }
}

class ProfileDriver {
  final int? id;
  final int? parkingId;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final int? salary;
  final int? locationId;
  final int? carsPerMonth;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? role;

  ProfileDriver({
    this.id,
    this.parkingId,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.salary,
    this.locationId,
    this.carsPerMonth,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  // Factory method to parse from JSON
  factory ProfileDriver.fromJson(Map<String, dynamic> json) {
    return ProfileDriver(
      id: json['id'],
      parkingId: json['parking_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'], // Assuming this is a base64-encoded string
      salary: json['salary'],
      locationId: json['location_id'],
      carsPerMonth: json['cars_per_mounth'], // Note the typo in API response
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      role: json['role'],
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parking_id': parkingId,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image, // Assuming this will be a base64-encoded string when sent
      'salary': salary,
      'location_id': locationId,
      'cars_per_mounth': carsPerMonth, // Matching the typo in the API
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'role': role,
    };
  }
}
