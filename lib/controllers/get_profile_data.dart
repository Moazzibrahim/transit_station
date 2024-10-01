import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/user_profile_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetProfileData with ChangeNotifier {
  UserProfileModel? _userProfileModel;
  UserProfileModel? get userProfileModel => _userProfileModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> getprofile(BuildContext context) async {
    const url = 'https://transitstation.online/api/user/profile';
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Check if the response contains a success key
        if (responseBody.containsKey('success')) {
          final userData = responseBody['success']; // Extract the 'success' object
          _userProfileModel = UserProfileModel.fromJson(userData);
          _error = null;
        } else {
          _error = "Unexpected response format.";
        }
      } else {
        _error = "Failed to load profile data (Error: ${response.statusCode})";
      }
    } catch (e) {
      _error = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
