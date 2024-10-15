// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart'; // Import provider package
import 'package:transit_station/views/Driver/screens/driver_home_screen.dart';
import '../../../controllers/login_provider.dart';

class TechnicalSupportDriverScreen extends StatefulWidget {
  const TechnicalSupportDriverScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TechnicalSupportDriverScreenState createState() =>
      _TechnicalSupportDriverScreenState();
}

class _TechnicalSupportDriverScreenState
    extends State<TechnicalSupportDriverScreen> {
  final TextEditingController _complaintController = TextEditingController();

  Future<void> _submitComplaint() async {
    const String url = 'https://transitstation.online/api/driver/complaint';
    final String complaint = _complaintController.text;

    if (complaint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a complaint"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Get the token from TokenModel provider
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'complaint': complaint}),
      );

      if (response.statusCode == 200) {
        _showConfirmationDialog();
        _complaintController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to submit your complaint"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred"),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content:
              const Text("Your complaint has been submitted successfully."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeDriverScreen()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Technical support"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text(
              "If you have a problem, please write it down here",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _complaintController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: defaultColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: defaultColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Your complaint",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 130,
                  vertical: 16,
                ),
              ),
              onPressed: _submitComplaint,
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
