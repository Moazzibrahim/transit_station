class Request {
  int id;
  String carName;
  int carId;
  String userName;
  String userPhone;
  int userId;
  String locationName;
  int locationId;
  String pickUpAddress;
  String requestTime;
  String pickUpDate;
  String returnTime;
  String type;
  String status;
  int? offerId;
  String offerName;

  Request({
    required this.id,
    required this.carName,
    required this.carId,
    required this.userName,
    required this.userPhone,
    required this.userId,
    required this.locationName,
    required this.locationId,
    required this.pickUpAddress,
    required this.requestTime,
    required this.pickUpDate,
    required this.returnTime,
    required this.type,
    required this.status,
    this.offerId,
    required this.offerName,
  });

  // Factory method to create an instance from JSON data
  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] ?? 0,
      carName: json['car_name'] ?? '',
      carId: json['car_id'] ?? 0,
      userName: json['user_name'] ?? '',
      userPhone: json['user_phone'] ?? '',
      userId: json['user_id'] ?? 0,
      locationName: json['location_name'] ?? '',
      locationId: json['location_id'] ?? 0,
      pickUpAddress: json['pick_up_address'] ?? '',
      requestTime: json['request_time'] ?? '',
      pickUpDate: json['pick_up_date'] ?? '',
      returnTime: json['return_time'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      offerId: json['offer_id'],
      offerName: json['offer_name'] ?? 'N/A',
    );
  }

  // Method to convert an instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car_name': carName,
      'car_id': carId,
      'user_name': userName,
      'user_phone': userPhone,
      'user_id': userId,
      'location_name': locationName,
      'location_id': locationId,
      'pick_up_address': pickUpAddress,
      'request_time': requestTime,
      'pick_up_date': pickUpDate,
      'return_time': returnTime,
      'type': type,
      'status': status,
      'offer_id': offerId,
      'offer_name': offerName,
    };
  }
}
