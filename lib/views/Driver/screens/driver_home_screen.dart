// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/views/Driver/controller/get_request_driver_provider.dart';
import 'package:transit_station/views/Driver/screens/details_driver_screen.dart';
import 'package:transit_station/views/Driver/screens/notifications_screen.dart';
import 'package:transit_station/views/Driver/screens/personal_info.dart';
import 'package:transit_station/views/Driver/screens/technical_support_driver_screen.dart';
import 'package:transit_station/views/Driver/screens/technical_support_screen.dart';
import 'package:transit_station/views/auth_screens/views/login_screen.dart';

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({super.key});

  @override
  State<HomeDriverScreen> createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<GetRequestDriverProvider>(context, listen: false)
        .getRequestDriverProviderdata(context);
  }

  String getShortenedString(String str, int maxLength) {
    return (str.length > maxLength) ? '${str.substring(0, maxLength)}...' : str;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false); // Prevent back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<GetRequestDriverProvider>(
            builder: (context, requestProvider, child) {
              final driverName =
                  requestProvider.requestModel?.requests.isNotEmpty == true
                      ? requestProvider.requestModel!.requests[0].driver.name
                      : 'Driver';

              return RichText(
                text: TextSpan(
                  text: 'Hello,\n',
                  style: const TextStyle(
                    color: defaultColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: driverName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Consumer<GetRequestDriverProvider>(
              builder: (context, value, child) {
                final driverrequests =
                    value.requestModel?.requests.isNotEmpty == true
                        ? value.requestModel!.requests.length
                        : 0;
                return IconButton(
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
                          child: Text(
                            '$driverrequests',
                            style: const TextStyle(
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
                );
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
                              TechnicalSupportDriverScreen()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: defaultColor,
                ),
                title: const Text('logout'),
                onTap: () async {
                  const url = 'https://transitstation.online/api/driver/logout';
                  final tokenProvider =
                      Provider.of<TokenModel>(context, listen: false);
                  final token = tokenProvider.token;
                  try {
                    final response = await http.post(Uri.parse(url), headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $token',
                    });
                    if (response.statusCode == 200) {
                      final responseBody = json.decode(response.body);
                      log('logout response $responseBody');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('logout successful')));
                    } else {
                      log(response.body);
                      log('Failed to load profile data (Error: ${response.statusCode})');
                    }
                  } catch (e) {
                    log('An error occurred: $e');
                  }
                },
              ),
            ],
          ),
        ),
        body: Consumer<GetRequestDriverProvider>(
          builder: (context, value, child) {
            final requests = value.requestModel?.requests ?? [];

            if (requests.isEmpty) {
              return const Center(
                child: Text(
                  'No requests available',
                  style: TextStyle(fontSize: 18, color: defaultColor),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requests: ${requests.length}',
                    style: const TextStyle(
                      color: defaultColor,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        final driverName = request.driver.name;
                        final userphone = request.userphone;
                        final username = request.username;
                        final carType = request.carName;
                        final location = request.locationName;
                        final parking = request.parkingname;
                        final image = request.carImage;
                        final carnumber = request.carnumber;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsRequestScreen(
                                          carname: carType,
                                          location: location,
                                          name: username,
                                          parking: parking,
                                          phone: userphone,
                                          carnumber: carnumber,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: defaultColor,
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Image.memory(
                                      base64Decode(image),
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name: $driverName",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Type: $carType",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Location: ${getShortenedString(location, 22)}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
