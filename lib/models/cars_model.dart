class Car {
  final int id;
  final int userId;
  final String carNumber;
  final String carName;
  final String? carImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Car({
    required this.id,
    required this.userId,
    required this.carNumber,
    required this.carName,
    this.carImage,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create a Car instance from JSON
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      userId: json['user_id'],
      carNumber: json['car_number'],
      carName: json['car_name'],
      carImage: json['car_image'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Method to convert Car instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'car_number': carNumber,
      'car_name': carName,
      'car_image': carImage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
