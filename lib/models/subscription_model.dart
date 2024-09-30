class UserOffersResponse {
  final List<UserOffer> user;
  final List<Offer> offers;

  UserOffersResponse({
    required this.user,
    required this.offers,
  });

  factory UserOffersResponse.fromJson(Map<String, dynamic> json) {
    return UserOffersResponse(
      user: (json['user'] as List)
          .map((data) => UserOffer.fromJson(data))
          .toList(),
      offers:
          (json['offers'] as List).map((data) => Offer.fromJson(data)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.map((e) => e.toJson()).toList(),
      'offers': offers.map((e) => e.toJson()).toList(),
    };
  }
}

class Offer {
  final int id;
  final double price;
  final String offerName;
  final int duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Offer({
    required this.id,
    required this.price,
    required this.offerName,
    required this.duration,
    this.createdAt,
    this.updatedAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? 0, // Handle missing ID
      price:
          (json['price'] as num?)?.toDouble() ?? 0.0, // Null safety for price
      offerName: json['offer_name'] ?? 'Unknown', // Handle missing offer name
      duration: json['duration'] ?? 0, // Handle missing duration
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null, // Handle nullable DateTime
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null, // Handle nullable DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'offer_name': offerName,
      'duration': duration,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class UserOffer {
  final int id;
  final int userId;
  final String offerName;
  final DateTime startDate;
  final DateTime endDate;
  final double amount;
  final int status;

  UserOffer({
    required this.id,
    required this.userId,
    required this.offerName,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.status,
  });

  factory UserOffer.fromJson(Map<String, dynamic> json) {
    return UserOffer(
      id: json['id'] ?? 0, // Handle missing ID
      userId: json['user_id'] ?? 0, // Handle missing user ID
      offerName: json['offer_name'] ?? 'Unknown', // Handle missing offer name
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      amount:
          (json['amount'] as num?)?.toDouble() ?? 0.0, // Null safety for amount
      status: json['status'] ?? 0, // Handle missing status
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'offer_name': offerName,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'amount': amount,
      'status': status,
    };
  }
}
