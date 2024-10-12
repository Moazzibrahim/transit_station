class Revenue {
  final String type;
  final int id;
  final double amount;
  final String date;

  Revenue({
    required this.type,
    required this.id,
    required this.amount,
    required this.date,
  });

  factory Revenue.fromJson(Map<String, dynamic> json) {
    return Revenue(
      type: json['type'] ?? '',
      id: json['id'] ?? 0, // Providing default value of 0 if id is null
      amount: (json['revenue_amount'] as num?)?.toDouble() ??
          0.0, // Safely handling potential null and converting to double
      date: json['date'] ??
          '', // Providing default value of empty string if date is null
    );
  }
}

class Revenues {
  final List<dynamic> revenues;

  Revenues({required this.revenues});

  factory Revenues.fromJson(Map<String, dynamic> json) =>
      Revenues(revenues: json['revenues']);
}

class RevenueType {
  final String name;
  final int id;

  RevenueType({
    required this.name,
    required this.id,
  });

  factory RevenueType.fromJson(Map<String, dynamic> json) {
    return RevenueType(
      name: json['type_name'] ??
          '', // Default to an empty string if 'type_name' is null
      id: json['id'] ?? 0, // Default to 0 if 'id' is null
    );
  }
}

class RevenueTypes {
  final List<dynamic> revenueTypes;

  RevenueTypes({required this.revenueTypes});

  factory RevenueTypes.fromJson(Map<String, dynamic> json) =>
      RevenueTypes(revenueTypes: json['key']);
}
