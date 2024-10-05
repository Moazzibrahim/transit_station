import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart'; // Required for context and Provider
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/subscription_model.dart'; // Import Provider

class ApiService {
  final String apiUrl =
      "https://transitstation.online/api/user/subscription-details";

  Future<UserOffersResponse?> fetchUserSubscription(
      BuildContext context) async {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final String? token = tokenProvider.token;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        UserOffersResponse userOffersResponse =
            UserOffersResponse.fromJson(jsonResponse);

        return userOffersResponse;
      } else {
        log("Failed to load data. Status code: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      log("Error occurred: $error");
      return null;
    }
  }
}
