import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/views/Driver/models/get_request_data.dart';
import 'package:http/http.dart' as http;

class GetRequestDriverProvider with ChangeNotifier {
  RequestModel? _requestModel;
  RequestModel? get requestModel => _requestModel;

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getRequestDriverProviderdata(BuildContext context) async {
    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      final response = await http.get(
        Uri.parse('https://transitstation.online/api/driver/home'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Assuming the structure has a "requests" key that contains the data
        if (responseData.containsKey('requests')) {
          _requestModel = RequestModel.fromJson(responseData);
          notifyListeners();
        } else {
          log('Error: "requests" key not found in the response');
        }
      } else {
        log('status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in fetching dashboard data: $e');
    }
  }
}
