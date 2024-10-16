// ignore_for_file: must_be_immutable, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/login_provider.dart';

class DetailsRequestScreen extends StatefulWidget {
  String name;
  String phone;
  String location;
  String carname;
  String parking;
  String carnumber;
  String pickupdate;
  int id;

  DetailsRequestScreen({
    super.key,
    required this.name,
    required this.carname,
    required this.location,
    required this.phone,
    required this.parking,
    required this.carnumber,
    required this.pickupdate,
    required this.id,
  });

  @override
  _DetailsRequestScreenState createState() => _DetailsRequestScreenState();
}

class _DetailsRequestScreenState extends State<DetailsRequestScreen> {
  // Flags to show/hide the "Car Received" and "Car Arrived" buttons
  bool _showCarButtons = false;

  // Flags to track if the buttons have been pressed
  bool _carReceivedPressed = false;
  bool _carArrivedPressed = false;
  bool _startPressed = false; // Flag for the Start button

  Future<void> putRequest() async {
    const url =
        'https://transitstation.online/api/driver/onthewayupdate'; // Replace with your API endpoint
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'request_id': widget.id, // Add any additional fields you need for the API
    });

    try {
      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        // Successfully updated
        print('Car status updated successfully');
        print(response.body);
        setState(() {
          _startPressed = true; // Disable the start button after pressing
          _showCarButtons = true; // Show car buttons after successful start
        });
        showTopSnackBar(context, 'you started the request successfully',
            Icons.check, defaultColor, const Duration(seconds: 3));
      } else {
        // Handle error response
        print(
            'Failed to update car status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> putRequestrecieved() async {
    const url =
        'https://transitstation.online/api/driver/carrecivedupdate'; // Replace with your API endpoint
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'request_id': widget.id, // Add any additional fields you need for the API
    });

    try {
      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        // Successfully updated
        print('Car status updated successfully');
        print(response.body);
        setState(() {
          _carReceivedPressed = true; // Disable after pressing
        });
        showTopSnackBar(context, 'you received the car successfully',
            Icons.check, defaultColor, const Duration(seconds: 3));
      } else {
        // Handle error response
        print(
            'Failed to update car status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> putRequestarrived() async {
    const url =
        'https://transitstation.online/api/driver/arrivedupdate'; // Replace with your API endpoint
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'request_id': widget.id, // Add any additional fields you need for the API
    });

    try {
      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        // Successfully updated
        print('Car status updated successfully');
        print(response.body);
        setState(() {
          _carArrivedPressed = true; // Disable after pressing
        });
        showTopSnackBar(context, 'you arrived the car successfully',
            Icons.check, defaultColor, const Duration(seconds: 3));
      } else {
        // Handle error response
        print(
            'Failed to update car status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Details Request"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDetail(title: 'Name', value: '     ${widget.name}'),
            TextDetail(title: 'Phone', value: '   ${widget.phone}'),
            TextDetail(title: 'Car Name', value: '   "${widget.carname}"'),
            TextDetail(title: 'Car Number', value: '   "${widget.carnumber}"'),
            TextDetail(title: 'Location', value: widget.location),
            TextDetail(title: 'Parking', value: widget.parking),
            TextDetail(title: 'pickup date', value: widget.pickupdate),
            const SizedBox(height: 30),
            // The Start button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startPressed
                      ? null // Disable if already pressed
                      : () {
                          // When pressed, show the car buttons and disable Start
                          putRequest();
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: defaultColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Start',
                        style: TextStyle(color: Colors.white),
                      ),
                      if (_startPressed)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Conditionally show the "Car Received" and "Car Arrived" buttons
            if (_showCarButtons)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _carReceivedPressed
                          ? null // Disable if already pressed
                          : () {
                              // Handle car received action
                              putRequestrecieved();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: defaultColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Car Received',
                            style: TextStyle(color: Colors.white),
                          ),
                          if (_carReceivedPressed)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _carArrivedPressed
                          ? null // Disable if already pressed
                          : () {
                              // Handle car arrived action
                              putRequestarrived();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: defaultColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Car Arrived',
                            style: TextStyle(color: Colors.white),
                          ),
                          if (_carArrivedPressed)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class TextDetail extends StatelessWidget {
  final String title;
  final String value;

  const TextDetail({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
