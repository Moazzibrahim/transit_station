import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/get_drivers_admin_model.dart';

class GetDriverDataProvider with ChangeNotifier {
  Drivers? _drivers;

  Drivers? get drivers => _drivers;

  Future<void> getDriverData(BuildContext context) async {
    const url = 'https://transitstation.online/api/admin/drivers';
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      try {
        final responsebody = json.decode(response.body);
        _drivers = Drivers.fromJson(responsebody); // Store the MainData object
        notifyListeners(); // Notify listeners after the data is stored
      } catch (e) {
        log('Error parsing dropdown data: $e');
      }
    } else {
      log('Error in getting dropdown data: ${response.statusCode}');
    }
  }
}
