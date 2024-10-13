import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/admin/screens/add_request_admin_screen.dart';
import 'package:transit_station/views/admin/screens/return_request.dart';

class ChooseRequest extends StatelessWidget {
  const ChooseRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Request'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First Card: Return Request
            GestureDetector(
              onTap: () {
                // Action on tap, navigate or perform any action
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReturnRequest()));
              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Return Request',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: defaultColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Second Card: New Request
            GestureDetector(
              onTap: () {
                // Action on tap, navigate or perform any action
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddRequestAdminScreen()));
              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'New Request',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: defaultColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
