import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/revenue_model.dart';

class RevenueProvider with ChangeNotifier {

  List<Revenue> _revenuesData = [];
  List<Revenue> get revenueData=> _revenuesData;

  bool isTypeAdded = false;

  Future<void> addTypeRevenue(BuildContext context,String name) async{
    try {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final response = await http.post(Uri.parse('https://transitstation.online/api/admin/revenue/addtype'),
    headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'type_name' : name,
    })
    );
    if(response.statusCode == 200){
      isTypeAdded = true;
      notifyListeners();
    }else {
      log('status code: ${response.statusCode}');
      isTypeAdded = false;
      notifyListeners();
    }
    } catch (e) {
      log('add type revenue: $e');
      isTypeAdded = false;
      notifyListeners();
    }
  }

  Future<void> fetchRevenues(BuildContext context) async{
    try {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final response =await http.get(Uri.parse('https://transitstation.online/api/admin/revenue'),
    headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    },
    );
    if(response.statusCode ==200){
      Map<String,dynamic> responseData = jsonDecode(response.body);
      final Revenues revenues = Revenues.fromJson(responseData);
      _revenuesData = revenues.revenues.map((e) => Revenue.fromJson(e),).toList();
      notifyListeners();
    }else{
      log('error with status code: ${response.statusCode}');
    }
    } catch (e) {
      log('error in fetch dashboard data: $e');
    }
  }

  Future<void> addRevenue(BuildContext context, DateTime date, int typeId, double amount) async {
  try {
    // Format the date to 'yyyy-MM-dd' format
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;

    final response = await http.post(
      Uri.parse('https://transitstation.online/api/admin/revenue/add'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date': formattedDate, // Send the formatted date
        'type_revenue_id': typeId,
        'revenue_amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      isTypeAdded = true;
      notifyListeners();
    } else {
      log('status code: ${response.statusCode}');
      isTypeAdded = false;
      notifyListeners();
    }
  } catch (e) {
    log('add type revenue: $e');
    isTypeAdded = false;
    notifyListeners();
  }
}

}