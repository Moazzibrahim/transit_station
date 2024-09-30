import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/admin/screens/pickup_location_screen.dart';
import 'package:transit_station/views/admin/widgets/profit_bar_chart.dart';
import 'package:transit_station/views/admin/widgets/stat_container.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            SvgPicture.asset('assets/images/person.svg'),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.notifications_outlined)
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 20,),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children:  [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx)=> const PickupLocationScreen())
                        );
                      },
                      child: const StatContainer(title: '#Pick-Up Location', statNum: 4)),
                    const StatContainer(title: '#Parking', statNum: 2),
                    const StatContainer(title: '#Subscriptions', statNum: 30),
                    const StatContainer(title: 'Revenue', statNum: 200), // You can customize currency formatting
                    const StatContainer(title: 'Expenses', statNum: 100),
                    const StatContainer(title: '#Drivers', statNum: 6),
                  ],
                ),
              ),
              const Expanded(child: ProfitBarChart()),
              const SizedBox(height: 60,)
            ],
          ),
          ),
      ),
    );
  }
}