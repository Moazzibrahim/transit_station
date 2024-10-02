import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/dropdown_model.dart';
class GetDropdowndataProvider with ChangeNotifier {
  MainData? _mainData;

  MainData? get mainData => _mainData;

  Future<void> getdropdown(BuildContext context) async {
    const url = 'https://transitstation.online/api/user/dropdown';
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      try {
        log("dropdowndata: ${response.body}");
        final responsebody = json.decode(response.body);
        _mainData = MainData.fromJson(responsebody);  // Store the MainData object
        notifyListeners();  // Notify listeners after the data is stored
      } catch (e) {
        log('Error parsing dropdown data: $e');
      }
    } else {
      log('Error in getting dropdown data: ${response.statusCode}');
    }
  }
}
