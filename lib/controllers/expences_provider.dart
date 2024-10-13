import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/expences_model.dart';
import 'package:http/http.dart' as http;

class ExpencesProvider with ChangeNotifier {
  List<Expence> _expenceData = [];
  List<Expence> _filteredexpenses = [];

  List<Expence> get expenceData =>
      _filteredexpenses.isEmpty ? _expenceData : _filteredexpenses;

  double get totalExpenses {
    double totalAmount = 0.0;
    for (var expence
        in _filteredexpenses.isEmpty ? _expenceData : _filteredexpenses) {
      totalAmount += expence.amount;
    }
    return totalAmount;
  }

  bool isTypeAdded = false;
  bool isExpenceAdded = false;

  List<ExpenceType> _expenceTypesData = [];
  List<ExpenceType> get expenceTypesData => _expenceTypesData;

  void filterExpencesByDate(String filter) {
    DateTime now = DateTime.now();
    _filteredexpenses =
        List.from(_expenceData); // Initialize from the original data

    if (filter == 'Yearly') {
      _filteredexpenses = _filteredexpenses.where((expence) {
        DateTime expenceDate = DateTime.parse(expence.date);
        return expenceDate.year == now.year; // Match current year (e.g., 2024)
      }).toList();
    } else if (filter == 'Monthly') {
      _filteredexpenses = _filteredexpenses.where((expence) {
        DateTime expenceDate = DateTime.parse(expence.date);
        return expenceDate.year == now.year &&
            expenceDate.month == now.month; // Current month
      }).toList();
    } else if (filter == 'Weekly') {
      _filteredexpenses = _filteredexpenses.where((expence) {
        DateTime expenceDate = DateTime.parse(expence.date);
        final currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
        final currentWeekEnd = currentWeekStart.add(const Duration(days: 7));
        return expenceDate.isAfter(currentWeekStart) &&
            expenceDate.isBefore(currentWeekEnd);
      }).toList();
    } else {
      _filteredexpenses = List.from(_expenceData); // Show all data for 'All'
    }

    notifyListeners(); // Notify after filtering is complete
  }

  Future<void> addTypeExpence(BuildContext context, String name) async {
    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      final response = await http.post(
          Uri.parse('https://transitstation.online/api/admin/expence/addtype'),
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

  Future<void> fetchExpences(BuildContext context) async {
    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      final response = await http.get(
        Uri.parse('https://transitstation.online/api/admin/expence'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        final Expences expences = Expences.fromJson(responseData);
        _expenceData = expences.expences
            .map(
              (e) => Expence.fromJson(e),
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

  Future<void> addExpence(
      BuildContext context, DateTime date, int typeId, double amount) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;

      final response = await http.post(
        Uri.parse('https://transitstation.online/api/admin/expence/add'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'date': formattedDate,
          'type_expence_id': typeId,
          'expence_amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        isExpenceAdded = true;
        notifyListeners();
      } else {
        log('status code: ${response.statusCode}');
        isExpenceAdded = false;
        notifyListeners();
      }
    } catch (e) {
      log('add type expence: $e');
      isExpenceAdded = false;
      notifyListeners();
    }
  }

  Future<void> fetchExpenceTypes(BuildContext context) async {
    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      final response = await http.get(
        Uri.parse('https://transitstation.online/api/admin/expence/types'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        final ExpenceTypes expenceTypes = ExpenceTypes.fromJson(responseData);
        _expenceTypesData = expenceTypes.expenceTypes
            .map(
              (e) => ExpenceType.fromJson(e),
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

  double getTotalAmount() {
    double totalAmount = 0.0;
    for (var expence
        in _filteredexpenses.isEmpty ? _expenceData : _filteredexpenses) {
      totalAmount += expence.amount;
    }
    return totalAmount;
  }
}
