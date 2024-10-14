// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/controllers/dashboard_controller.dart';
import 'package:transit_station/controllers/image_services.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/controllers/parking_controller.dart';
import '../../../constants/colors.dart';

class AddDriversAdminScreen extends StatefulWidget {
  const AddDriversAdminScreen({super.key});

  @override
  State<AddDriversAdminScreen> createState() => _AddDriversAdminScreenState();
}

class _AddDriversAdminScreenState extends State<AddDriversAdminScreen> {
  bool _obscurePassword = true;
  String? selectedParking;
  String? selectedLocation;
  TextEditingController carsPerMonthController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController salaryController =
      TextEditingController(); // Controller for salary

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ParkingController>(context, listen: false)
          .fetchParking(context);
      Provider.of<DashboardController>(context, listen: false)
          .fetchPickupLocations(context);
    });
  }

  String getShortenedString(String str, int maxLength) {
    return (str.length > maxLength) ? '${str.substring(0, maxLength)}...' : str;
  }

  Future<void> submitFormDriver() async {
    final imageService = Provider.of<ImageServices>(context, listen: false);
    String? base64Image = imageService.image != null
        ? imageService.convertImageToBase64(imageService.image!)
        : null;
    if (firstNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedParking == null ||
        selectedLocation == null ||
        base64Image == null ||
        carsPerMonthController.text.isEmpty ||
        salaryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;

    const apiUrl = 'https://transitstation.online/api/admin/drivers/add';

    try {
      final Map<String, dynamic> formData = {
        'name': firstNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'parking_id': selectedParking,
        'location_id': selectedLocation,
        'cars_per_mounth': carsPerMonthController.text,
        'salary': salaryController.text,
        'image': base64Image, // Use base64 image from the service
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(formData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        log(response.body);
      } else {
        log("${response.statusCode}  ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Driver ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add Driver'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: inputDecoration('Name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: inputDecoration('Email'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: phoneController,
                decoration: inputDecoration('Phone Number'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
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
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Button to select image
              Consumer<ImageServices>(
                builder: (context, imageServices, child) {
                  return Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: imageServices.pickImage,
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('Select Image'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      imageServices.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                imageServices.image!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Colors.grey,
                            ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16.0),
              // Dropdown for selecting location
              Consumer<DashboardController>(
                builder: (context, getDropdowndataProvider, child) {
                  final locations = getDropdowndataProvider.locationData;
                  return DropdownButtonFormField<String>(
                    decoration: inputDecoration('Select Location'),
                    value: selectedLocation,
                    items: locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location.id.toString(),
                        child: Text(
                          getShortenedString(location.pickupAddress,
                              30), // Apply the substring function
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLocation = newValue;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16.0),

              // Dropdown for selecting parking
              Consumer<ParkingController>(
                builder: (context, parkingController, child) {
                  final parkingList = parkingController.parkingData;
                  return DropdownButtonFormField<String>(
                    decoration: inputDecoration('Select Parking'),
                    value: selectedParking,
                    items: parkingList.map((parking) {
                      return DropdownMenuItem<String>(
                        value: parking.id.toString(),
                        child: Text(parking.name),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedParking = newValue;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16.0),

              // Text field for cars per month
              TextField(
                controller: carsPerMonthController,
                decoration: inputDecoration('Cars Per Month'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: salaryController,
                decoration: inputDecoration('Salary'),
              ),
              const SizedBox(height: 50),

              // Submit button
              Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: ElevatedButton(
                  onPressed: submitFormDriver,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    );
  }
}
