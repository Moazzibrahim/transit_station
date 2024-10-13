import 'package:intl/intl.dart';

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
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      offerName: json['offer_name'] ?? 'Unknown',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormat =
        DateFormat('yyyy-MM-dd'); // Ensures date looks like 2024-09-28

    return {
      'id': id,
      'user_id': userId,
      'offer_name': offerName,
      'start_date':
          dateFormat.format(startDate), // Format start date as yyyy-MM-dd
      'end_date': dateFormat.format(endDate), // Format end date as yyyy-MM-dd
      'amount': amount,
      'status': status,
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
      id: json['id'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      offerName: json['offer_name'] ?? 'Unknown',
      duration: json['duration'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
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
