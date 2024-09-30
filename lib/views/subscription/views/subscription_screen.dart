import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/subscription_provider.dart';
import 'package:transit_station/models/subscription_model.dart';
import 'package:transit_station/views/auth_screens/widgets/build_appbar.dart';
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
    // Fetch the subscription data when the widget is initialized
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
              // Show a loading spinner while the data is being fetched
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              // Show an error message if data loading failed
              return const Center(
                  child: Text("Failed to load subscription data."));
            } else {
              // Data loaded successfully, display subscription details
              final subscription = snapshot.data!.user[0];
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
                            'Start at: ${subscription.startDate}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'End at: ${subscription.endDate}',
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
