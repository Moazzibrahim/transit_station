class Plan {
  final int id;
  final double price;
  final double discountprice;

  final String offerName;
  final int duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Plan({
    required this.id,
    required this.price,
    required this.discountprice,
    required this.offerName,
    required this.duration,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a Plan object from JSON
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      offerName: json['offer_name'],
      duration: json['duration'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      discountprice: (json['price_discount'] as num).toDouble(),
    );
  }

  // Convert Plan object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'price_discount': discountprice,
      'offer_name': offerName,
      'duration': duration,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
