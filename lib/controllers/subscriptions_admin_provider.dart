import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/subscriptions_model.dart';

class SubscriptionService {
  final String apiUrl = "https://transitstation.online/api/admin/subscription";

  Future<List<User>> fetchSubscriptions(BuildContext context) async {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final String? token = tokenProvider.token;

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['users'];
      return data.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception("Failed to load subscriptions");
    }
  }
}
