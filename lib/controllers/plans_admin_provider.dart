// ignore_for_file: avoid_print

import 'dart:convert'; // For jsonDecode and jsonEncode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart'; // Assuming TokenModel is here
import 'package:transit_station/models/plans_admin_model.dart'; // Assuming Plan model is here

class PlanService {
  final String apiUrl = "https://transitstation.online/api/admin/plan";
  final String addPlanUrl = "https://transitstation.online/api/admin/plan/add";

  Future<List<Plan>> fetchPlans(BuildContext context) async {
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
      final List<dynamic> data = jsonDecode(response.body)['plans'];
      return data.map((planJson) => Plan.fromJson(planJson)).toList();
    } else {
      throw Exception("Failed to load plans");
    }
  }

  Future<void> addPlan(
    BuildContext context, {
    required double price,
    required double priceDiscount,
    required String offerName,
    required int duration,
  }) async {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final String? token = tokenProvider.token;

    final response = await http.post(
      Uri.parse(addPlanUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'price': price,
        'price_discount': priceDiscount,
        'offer_name': offerName,
        'duration': duration,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Plan added successfully");
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception("Failed to add plan");
    }
  }
}
