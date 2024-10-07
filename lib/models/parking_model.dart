class Parking {
  final String name;
  final int capacity;
  final int id;

  Parking({required this.name, required this.capacity, required this.id});

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
        name: json['name'],
        capacity: json['capacity'],
        id: json['id'],
      );
}

class Parkings {
  final List<dynamic> parkings;

  Parkings({required this.parkings});

  factory Parkings.fromJson(Map<String,dynamic> json)=>Parkings(parkings: json['data']);
}
