class DashboradModel {
  final int usercount;
  final int requestcount;
  final int pickUpLocationCount;
  final int parkingCount;
  final int subscriptionCount;
  final int driverCount;
  final double revenueAmount;
  final double expenceAmount;

  DashboradModel({
    required this.usercount,
    required this.requestcount,
    required this.pickUpLocationCount,
    required this.parkingCount,
    required this.subscriptionCount,
    required this.driverCount,
    required this.revenueAmount,
    required this.expenceAmount,
  });

  factory DashboradModel.fromJson(Map<String, dynamic> json) {
    return DashboradModel(
      usercount: json['usercount'] ?? 0, // Default to 0 if null
      requestcount: json['requestcount'] ?? 0, // Default to 0 if null
      pickUpLocationCount:
          json['PickupLocationCount'] ?? 0, // Default to 0 if null
      parkingCount: json['parkingCount'] ?? 0, // Default to 0 if null
      subscriptionCount: json['SubscriptionCount'] ?? 0, // Default to 0 if null
      driverCount: json['DriverCount'] ?? 0, // Default to 0 if null
      revenueAmount: (json['revenueAmount'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      expenceAmount: (json['expenceAmount'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
    );
  }
}
