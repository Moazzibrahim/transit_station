// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/get_profile_data.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/views/Driver/screens/technical_support_screen.dart';
import 'package:transit_station/views/auth_screens/views/login_screen.dart';
import 'package:transit_station/views/auth_screens/views/request_screen.dart';
import 'package:transit_station/views/home_views/screens/my_cars_screen.dart';
import 'package:transit_station/views/home_views/screens/user_profile/user_profile.dart';
import 'package:transit_station/views/home_views/widgets/car_container.dart';
import 'package:transit_station/views/subscription/views/subscription_screen.dart';

import '../../../controllers/car_provider.dart';
import '../../../models/cars_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedItem;
  List<Car>? cars; // Store the fetched cars here
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    final fetchedCars = await ApiService().fetchUserCars(context);
    setState(() {
      cars = fetchedCars;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetProfileData>(
      builder: (context, profileProvider, child) {
        if (profileProvider.userProfileModel == null &&
            !profileProvider.isLoading) {
          // Fetch the profile data if it's not loaded yet
          WidgetsBinding.instance.addPostFrameCallback((_) {
            profileProvider.getprofile(context);
          });
        }

        // Show loading if profile data is not yet loaded
        if (profileProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                        decoration: BoxDecoration(color: defaultColor),
                        child: Text('Menu',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24))),
                    ListTile(
                      leading: SvgPicture.asset('assets/images/person.svg'),
                      title: const Text('Personal info'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserProfile()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.help,
                        color: defaultColor,
                      ),
                      title: const Text('Technical support'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const TechnicalSupportScreen()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: defaultColor,
                      ),
                      title: const Text('logout'),
                      onTap: () async {
                        const url =
                            'https://transitstation.online/api/user/logout';
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
                                const SnackBar(
                                    content: Text('logout successful')));
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello,',
                              style: TextStyle(
                                  color: defaultColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400),
                            ),
                            // Check if the name is null before displaying it
                            Text(
                              profileProvider.userProfileModel?.name ?? 'Guest',
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Builder(
                                  builder: (context) => IconButton(
                                    icon: const Icon(Icons.menu,
                                        color: defaultColor),
                                    onPressed: () {
                                      Scaffold.of(context)
                                          .openDrawer(); // Open the drawer
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 130,
                      width: double.infinity,
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: yellowColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Enjoy feature-packed parking',
                            style: TextStyle(
                                color: defaultColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RequestForm()));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  backgroundColor: defaultColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 9, horizontal: 8)),
                              child: const Text(
                                'Request Now',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Cars',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        cars == null ||
                                cars!
                                    .isEmpty // Show Add icon if cars is null or empty
                            ? IconButton(
                                icon:
                                    const Icon(Icons.add, color: defaultColor),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => const MyCarsScreen(),
                                  ));
                                },
                              )
                            : TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => const MyCarsScreen(),
                                  ));
                                },
                                child: const Text(
                                  'See all',
                                  style: TextStyle(
                                    color: defaultColor,
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    decorationColor: defaultColor,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (cars == null || cars!.isEmpty
                            ? const Center(
                                child: Text(
                                    'No cars available. You should add your car'))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: cars!.map((car) {
                                    String carImage = (car.carImage != null &&
                                            car.carImage!.isNotEmpty)
                                        ? car.carImage!
                                        : 'assets/images/bmw.png';

                                    return CarContainer(
                                      name: car.carName,
                                      image: carImage,
                                      selectedItem: selectedItem,
                                    );
                                  }).toList(),
                                ),
                              )),
                    const SizedBox(height: 20),
                    const Text(
                      'Your active subscription',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Annual subscription was renewed on 25/12/2023 and is valid until 25/12/2024',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const SubscriptionScreen()));
                      },
                      child: Container(
                        width: 220,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: defaultColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            'Subscription Renewal',
                            style: TextStyle(
                                color: defaultColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
