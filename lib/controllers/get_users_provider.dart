import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';

import '../models/users_admin_model.dart';

Future<List<User>> fetchUsers(BuildContext context) async {
  // Get the token from the TokenModel
  final tokenProvider = Provider.of<TokenModel>(context, listen: false);
  final token = tokenProvider.token;

  final response = await http.get(
    Uri.parse('https://transitstation.online/api/admin/users'),
    headers: {
      'Authorization': 'Bearer $token', // Include the token in the headers
    },
  );

  if (response.statusCode == 200) {
    print(response.body);
    List<dynamic> jsonResponse = json.decode(response.body);

    List<User> users = jsonResponse.map((json) => User.fromJson(json)).toList();

    return users;
  } else {
    print(response.body);
    throw Exception('Failed to load users: ${response.statusCode}');
  }
}
