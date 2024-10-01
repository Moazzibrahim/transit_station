import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/cars_model.dart';

class ApiService {
  final String carApiUrl = "https://transitstation.online/api/user/car";

  // Function to fetch car data from the API
  Future<List<Car>?> fetchUserCars(BuildContext context) async {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final String? token = tokenProvider.token;

    try {
      final response = await http.get(
        Uri.parse(carApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Decode the response body as a map
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Extract the list of cars from the 'success' key
        final List<dynamic> carDataList = jsonResponse['success'];

        // Convert the list of dynamic maps into a list of Car objects
        List<Car> carList = carDataList.map((carData) {
          return Car.fromJson(carData);
        }).toList();

        return carList;
      } else {
        log("Failed to load car data. Status code: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      log("Error occurred while fetching car data: $error");
      return null;
    }
  }
}
