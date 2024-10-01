import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/subscription_provider.dart';
import 'package:transit_station/models/subscription_model.dart';
import 'package:transit_station/views/subscription/views/Subscription_plan_screens.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late Future<UserOffersResponse?> _subscriptionData;

  @override
  void initState() {
    super.initState();
    _subscriptionData = ApiService().fetchUserSubscription(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Subscription'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<UserOffersResponse?>(
          future: _subscriptionData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Center(
                  child: Text("Failed to load subscription data."));
            } else {
              final subscription = snapshot.data!.user[0];

              // Date formatting
              final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
              final String formattedStartDate =
                  dateFormat.format(subscription.startDate);
              final String formattedEndDate =
                  dateFormat.format(subscription.endDate);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You are subscribed to the ${subscription.offerName} Plan',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: defaultColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Start at: $formattedStartDate',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'End at: $formattedEndDate',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionPlanScreens()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: defaultColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 140,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Upgrade',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
