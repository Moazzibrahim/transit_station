import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/views/Driver/models/get_profile_driver_model.dart';

class GetProfileDriver with ChangeNotifier {
  ProfileResponse? _profileDriver;
  ProfileResponse? get profileDriver => _profileDriver;

  Future<void> getProfileDriverProviderdata(BuildContext context) async {
    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      final response = await http.get(
        Uri.parse('https://transitstation.online/api/driver/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _profileDriver = ProfileResponse.fromJson(responseData);
        notifyListeners();
      } else {
        log('status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in fetching dashboard data: $e');
    }
  }
}
