import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/get_admin_drivers.dart';
import 'package:transit_station/views/admin/screens/add_driver_admin_screen.dart';

class DriversAdminScreen extends StatelessWidget {
  const DriversAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithActions(context, 'Drivers', () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const AddDriversAdminScreen()),
        );
      }),
      body: FutureBuilder<void>(
        future: Provider.of<GetDriverDataProvider>(context, listen: false)
            .getDriverData(context), // Fetch driver data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final drivers =
                Provider.of<GetDriverDataProvider>(context).drivers?.drivers ??
                    [];

            if (drivers.isEmpty) {
              return const Center(child: Text('No drivers found.'));
            }

            return ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the driver's image at the top (once per driver)
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30, // Adjust size as needed
                                backgroundImage: driver.image != null &&
                                        driver.image!.isNotEmpty
                                    ? MemoryImage(base64Decode(driver.image!))
                                    : const AssetImage('assets/images/boy.png')
                                        as ImageProvider, // Placeholder image
                              ),
                              const SizedBox(width: 10),
                              Text(
                                driver.name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: defaultColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                              height: 10), // Add space after the image and name

                          // Display the rest of the driver information
                          _buildInfoRow(
                            icon: Icons.email,
                            label: 'Email',
                            value: driver.email!,
                          ),
                          const SizedBox(height: 5),
                          _buildInfoRow(
                            icon: Icons.phone,
                            label: 'Phone',
                            value: driver.phone!,
                          ),
                          const SizedBox(height: 5),
                          _buildInfoRow(
                            icon: Icons.money,
                            label: 'Salary',
                            value: driver.salary.toString(),
                          ),
                          const SizedBox(height: 5),
                          _buildInfoRow(
                            icon: Icons.directions_car,
                            label: 'Cars/Month',
                            value: driver.carsPerMonth.toString(),
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
    int? status,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
