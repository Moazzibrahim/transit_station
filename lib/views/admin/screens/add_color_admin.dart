// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:http/http.dart' as http;

class AddColorAdmin extends StatefulWidget {
  const AddColorAdmin({super.key});

  @override
  State<AddColorAdmin> createState() => _AddCarAdminState();
}

class _AddCarAdminState extends State<AddColorAdmin> {
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carCodeController = TextEditingController();

  Future<void> _postCarDetails() async {
    if (_carNameController.text.isEmpty || // Add color validation
        _carCodeController.text.isEmpty) {
      showTopSnackBar(context, 'You must fill all the fields', Icons.error,
          Colors.red, const Duration(seconds: 4));

      return; // Exit the function if validation fails
    }

    // API URL
    const String url = 'https://transitstation.online/api/admin/color/add';

    // Create request body
    Map<String, dynamic> body = {
      'color_name': _carNameController.text, // Convert color to hex string
      'colors_code': _carCodeController.text,
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
        if (!mounted) {
          return; // Ensure the widget is still mounted before navigation
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: defaultColor,
              content: Text('color added successfully!')),
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
      appBar: buildAppBar(context, 'Add Color'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _carNameController,
                    decoration: inputDecoration('Color Name'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _carCodeController,
                    decoration: inputDecoration('Color Code'),
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
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text('Add Color',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
