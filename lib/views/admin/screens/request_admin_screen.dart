import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/request_admin_provider.dart';
import 'package:transit_station/models/request_admin_model.dart';
import 'package:transit_station/views/admin/screens/add_request_admin_screen.dart';

class RequestAdminScreen extends StatelessWidget {
  const RequestAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithActions(context, 'Request', () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const AddRequestAdminScreen()));
      }),
      body: FutureBuilder<List<CarRequest>>(
        future: fetchCarRequests(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No requests found.'));
          } else {
            final carRequests = snapshot.data!;
            return ListView.builder(
              itemCount: carRequests.length,
              itemBuilder: (context, index) {
                final request = carRequests[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        icon: Icons.person,
                        label: 'User Name',
                        value: request.user.name,
                      ),
                      const SizedBox(height: 5),
                      _buildInfoRow(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: request.user.phone,
                      ),
                      const SizedBox(height: 5),
                      _buildInfoRow(
                        icon: Icons.card_giftcard,
                        label: 'Offer Name',
                        value: request.user.subscription[0].offer.offerName,
                      ),
                      const SizedBox(height: 5),
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        label: 'Pick-Up Date',
                        value: request.pickUpDate,
                      ),
                      const SizedBox(height: 5),
                      _buildInfoRow(
                        icon: Icons.access_time,
                        label: 'Request Time',
                        value: request.requestTime,
                      ),
                      const SizedBox(height: 5),
                      _buildInfoRow(
                        icon: Icons.location_on,
                        label: 'Pick-Up Address',
                        value: request.location.pickUpAddress,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
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
