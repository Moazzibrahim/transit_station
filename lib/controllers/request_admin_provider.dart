import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/request_admin_model.dart';

Future<List<CarRequest>> fetchCarRequests(BuildContext context) async {
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
    return jsonResponse.map((json) => CarRequest.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load car requests: ${response.reasonPhrase}');
  }
}
