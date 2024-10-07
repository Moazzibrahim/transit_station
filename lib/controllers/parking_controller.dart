import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:http/http.dart' as http;
import 'package:transit_station/models/parking_model.dart';

class ParkingController with ChangeNotifier {

  List<Parking> _parkingData= [];
  List<Parking> get parkingData=> _parkingData;

  Future<void> fetchParking(BuildContext context) async{
    try {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;
    final response = await http.get(Uri.parse('https://transitstation.online/api/admin/parking'),
    headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    },
    );
    if(response.statusCode == 200){
      final Map<String,dynamic> responseData = jsonDecode(response.body);
      Parkings parkings = Parkings.fromJson(responseData);
      _parkingData = parkings.parkings.map((e) => Parking.fromJson(e),).toList();
      notifyListeners();
    }else {
      log('status code: ${response.statusCode}');
    }
    } catch (e) {
      log('error in fetch dashboard data: $e');
    }
  }
}