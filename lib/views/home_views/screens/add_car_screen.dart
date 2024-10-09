// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http; // Import http package
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/image_services.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/views/home_views/screens/home_screen.dart';
import '../../../constants/colors.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();
  String? base64Image;
  File? _image;
  Future<void> _postCarDetails() async {
    if (_carNameController.text.isEmpty ||
        _carNumberController.text.isEmpty ||
        _image == null) {
      showTopSnackBar(context, 'You must fill all the fields', Icons.error,
          Colors.red, const Duration(seconds: 4));

      return; // Exit the function if validation fails
    }

    base64Image = Provider.of<ImageServices>(context, listen: false)
        .convertImageToBase64(_image!);

    // API URL
    const String url = 'https://transitstation.online/api/user/car/add';

    // Create request body
    Map<String, dynamic> body = {
      'car_name': _carNameController.text,
      'car_number': int.parse(_carNumberController.text),
      if (base64Image != null) 'car_image': base64Image
    };

    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      log(body.toString());
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: defaultColor,
              content: Text('Request successful!')),
        );
        Future.delayed(
          const Duration(seconds: 1),
          () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        );
      } else {
        log(response.body);
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error posting data: $e');
      // Handle exception (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add Car'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Write your car details to identify it',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromRGBO(94, 94, 94, 1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _carNameController,
                    decoration: inputDecoration('Car Name'),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _carNumberController,
                    decoration: inputDecoration('Car Number'),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Upload button
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Provider.of<ImageServices>(context,
                                    listen: false)
                                .pickImage();
                            setState(() {
                              _image = Provider.of<ImageServices>(context,
                                      listen: false)
                                  .image;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  color: defaultColor,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'No image selected',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _postCarDetails();
              }, // Call the post function
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 140),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
