import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/get_profile_data.dart';
import 'package:transit_station/views/Driver/screens/notifications_screen.dart';
import 'package:transit_station/views/auth_screens/views/request_screen.dart';
import 'package:transit_station/views/home_views/screens/user_profile/user_profile.dart';
import 'package:transit_station/views/home_views/widgets/car_container.dart';
import 'package:transit_station/views/subscription/views/subscription_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Consumer<GetProfileData>(
      builder: (context, profileProvider, child) {
        if (profileProvider.userProfileModel == null &&
            !profileProvider.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            profileProvider.getprofile(context);
          });
        }
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello,',
                              style: TextStyle(
                                  color: defaultColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${profileProvider.userProfileModel!.name!}',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  child: SvgPicture.asset(
                                      'assets/images/person.svg'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UserProfile()));
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  child:
                                      const Icon(Icons.notifications_outlined),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NotificationScreen()));
                                  },
                                )
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
                      height: 15,
                    ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Cars',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See all',
                              style: TextStyle(
                                  color: defaultColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  decorationColor: defaultColor),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) {
                            return CarContainer(
                                name: 'BMW X5',
                                image: 'assets/images/bmw.png',
                                selectedItem: selectedItem);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Youe active subscription',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
