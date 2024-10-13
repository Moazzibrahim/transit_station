import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/get_users_provider.dart';
import 'package:transit_station/views/admin/screens/add_users_admin_screen.dart';

import '../../../models/users_admin_model.dart';

class UsersAdminScreen extends StatelessWidget {
  const UsersAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithActions(context, 'Users', () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AddUsersAdminScreen()),
        );
      }),
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
                              value: user.userName,
                              status: user.status),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildInfoRow(
                              icon: Icons.email,
                              label: 'Email',
                              value: user.userEmail),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildInfoRow(
                              icon: Icons.phone,
                              label: 'phone',
                              value: user.userphone),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildInfoRow(
                            icon: Icons.local_offer,
                            label: 'plan ',
                            value: user.offerName, // Adding offerName here
                          ),
                          const SizedBox(height: 5),
                          _buildInfoRow(
                              icon: Icons.money,
                              label: 'Amount',
                              value: user.amount.toString()),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildInfoRow(
                              icon: Icons.date_range,
                              label: 'Start Date',
                              value: DateFormat('yyyy-MM-dd')
                                  .format(user.startDate)),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildInfoRow(
                              icon: Icons.date_range,
                              label: 'End Date',
                              value: DateFormat('yyyy-MM-dd')
                                  .format(user.endDate)),
                          const SizedBox(
                            height: 5,
                          ),
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
    int? status, // Add status as an optional parameter
  }) {
    return Row(
      children: [
        Icon(icon, color: defaultColor, size: 20), // Adjust color as needed
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: defaultColor, // Adjust color as needed
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              if (status != null) // Only show badge if status is provided
                _buildStatusBadge(status),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(int status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            status == 1 ? defaultColor : Colors.red, // Use your desired colors
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
}
