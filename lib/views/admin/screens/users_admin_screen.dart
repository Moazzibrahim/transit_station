import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/controllers/get_users_provider.dart';

import '../../../models/users_admin_model.dart';

class UsersAdminScreen extends StatelessWidget {
  const UsersAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithActions(context, 'Users', () {}),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(context), // Call the fetchUsers function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              icon: Icons.person,
                              label: 'Username',
                              value: user.userName),
                          _buildInfoRow(
                              icon: Icons.email,
                              label: 'Email',
                              value: user.userEmail),
                          _buildInfoRow(
                              icon: Icons.money,
                              label: 'Amount',
                              value: user.amount.toString()),
                          _buildInfoRow(
                              icon: Icons.date_range,
                              label: 'Start Date',
                              value: user.startDate.toIso8601String()),
                          _buildInfoRow(
                              icon: Icons.date_range,
                              label: 'End Date',
                              value: user.endDate.toIso8601String()),
                          _buildInfoRow(
                              icon: Icons.check,
                              label: 'Status',
                              value: user.status.toString()),
                        ],
                      ),
                    ),
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
        Icon(icon, color: Colors.blue, size: 20), // Adjust color as needed
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Adjust color as needed
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
