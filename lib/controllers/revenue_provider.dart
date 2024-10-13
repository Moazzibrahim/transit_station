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
  List<Revenue> _filteredRevenues = [];
  List<Revenue> get revenueData =>
      _filteredRevenues.isEmpty ? _revenuesData : _filteredRevenues;

  bool isTypeAdded = false;
  bool isRevenueAdded = false;

  List<RevenueType> _revenueTypesData = [];
  List<RevenueType> get revenueTypesData => _revenueTypesData;

  double _totalAmount = 0;
  double get totalAmount => _totalAmount;

  Future<void> addTypeRevenue(BuildContext context, String name) async {
    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      final response = await http.post(
          Uri.parse('https://transitstation.online/api/admin/revenue/addtype'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'type_name': name,
          }));
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

  Future<void> fetchRevenues(BuildContext context) async {
    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      final response = await http.get(
        Uri.parse('https://transitstation.online/api/admin/revenue'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        final Revenues revenues = Revenues.fromJson(responseData);
        _revenuesData = revenues.revenues
            .map(
              (e) => Revenue.fromJson(e),
            )
            .toList();
        notifyListeners();
      } else {
        log('error with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('error in fetch dashboard data: $e');
    }
  }

  Future<void> addRevenue(BuildContext context, DateTime date, int typeId, double amount) async {
    try {
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
          'date': formattedDate,
          'type_revenue_id': typeId,
          'revenue_amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        isRevenueAdded = true;
        notifyListeners();
      } else {
        log('status code: ${response.statusCode}');
        isRevenueAdded = false;
        notifyListeners();
      }
    } catch (e) {
      log('add type revenue: $e');
      isRevenueAdded = false;
      notifyListeners();
    }
  }

  Future<void> fetchRevenueTypes(BuildContext context) async {
    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      final response = await http.get(
        Uri.parse('https://transitstation.online/api/admin/revenue/types'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        final RevenueTypes revenueTypes = RevenueTypes.fromJson(responseData);
        _revenueTypesData = revenueTypes.revenueTypes
            .map(
              (e) => RevenueType.fromJson(e),
            )
            .toList();
        notifyListeners();
      } else {
        log('error with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('error in fetch types data: $e');
    }
  }

  void filterRevenuesByDate(String filter) {
    DateTime now = DateTime.now();
    _totalAmount = 0;

    if (filter == 'Yearly') {
      _filteredRevenues = _revenuesData.where((revenue) {
        DateTime revenueDate = DateTime.parse(revenue.date);
        return revenueDate.year == now.year;
      }).toList();
    } else if (filter == 'Monthly') {
      _filteredRevenues = _revenuesData.where((revenue) {
        DateTime revenueDate = DateTime.parse(revenue.date);
        return revenueDate.year == now.year && revenueDate.month == now.month;
      }).toList();
    } else if (filter == 'Weekly') {
      _filteredRevenues = _revenuesData.where((revenue) {
        DateTime revenueDate = DateTime.parse(revenue.date);
        final currentWeekStart = now.subtract(Duration(days: now.weekday));
        final currentWeekEnd = currentWeekStart.add(const Duration(days: 7));
        return revenueDate.isAfter(currentWeekStart) && revenueDate.isBefore(currentWeekEnd);
      }).toList();
    } else {
      _filteredRevenues = _revenuesData; // Show all data for 'All'
    }

    _totalAmount = _filteredRevenues.fold(0, (sum, revenue) => sum + revenue.amount);
    notifyListeners();
  }
}
