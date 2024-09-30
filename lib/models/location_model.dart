class LocationModel {
  final String address;
  final String pickupAddress;
  final int id;

  LocationModel({
    required this.address,
    required this.pickupAddress,
    required this.id,
  });
  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        address: json['address'],
        pickupAddress: json['pick_up_address'],
        id: json['id'],
      );
}

class LocationDataList {
  final List<dynamic> locationList;

  LocationDataList({required this.locationList});

  factory LocationDataList.fromJson(Map<String,dynamic> json) => LocationDataList(
    locationList: json['locationdata']
  );
}
