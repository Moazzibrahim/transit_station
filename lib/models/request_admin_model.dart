class CarRequest {
  int id;
  int carId;
  int userId;
  int locationId;
  String requestTime;
  String pickUpDate;
  int status;
  String createdAt;
  String updatedAt;
  int? driverId;
  User user;
  Location location;

  CarRequest({
    required this.id,
    required this.carId,
    required this.userId,
    required this.locationId,
    required this.requestTime,
    required this.pickUpDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.driverId,
    required this.user,
    required this.location,
  });

  factory CarRequest.fromJson(Map<String, dynamic> json) {
    return CarRequest(
      id: json['id'],
      carId: json['car_id'],
      userId: json['user_id'],
      locationId: json['location_id'],
      requestTime: json['request_time'],
      pickUpDate: json['pick_up_date'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      driverId: json['driver_id'],
      user: User.fromJson(json['user']),
      location: Location.fromJson(json['location']),
    );
  }
}

class User {
  int id;
  String name;
  String email;
  String phone;
  String? image;
  String role;
  List<Subscription> subscription;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.role,
    required this.subscription,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var subs = (json['subscription'] as List)
        .map((e) => Subscription.fromJson(e))
        .toList();
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      role: json['role'],
      subscription: subs,
    );
  }
}

class Subscription {
  int id;
  int userId;
  int offerId;
  String startDate;
  String endDate;
  int amount;
  int status;
  String createdAt;
  String updatedAt;
  Offer offer;

  Subscription({
    required this.id,
    required this.userId,
    required this.offerId,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.offer,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      offerId: json['offer_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      amount: json['amount'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      offer: Offer.fromJson(json['offer']),
    );
  }
}

class Offer {
  int id;
  int price;
  int priceDiscount;
  String offerName;
  int duration;
  String createdAt;
  String updatedAt;

  Offer({
    required this.id,
    required this.price,
    required this.priceDiscount,
    required this.offerName,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      price: json['price'],
      priceDiscount: json['price_discount'],
      offerName: json['offer_name'],
      duration: json['duration'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Location {
  int id;
  String pickUpAddress;
  String locationImage;
  String address;
  String addressInDetail;
  String createdAt;
  String updatedAt;

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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}