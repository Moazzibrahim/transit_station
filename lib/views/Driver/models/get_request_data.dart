class RequestModel {
  List<Request> requests;

  RequestModel({required this.requests});

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      requests:
          List<Request>.from(json['requests'].map((x) => Request.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requests': List<dynamic>.from(requests.map((x) => x.toJson())),
    };
  }
}

class Request {
  int id;
  int carId;
  String carName;
  String carImage;
  int locationId;
  String locationName;
  String requestTime;
  String pickUpDate;
  String returnTime;
  String status;
  String username;
  String userphone;
  String parkingname;
  String carnumber;
  Driverdata driver;

  Request({
    required this.id,
    required this.carId,
    required this.carName,
    required this.carImage,
    required this.locationId,
    required this.locationName,
    required this.requestTime,
    required this.pickUpDate,
    required this.returnTime,
    required this.status,
    required this.username,
    required this.userphone,
    required this.parkingname,
    required this.carnumber,
    required this.driver,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      carId: json['car_id'],
      carName: json['car_name'],
      carImage: json['car_image'],
      locationId: json['location_id'],
      locationName: json['location_name'],
      requestTime: json['request_time'],
      pickUpDate: json['pick_up_date'],
      returnTime: json['return_time'] ?? '',
      status: json['status'],
      username: json['user_name'],
      userphone: json['user_phone'],
      parkingname: json['parking_name'],
      carnumber: json['car_number'],
      driver: Driverdata.fromJson(json['driver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car_id': carId,
      'car_name': carName,
      'car_image': carImage,
      'location_id': locationId,
      'location_name': locationName,
      'request_time': requestTime,
      'pick_up_date': pickUpDate,
      'return_time': returnTime,
      'status': status,
      'user_phone': userphone,
      'user_name': username,
      'parking_name': parkingname,
      'car_number': carnumber,
      'driver': driver.toJson(),
    };
  }
}

class Driverdata {
  int id;
  String name;
  String email;
  String phone;

  Driverdata({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Driverdata.fromJson(Map<String, dynamic> json) {
    return Driverdata(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
