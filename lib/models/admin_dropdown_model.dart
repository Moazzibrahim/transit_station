class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      role: json['role'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
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

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      userId: json['user_id'],
      carNumber: json['car_number'],
      carName: json['car_name'],
      carImage: json['car_image'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
class Location {
  final int id;
  final String pickUpAddress;
  final String locationImage;
  final String address;
  final String addressInDetail;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Location({
    required this.id,
    required this.pickUpAddress,
    required this.locationImage,
    required this.address,
    required this.addressInDetail,
    this.createdAt,
    this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      pickUpAddress: json['pick_up_address'],
      locationImage: json['location_image'],
      address: json['address'],
      addressInDetail: json['address_in_detail'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
      carsPerMonth: json['cars_per_mounth'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
