import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/controllers/subscriptions_admin_provider.dart';
import 'package:transit_station/models/subscriptions_model.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Subscriptions'),
      body: FutureBuilder<List<User>>(
        future: SubscriptionService().fetchSubscriptions(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No subscriptions found'));
          }

          final List<User> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Offer: ${user.offerName}'),
                      const SizedBox(height: 4),
                      Text('Start Date: ${user.startDate}'),
                      const SizedBox(height: 4),
                      Text('End Date: ${user.endDate}'),
                      const SizedBox(height: 4),
                      Text('Amount: \$${user.amount.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${user.status == 1 ? 'Active' : 'Inactive'}',
                        style: TextStyle(
                          color: user.status == 1 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
