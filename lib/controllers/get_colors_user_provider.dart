import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/get_car_user_model.dart';

class GetColorsUserProvider with ChangeNotifier {
  final String apiUrl = "https://transitstation.online/api/user/colors";
  ColorsResponses? _colorsResponse;
  ColorsResponses? get colorsResponse => _colorsResponse;

  Future<void> getColorsUsers(BuildContext context) async {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      _colorsResponse = ColorsResponses.fromJson(responseData);
      notifyListeners();
    } else {
      // Handle error
      throw Exception("Failed to load colors");
    }
  }
}
