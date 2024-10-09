import 'dart:convert'; // For jsonDecode
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart'; // For making HTTP requests

Future<Map<String, dynamic>?> fetchDropdownData(BuildContext context) async {
  const String apiUrl =
      'https://transitstation.online/api/admin/request/dropdown';

  final tokenProvider = Provider.of<TokenModel>(context, listen: false);
  final token = tokenProvider.token;

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Decode the JSON response into a Map
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    log("Error occurred while fetching data: $e");
    return null;
  }
}
