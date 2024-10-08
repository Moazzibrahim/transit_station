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

  // Factory constructor to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      offerName: json['offer_name'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      amount: json['amount'].toDouble(),
      status: json['status'],
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
