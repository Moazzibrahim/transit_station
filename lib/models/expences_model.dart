class Expence {
  final String type;
  final int id;
  final double amount;
  final String date;

  Expence(
      {required this.type,
      required this.id,
      required this.amount,
      required this.date});

  factory Expence.fromJson(Map<String, dynamic> json) => Expence(
        type: json['type'],
        id: json['id'],
        amount: json['expence_amount'].toDouble(),
        date: json['date'],
      );
}

class Expences {
  final List<dynamic> expences;

  Expences({required this.expences});

  factory Expences.fromJson(Map<String,dynamic> json)=> Expences(expences: json['expences']);
}

class ExpenceType {
  final String name;
  final int id;

  ExpenceType({required this.name, required this.id});

  factory ExpenceType.fromJson(Map<String,dynamic> json)=> ExpenceType(name: json['type_name'], id: json['id']);
}

class ExpenceTypes {
  final List<dynamic> expenceTypes;

  ExpenceTypes({required this.expenceTypes});

  factory ExpenceTypes.fromJson(Map<String,dynamic> json)=> ExpenceTypes(expenceTypes: json['key']);
}