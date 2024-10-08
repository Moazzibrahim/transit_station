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

class RevenueType {
  final String name;
  final int id;

  RevenueType({required this.name, required this.id});

  factory RevenueType.fromJson(Map<String,dynamic> json)=> RevenueType(name: json['type_name'], id: json['id']);
}

class RevenueTypes {
  final List<dynamic> revenueTypes;

  RevenueTypes({required this.revenueTypes});

  factory RevenueTypes.fromJson(Map<String,dynamic> json)=> RevenueTypes(revenueTypes: json['key']);
}