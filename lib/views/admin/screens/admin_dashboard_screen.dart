import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/dashboard_controller.dart';
import 'package:transit_station/views/admin/screens/parking_screen.dart';
import 'package:transit_station/views/admin/screens/pickup_location_screen.dart';
import 'package:transit_station/views/admin/widgets/profit_bar_chart.dart';
import 'package:transit_station/views/admin/widgets/stat_container.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    Provider.of<DashboardController>(context,listen: false).fetchDashboardData(context);
    super.initState();
  }
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
              Consumer<DashboardController>(
                builder: (context, dashboardProvider, _) {
                  if(dashboardProvider.dashboardData == null) {
                    return const Center(child: CircularProgressIndicator(),);
                  }else{
                    return Expanded(
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
                        child: StatContainer(title: '#Pick-Up Location', statNum: dashboardProvider.dashboardData!.pickUpLocationCount)),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx)=> const ParkingScreen())
                          );
                        },
                        child: StatContainer(title: '#Parking', statNum: dashboardProvider.dashboardData!.parkingCount)),
                      StatContainer(title: '#Subscriptions', statNum: dashboardProvider.dashboardData!.subscriptionCount),
                      StatContainer(title: 'Revenue', statNum: dashboardProvider.dashboardData!.revenueAmount.toInt()), // You can customize currency formatting
                      StatContainer(title: 'Expenses', statNum: dashboardProvider.dashboardData!.expenceAmount.toInt()),
                      StatContainer(title: '#Drivers', statNum: dashboardProvider.dashboardData!.driverCount),
                    ],
                  ),
                );
                  }
                },
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