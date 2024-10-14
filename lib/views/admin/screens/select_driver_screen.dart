// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/views/admin/screens/request_admin_screen.dart';
import '../../../controllers/select_driver_provider.dart';
import '../../../models/select_driver_model.dart';

class SelectDriverScreen extends StatefulWidget {
  final String requestId;

  const SelectDriverScreen({super.key, required this.requestId});

  @override
  // ignore: library_private_types_in_public_api
  _SelectDriverScreenState createState() => _SelectDriverScreenState();
}

class _SelectDriverScreenState extends State<SelectDriverScreen> {
  String? selectedParking;
  String? selectedDriverId; // Store the selected driver ID
  List<Parking> parkingOptions = [];
  List<Driver> drivers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParkingAndDrivers(context, (parkings, drivers) {
      setState(() {
        parkingOptions = parkings;
        this.drivers = drivers;
        isLoading = false;
      });
    });
  }

  Future<void> postDriver(String driverId) async {
    // Fetch the token
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final String? token = tokenProvider.token;

    final url =
        'https://transitstation.online/api/admin/request/selectdriver/${widget.requestId}';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
        body: jsonEncode({'driver_id': driverId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: defaultColor,
              content: Text('Driver selected successfully!')),
        );

        await Future.delayed(const Duration(seconds: 1));

        // Navigate to the RequestAdminScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RequestAdminScreen()),
        );
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (error) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select driver: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Select Driver'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                      hint: const Text('Select Parking'),
                      value: selectedParking,
                      items: parkingOptions.map((parking) {
                        return DropdownMenuItem<String>(
                          value: parking.name,
                          child: Text(parking.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedParking = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: drivers.length,
                      itemBuilder: (context, index) {
                        final driver = drivers[index];
                        // Filter by selected parking
                        if (selectedParking == null ||
                            parkingOptions
                                    .firstWhere((parking) =>
                                        parking.id == driver.parkingId)
                                    .name ==
                                selectedParking) {
                          return DriverCard(
                            name: driver.name,
                            phone: driver.phone,
                            email: driver.email,
                            parking: parkingOptions
                                .firstWhere(
                                    (parking) => parking.id == driver.parkingId)
                                .name,
                            image: driver.image,
                            onSelect: () {
                              setState(() {
                                selectedDriverId = driver.id
                                    .toString(); // Set selected driver ID
                              });
                              postDriver(driver.id
                                  .toString()); // Call postDriver directly
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class DriverCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String parking;
  final String image; // Add the image parameter
  final VoidCallback onSelect; // Callback to handle selection

  const DriverCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.parking,
    required this.image, // Include the image in the constructor
    required this.onSelect, // Include onSelect in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect, // Call the onSelect callback when tapped
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(
            color: defaultColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: (image.isNotEmpty)
                    ? MemoryImage(
                        base64Decode(image)) // Decode the image from base64
                    : const AssetImage('assets/images/amal.png'),
              ),
              const SizedBox(width: 16.0),
              // Driver info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outline, color: defaultColor),
                        const SizedBox(width: 8),
                        Text(
                          "Name: $name",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: defaultColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: defaultColor),
                        const SizedBox(width: 8),
                        Text(
                          "Phone: $phone",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email, color: defaultColor),
                        const SizedBox(width: 8),
                        Text(
                          "Email: $email",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.local_parking, color: defaultColor),
                        const SizedBox(width: 8),
                        Text(
                          "Parking: $parking",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
