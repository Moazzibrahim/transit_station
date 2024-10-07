class Revenue {
  final String type;
  final int id;
  final double amount;
  final String date;

  Revenue(
      {required this.type,
      required this.id,
      required this.amount,
      required this.date});

  factory Revenue.fromJson(Map<String, dynamic> json) => Revenue(
        type: json['type'],
        id: json['id'],
        amount: json['revenue_amount'].toDouble(),
        date: json['date'],
      );
}

class Revenues {
  final List<dynamic> revenues;

  Revenues({required this.revenues});

  factory Revenues.fromJson(Map<String,dynamic> json)=> Revenues(revenues: json['revenues']);
}