import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transit_station/views/auth_screens/views/login_screen.dart';
import 'package:transit_station/views/onboarding_screen.dart';

class OnBoardingCheck extends StatefulWidget {
  const OnBoardingCheck({super.key});

  @override
  State<OnBoardingCheck> createState() => _OnBoardingCheckState();
}

class _OnBoardingCheckState extends State<OnBoardingCheck> {
  bool _isNewUser = true; // Default to true in case it's the first launch
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user is new
    _isNewUser = prefs.getBool('isNewUser') ?? true;

    // Check if the user is logged in
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Update the state to reflect the current status
    setState(() {});
  }

  void setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  @override
  Widget build(BuildContext context) {
    // If the user is new, show the onboarding screens
    if (_isNewUser) {
      return const OnboardingScreen();
    } 
    // If the user is not logged in, show the login screen
    else if (!_isLoggedIn) {
      return const LoginScreen();
    } 
    // Handle cases where user should proceed to the app
    else {
      return const LoginScreen(); // Or another screen depending on your app's flow
    }
  }
}
