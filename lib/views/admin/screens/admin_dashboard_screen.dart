// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/dashboard_controller.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/views/admin/screens/drivers_admin_screen.dart';
import 'package:transit_station/views/admin/screens/expences_screen.dart';
import 'package:transit_station/views/admin/screens/parking_screen.dart';
import 'package:transit_station/views/admin/screens/pickup_location_screen.dart';
import 'package:transit_station/views/admin/screens/request_admin_screen.dart';
import 'package:transit_station/views/admin/screens/revenue_screen.dart';
import 'package:transit_station/views/admin/screens/users_admin_screen.dart';
import 'package:transit_station/views/admin/widgets/profit_bar_chart.dart';
import 'package:transit_station/views/admin/widgets/stat_container.dart';
import 'package:transit_station/views/auth_screens/views/login_screen.dart';

import 'subscriptions_admin_screen.dart';
import 'package:http/http.dart' as http;

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    Provider.of<DashboardController>(context, listen: false)
        .fetchDashboardData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: defaultColor,
                  ),
                  child: Text('Admin Menu',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Pick-Up Locations'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const PickupLocationScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_parking),
                  title: const Text('Parking'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const ParkingScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('logout'),
                  onTap: () async {
                    const url =
                        'https://transitstation.online/api/admin/logout';
                    final tokenProvider =
                        Provider.of<TokenModel>(context, listen: false);
                    final token = tokenProvider.token;
                    try {
                      final response =
                          await http.post(Uri.parse(url), headers: {
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
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Admin',
                          style: TextStyle(
                              color: defaultColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 30)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.notifications_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Builder(
                              builder: (context) => IconButton(
                                icon:
                                    const Icon(Icons.menu, color: defaultColor),
                                onPressed: () {
                                  Scaffold.of(context)
                                      .openDrawer(); // Open the drawer
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<DashboardController>(
                  builder: (context, dashboardProvider, _) {
                    if (dashboardProvider.dashboardData == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Expanded(
                        child: GridView.count(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          const UsersAdminScreen()));
                                },
                                child: StatContainer(
                                    title: 'users',
                                    statNum: dashboardProvider
                                        .dashboardData!.pickUpLocationCount)),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          const RequestAdminScreen()));
                                },
                                child: StatContainer(
                                    title: 'requests',
                                    statNum: dashboardProvider
                                        .dashboardData!.parkingCount)),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          const SubscriptionsAdminScreen()));
                                },
                                child: StatContainer(
                                    title: '#Subscriptions',
                                    statNum: dashboardProvider
                                        .dashboardData!.subscriptionCount)),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => const RevenueScreen()));
                              },
                              child: StatContainer(
                                  title: 'Revenue',
                                  statNum: dashboardProvider
                                      .dashboardData!.revenueAmount
                                      .toInt()),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => const ExpencesScreen()));
                              },
                              child: StatContainer(
                                  title: 'Expenses',
                                  statNum: dashboardProvider
                                      .dashboardData!.expenceAmount
                                      .toInt()),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DriversAdminScreen()));
                              },
                              child: StatContainer(
                                  title: '#Drivers',
                                  statNum: dashboardProvider
                                      .dashboardData!.driverCount),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const Expanded(child: ProfitBarChart()),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
