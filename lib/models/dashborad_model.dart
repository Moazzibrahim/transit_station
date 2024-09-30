class DashboradModel {
  final int pickUpLocationCount;
  final int parkingCount;
  final int subscriptionCount;
  final int driverCount;
  final double revenueAmount;
  final double expenceAmount;

  DashboradModel(
      {required this.pickUpLocationCount,
      required this.parkingCount,
      required this.subscriptionCount,
      required this.driverCount,
      required this.revenueAmount,
      required this.expenceAmount});

  factory DashboradModel.fromJson(Map<String, dynamic> json) =>
      DashboradModel(
        pickUpLocationCount: json['PickupLocationCount'],
        parkingCount: json['parkingCount'],
        subscriptionCount: json['SubscriptionCount'],
        driverCount: json['DriverCount'],
        revenueAmount: json['revenueAmount'].toDouble(),
        expenceAmount: json['expenceAmount'].toDouble(),
      );
}