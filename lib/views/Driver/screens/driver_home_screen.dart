// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/Driver/screens/details_driver_screen.dart';
import 'package:transit_station/views/Driver/screens/notifications_screen.dart';
import 'package:transit_station/views/Driver/screens/personal_info.dart';
import 'package:transit_station/views/Driver/screens/technical_support_screen.dart';

class HomeDriverScreen extends StatelessWidget {
  const HomeDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false); // Prevent back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: const TextSpan(
              text: 'Hello,\n',
              style: TextStyle(
                color: defaultColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Muhammad',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: defaultColor,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: defaultColor,
                ),
                title: const Text('personal info'),
                onTap: () {
                  // Handle Profile tap
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersonalInfoScreen()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.call,
                  color: defaultColor,
                ),
                title: const Text('Technical support'),
                onTap: () {
                  // Handle Settings tap
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TechnicalSupportScreen()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: defaultColor,
                ),
                title: const Text('log out'),
                onTap: () {
                  // Handle Settings tap
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Request: 1',
                style: TextStyle(
                  color: defaultColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: defaultColor,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/car.png",
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Column(
                        children: [
                          Text(
                            "Name:      Ahmed Ali",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Type:     BMW X5",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Location:   Zamalek",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DetailsRequestScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: defaultColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 130, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text(
                    "details",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
