class Offer {
  final int id;
  final int price;
  final int priceDiscount;
  final String offerName;
  final int duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Offer({
    required this.id,
    required this.price,
    required this.priceDiscount,
    required this.offerName,
    required this.duration,
    this.createdAt,
    this.updatedAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      price: json['price'],
      priceDiscount: json['price_discount'],
      offerName: json['offer_name'],
      duration: json['duration'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'price_discount': priceDiscount,
      'offer_name': offerName,
      'duration': duration,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class OffersUsersResponse {
  final List<Offer> offers;
  final List<User> users;

  OffersUsersResponse({
    required this.offers,
    required this.users,
  });

  factory OffersUsersResponse.fromJson(Map<String, dynamic> json) {
    var offerList = (json['offers'] as List).map((offer) => Offer.fromJson(offer)).toList();
    var userList = (json['users'] as List).map((user) => User.fromJson(user)).toList();

    return OffersUsersResponse(
      offers: offerList,
      users: userList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offers': offers.map((offer) => offer.toJson()).toList(),
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}
