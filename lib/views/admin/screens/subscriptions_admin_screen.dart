import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/admin/screens/add_subscriptions.dart';
import 'package:transit_station/views/admin/screens/plans_admin_screen.dart';
import '../../../controllers/subscriptions_admin_provider.dart';
import '../../../models/subscriptions_admin_model.dart';

class SubscriptionsAdminScreen extends StatelessWidget {
  const SubscriptionsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithActions(context, 'Subscriptions', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AddSubscriptions()),
        );
      }),
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
          return Stack(
            children: [
              ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.grey[100], // Light background color for cards
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              _buildStatusBadge(user.status),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.card_giftcard,
                            label: 'Offer',
                            value: user.offerName,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: Icons.date_range,
                            label: 'Start Date',
                            value: user.startDate,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: Icons.event,
                            label: 'End Date',
                            value: user.endDate,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: Icons.attach_money,
                            label: 'Amount',
                            value: '\$${user.amount.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const PlansAdminScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: defaultColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ), // Set the button color
                  ),
                  child: const Text(
                    'View Plans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(int status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status == 1 ? defaultColor : Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status == 1 ? 'Active' : 'Inactive',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: defaultColor, size: 20),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: defaultColor,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
