import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:http/http.dart' as http;
import 'package:transit_station/models/dashborad_model.dart';

class DashboardController with ChangeNotifier {
  DashboradModel? _dashboradModel;
  DashboradModel? get dashboardData => _dashboradModel;

  Future<void> fetchDashboardData(BuildContext context) async{
    try {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final response = await http.get(Uri.parse('https://transitstation.online/api/admin/home'),
    headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    },
    );
    if(response.statusCode == 200){
        final List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty && responseData[0] is Map<String, dynamic>) {
          final Map<String, dynamic> dashboardData = responseData[0];
          _dashboradModel = DashboradModel.fromJson(dashboardData);
          notifyListeners();
        } else {
          log('Error: Unexpected response structure');
        }
    }
    } catch (e) {
      log('error in fetch dashboard data: $e');
    }
  }
}
