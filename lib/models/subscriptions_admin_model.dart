class User {
  final int id;
  final String userName;
  final String offerName;
  final String startDate;
  final String endDate;
  final double amount;
  final int status;

  User({
    required this.id,
    required this.userName,
    required this.offerName,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, 
      userName: json['user_name'] ?? '', 
      offerName:
          json['offer_name'] ?? '', 
      startDate:
          json['start_date'] ?? '', 
      endDate: json['end_date'] ?? '',
      amount:
          (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'offer_name': offerName,
      'start_date': startDate,
      'end_date': endDate,
      'amount': amount,
      'status': status,
    };
  }
}
