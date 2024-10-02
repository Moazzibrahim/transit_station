// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/views/admin/screens/admin_dashboard_screen.dart';
import 'package:transit_station/views/home_views/screens/home_screen.dart';

class TokenModel with ChangeNotifier {
  String? _token;
  String? get token => _token;

  Future<void> setToken(String token) async {
    _token = token;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
    notifyListeners();
  }
}


class LoginModel with ChangeNotifier {
  String? _role;
  String? _name;
  String? _phone;
  String? _email;
  String? get role => _role;
  String? get name => _name;
  String? get phone => _phone;
  String? get email => _email;
  late int _id;
  int get id => _id;

  void setId(int id) {
    _id = id;
    notifyListeners();
  }

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  static const String apiUrl = 'https://transitstation.online/api/login';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      String message = 'Invalid: ';
      if (email.isEmpty) message += 'Email is empty. ';
      if (password.isEmpty) message += 'Password is empty.';
      _showSnackbar(context, message);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        log(response.body);
        log("token: ${responseData['token']}");

        if (responseData.containsKey('faield')) {
          _showSnackbar(context, "خطأ في التسجيل");
          return;
        }

        if (responseData.containsKey('token')) {
          final String token = responseData['token'];
          Provider.of<TokenModel>(context, listen: false).setToken(token);

          final userdata = responseData['data'] as Map<String, dynamic>;
          _name = userdata['name'];
          _phone = userdata['phone'];
          _email = userdata['email'];
          int id = userdata['id'];
          setId(id);

          _handleuserdata(context, userdata);
        } else {
          showTopSnackBar(context,'something went wrong',Icons.warning,Colors.red,const Duration(seconds: 5));
        }
      } else {
        showTopSnackBar(context,'Check your credentials',Icons.warning,Colors.red,const Duration(seconds: 5));
      }
    } catch (error) {
      log('Error during authentication: $error');
      _showSnackbar(context, "حدث خطأ في الاتصال، حاول مرة أخرى");
    }
  }

  void _handleuserdata(BuildContext context, Map<String, dynamic> userdata) {
    if (userdata.containsKey('role')) {
      final String role = userdata['role'];
      setRole(role);
      _navigateBasedOnRole(context, role);
    } else {
      _showSnackbar(context, 'Role not found in response');
    }
  }

  void _navigateBasedOnRole(BuildContext context, String role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if(role == 'admin'){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      }
      else {
        _showSnackbar(context, 'Unknown user role');
      }
    } catch (error) {
      log('Error during navigation: $error');
      _showSnackbar(context, 'خطأ أثناء التنقل');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
