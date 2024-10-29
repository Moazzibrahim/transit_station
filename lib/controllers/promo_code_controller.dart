// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/login_provider.dart';

class PromoCodeController with ChangeNotifier {
  int? priceafterdiscount;
  Future<void> submitPromoCode(
      String promocode, int offerId, BuildContext context) async {
    final url =
        Uri.parse('https://transitstation.online/api/user/promocode/submit');
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'promocode': promocode,
          'offer_id': offerId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];
        priceafterdiscount = responseData['price_after_discount'];

        // Display success message and discounted price
        showTopSnackBar(context, message, Icons.check, Colors.green,
            const Duration(seconds: 2));
      } else {
        // Display error message for other status codes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to submit promo code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while submitting the promo code.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
