import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit_station/controllers/dashboard_controller.dart';
import 'package:transit_station/controllers/expences_provider.dart';
import 'package:transit_station/controllers/get_dropdowndata_provider.dart';
import 'package:transit_station/controllers/get_profile_data.dart';
import 'package:transit_station/controllers/image_services.dart';

import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/controllers/parking_controller.dart';
import 'package:transit_station/controllers/revenue_provider.dart';
import 'package:transit_station/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginModel>(
          create: (_) => LoginModel(),
        ),
        ChangeNotifierProvider<TokenModel>(
          create: (_) => TokenModel(),
        ),
        ChangeNotifierProvider<DashboardController>(
          create: (_) => DashboardController(),
        ),
        ChangeNotifierProvider(create: (_) => GetDropdowndataProvider()),
        ChangeNotifierProvider(create: (_) => GetProfileData()),
        ChangeNotifierProvider(create: (_) => ImageServices()),
        ChangeNotifierProvider(create: (_) => ParkingController()),
        ChangeNotifierProvider(create: (_) => RevenueProvider()),
        ChangeNotifierProvider(create: (_) => ExpencesProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
