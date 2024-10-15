// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/request_admin_model.dart';

Future<List<Request>> fetchRequests(BuildContext context) async {
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
    return jsonResponse.map((json) => Request.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load car requests: ${response.reasonPhrase}');
  }
}

Future<void> updateStatus(BuildContext context,int id) async{
  final tokenProvider = Provider.of<TokenModel>(context, listen: false);
  final String? token = tokenProvider.token;

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final response = await http.put(Uri.parse('https://transitstation.online/api/admin/request/changetohistory/$id'),
  headers: headers,
  );

  if(response.statusCode == 200){
    showTopSnackBar(context,'Status updated',Icons.check_circle_outline, defaultColor, const Duration(seconds: 4));
  }else{
    showTopSnackBar(context,'something went wrong',Icons.warning_outlined, Colors.red, const Duration(seconds: 4));
  }
}
