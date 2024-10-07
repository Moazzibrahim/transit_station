import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/models/plans_admin_model.dart';
import 'package:transit_station/views/admin/screens/add_plans_screen.dart';

import '../../../constants/colors.dart';
import '../../../controllers/plans_admin_provider.dart'; // Plan model

class PlansAdminScreen extends StatelessWidget {
  const PlansAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: buildAppBar(context, 'Plans'),
      body: Stack(
        children: [
          FutureBuilder<List<Plan>>(
            future: PlanService()
                .fetchPlans(context), // Fetch plans using the service
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator()); // Loading indicator
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}')); // Error message
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('No plans available.')); // No data message
              } else if (snapshot.hasData) {
                final plans = snapshot.data!;
                return ListView.builder(
                  itemCount: plans.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildSubscriptionCard(
                        plan.offerName,
                        '${plan.duration} Days',
                        '\$${plan.discountprice}',
                        '\$${plan.price}',
                        // Assuming original price is 20% higher
                        cardWidth,
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Unexpected error occurred.'));
              }
            },
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const AddPlansScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: defaultColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'add Plans',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
    String title,
    String duration,
    String price,
    String originalPrice,
    double cardWidth,
  ) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: defaultColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: defaultColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: defaultColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(
              color: defaultColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            originalPrice,
            style: const TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}
