class User {
  int id;
  String userName;
  String userEmail;
  String offerName;
  DateTime startDate;
  DateTime endDate;
  double amount;
  int status;

  User({
    required this.id,
    required this.userName,
    required this.userEmail,
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
      userEmail: json['user_email'] ?? '', 
      offerName: json['offer_name'] ?? '', 
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(), 
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now(), 
      amount: json['amount'] != null
          ? json['amount'].toDouble()
          : 0.0, 
      status: json['status'] ?? 0, 
    );
  }

  // Method to convert a User object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'user_email': userEmail,
      'offer_name': offerName,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'amount': amount,
      'status': status,
    };
  }
}
