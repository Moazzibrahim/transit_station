
// Car model
class Car {
  int id;
  int userId;
  String carNumber;
  String carName;
  String? carImage;
  DateTime? createdAt;
  DateTime? updatedAt;

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

// Location model
class Location {
  int id;
  String pickUpAddress;
  String locationImage;
  String address;
  String addressInDetail;
  DateTime createdAt;
  DateTime updatedAt;

  Location({
    required this.id,
    required this.pickUpAddress,
    required this.locationImage,
    required this.address,
    required this.addressInDetail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      pickUpAddress: json['pick_up_address'],
      locationImage: json['location_image'],
      address: json['address'],
      addressInDetail: json['address_in_detail'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pick_up_address': pickUpAddress,
      'location_image': locationImage,
      'address': address,
      'address_in_detail': addressInDetail,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Main data model
class MainData {
  List<Car> cars;
  List<Location> locations;

  MainData({
    required this.cars,
    required this.locations,
  });

  factory MainData.fromJson(Map<String, dynamic> json) {
    return MainData(
      cars: List<Car>.from(json['cars'].map((x) => Car.fromJson(x))),
      locations: List<Location>.from(json['locations'].map((x) => Location.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cars': List<dynamic>.from(cars.map((x) => x.toJson())),
      'locations': List<dynamic>.from(locations.map((x) => x.toJson())),
    };
  }
}