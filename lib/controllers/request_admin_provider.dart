import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/get_drivers_admin_model.dart';
import 'package:transit_station/models/request_admin_model.dart';

Future<List<Request>> fetchRequests(BuildContext context) async {
  final tokenProvider = Provider.of<TokenModel>(context, listen: false);
  final String? token = tokenProvider.token;

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final response = await http.get(
    Uri.parse('https://transitstation.online/api/admin/request'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((json) => Request.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load car requests: ${response.reasonPhrase}');
  }
}

class RequestAdminProvider with ChangeNotifier {
  Drivers? _drivers;

  Drivers? get drivers => _drivers;
  Future<void> fetchAvailableDrivers(BuildContext context) async {
    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final String? token = tokenProvider.token;

      final response = await http.get(
        Uri.parse('https://transitstation.online/api/admin/request/drivers'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _drivers = Drivers.fromJson(responseData);
        notifyListeners();
      }
    } catch (e) {
      log("error in fetch drivers: $e");
    }
  }
}
