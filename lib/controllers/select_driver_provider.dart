import 'dart:convert'; // for JSON conversion
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // Import provider
import 'package:transit_station/controllers/login_provider.dart';
import '../models/select_driver_model.dart'; // for API calls

Future<void> fetchParkingAndDrivers(BuildContext context,
    Function(List<Parking>, List<Driver>) onFetchComplete) async {
  final tokenProvider = Provider.of<TokenModel>(context, listen: false);
  final String? token = tokenProvider.token; // Retrieve the token

  const String url = 'https://transitstation.online/api/admin/parkingdrivers';

  try {
    // Include token in the headers if required
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Add authorization header if needed
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      List<Parking> parkings = (jsonData['parkings'] as List)
          .map((data) => Parking.fromJson(data))
          .toList();

      List<Driver> drivers = (jsonData['drivers'] as List)
          .map((data) => Driver.fromJson(data))
          .toList();

      onFetchComplete(parkings, drivers);
    } else {
      log('Failed to load data. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  } catch (error) {
    log('Error occurred: $error');
  }
}
