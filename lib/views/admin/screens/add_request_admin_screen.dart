// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/controllers/notifications_services.dart';

import '../../../controllers/admin_dropdown_provider.dart';

class AddRequestAdminScreen extends StatefulWidget {
  const AddRequestAdminScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddRequestAdminScreenState createState() => _AddRequestAdminScreenState();
}

class _AddRequestAdminScreenState extends State<AddRequestAdminScreen> {
  Future<void> submitRequest(BuildContext context) async {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final String? token = tokenProvider.token;

    if (selectedCar != null &&
        selectedLocation != null &&
        selectedDriver != null &&
        selectedUser != null &&
        selectedDate != null &&
        selectedTime != null) {
      // Format the date and time into the expected string formats
      String formattedDate =
          "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";
      String formattedTime =
          "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

      // Create the request body
      Map<String, String> requestBody = {
        'car_id': selectedCar!,
        'location_id': selectedLocation!,
        'driver_id': selectedDriver!,
        'user_id': selectedUser!,
        'pick_up_date': formattedDate,
        'request_time': formattedTime,
      };

      try {
        var response = await http.post(
          Uri.parse('https://transitstation.online/api/admin/request/make'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Add the token here
          },
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print("Request submitted successfully: $responseData");

          final notificationService =
              Provider.of<NotificationsServices>(context, listen: false);
          notificationService.sendNotification('Request Submitted',
              'Your return request has been successfully submitted!', 'driver');

          // Show success Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Clear the form data
          setState(() {
            selectedCar = null;
            selectedLocation = null;
            selectedDriver = null;
            selectedUser = null;
            selectedDate = null;
            selectedTime = null;
          });
        } else {
          log(response.statusCode.toString());

          // Show error Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit request.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print("Error occurred: $e");

        // Show error Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print("Please fill out all the fields.");

      // Show warning Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all the fields.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  String? selectedLocation;
  String? selectedCar;
  String? selectedDriver;
  String? selectedUser;

  DateTime? selectedDate;
  DateTime? selectedEndDate;
  TimeOfDay? selectedTime;
  List<dynamic> locations = [];
  List<dynamic> cars = [];
  List<dynamic> drivers = [];
  List<dynamic> users = [];

  List<dynamic> filteredCars = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationsServices>(context, listen: false)
          .getAccessToken();
    });
    fetchDropdownData(context).then((data) {
      if (data != null) {
        setState(() {
          locations = data['locations'];
          cars = data['cars'];
          drivers = data['drivers'];
          users = data['users'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add Request'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Space between elements
          children: [
            Column(
              children: [
                buildDropdownButtonFormField(
                  labelText: 'Select User',
                  value: selectedUser,
                  items: users,
                  onChanged: (value) {
                    setState(() {
                      selectedUser = value;

                      filteredCars = cars.where((car) {
                        return car['user_id'].toString() == selectedUser;
                      }).toList();

                      selectedCar = null;
                    });
                  },
                  getItemText: (item) => item['name'] ?? 'Unknown',
                ),
                const SizedBox(height: 16),
                buildDropdownButtonFormField(
                  labelText: 'Select Car',
                  value: selectedCar,
                  items: filteredCars,
                  onChanged: (value) {
                    setState(() {
                      selectedCar = value;
                    });
                  },
                  getItemText: (item) => item['car_name'] ?? 'Unknown',
                ),
                const SizedBox(height: 16),
                buildDropdownButtonFormField(
                  labelText: 'Select Location',
                  value: selectedLocation,
                  items: locations,
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                    });
                  },
                  getItemText: (item) => item['pick_up_address'] ?? 'Unknown',
                ),
                const SizedBox(height: 16),
                buildDropdownButtonFormField(
                  labelText: 'Select Driver',
                  value: selectedDriver,
                  items: drivers,
                  onChanged: (value) {
                    setState(() {
                      selectedDriver = value;
                    });
                  },
                  getItemText: (item) => item['name'] ?? 'Unknown',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Pick up date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: defaultColor),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: defaultColor),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: TextEditingController(
                    text: selectedDate == null
                        ? ''
                        : "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Pick up time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: defaultColor),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: defaultColor),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: TextEditingController(
                    text: selectedTime == null
                        ? ''
                        : "${selectedTime!.hour}:${selectedTime!.minute}",
                  ),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: ' Return date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: defaultColor),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: defaultColor),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: TextEditingController(
                    text: selectedEndDate == null
                        ? ''
                        : "${selectedEndDate!.year}-${selectedEndDate!.month}-${selectedEndDate!.day}",
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedEndDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  submitRequest(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: defaultColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Submit',
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
      ),
    );
  }

  DropdownButtonFormField<String> buildDropdownButtonFormField({
    required String labelText,
    required String? value,
    required List<dynamic> items,
    required void Function(String?) onChanged,
    required String Function(dynamic) getItemText, // Extract the display text
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: defaultColor),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: defaultColor),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
      value: value,
      items: items.isNotEmpty
          ? items.map((item) {
              return DropdownMenuItem<String>(
                value: item['id']?.toString() ?? '',
                child: Text(getItemText(item)),
              );
            }).toList()
          : [],
      onChanged: (newValue) {
        onChanged(newValue ?? '');
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a $labelText';
        }
        return null;
      },
    );
  }
}
