import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import '../../../controllers/select_driver_provider.dart';
import '../../../models/select_driver_model.dart';

class SelectDriverScreen extends StatefulWidget {
  const SelectDriverScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SelectDriverScreenState createState() => _SelectDriverScreenState();
}

class _SelectDriverScreenState extends State<SelectDriverScreen> {
  String? selectedParking;
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
        isLoading = false; // Update loading state
      });
    }); // Fetch the data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'drivers'),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator while fetching data
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Filter parking dropdown
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
                  // List of driver cards filtered by parking
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

  const DriverCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.parking,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
            // Profile image
            const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
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
                      const Icon(Icons.location_on, color: defaultColor),
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
    );
  }
}
