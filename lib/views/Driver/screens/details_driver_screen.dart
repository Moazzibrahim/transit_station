// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/build_appbar.dart';

class DetailsRequestScreen extends StatefulWidget {
  String name;
  String phone;
  String location;
  String carname;
  String parking;
  String carnumber;

  DetailsRequestScreen({
    super.key,
    required this.name,
    required this.carname,
    required this.location,
    required this.phone,
    required this.parking,
    required this.carnumber,
  });

  @override
  _DetailsRequestScreenState createState() => _DetailsRequestScreenState();
}

class _DetailsRequestScreenState extends State<DetailsRequestScreen> {
  // Flag to show/hide the "Car Received" and "Car Arrived" buttons
  bool _showCarButtons = false;

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
            const SizedBox(height: 30),
            // The Start button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // When pressed, show the car buttons
                    setState(() {
                      _showCarButtons = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: defaultColor,
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
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
                      onPressed: () {
                        // Handle car received action
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: defaultColor,
                      ),
                      child: const Text(
                        'Car Received',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle car arrived action
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: defaultColor,
                      ),
                      child: const Text(
                        'Car Arrived',
                        style: TextStyle(color: Colors.white),
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
