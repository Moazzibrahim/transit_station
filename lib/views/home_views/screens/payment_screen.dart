// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod = 'Visa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Payment'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Payment Method',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            RadioListTile<String>(
              value: 'Visa',
              activeColor: defaultColor,
              groupValue: _selectedPaymentMethod,
              title: Row(
                children: [
                  Image.asset('assets/images/Visa._logo.png',
                      height: 24), // Add your Visa logo here
                  const SizedBox(width: 8),
                  const Text('Visa'),
                ],
              ),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              value: 'Binance',
              groupValue: _selectedPaymentMethod,
              activeColor: defaultColor,
              title: Row(
                children: [
                  Image.asset('assets/images/binance.png',
                      height: 24), // Add your Binance logo here
                  const SizedBox(width: 8),
                  const Text('Binance'),
                ],
              ),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              value: 'Fawry',
              groupValue: _selectedPaymentMethod,
              activeColor: defaultColor,
              title: Row(
                children: [
                  Image.asset('assets/images/fawry.png',
                      height: 24), // Add your Fawry logo here
                  const SizedBox(width: 8),
                  const Text('Fawry'),
                ],
              ),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              value: 'Vodafone Cash',
              groupValue: _selectedPaymentMethod,
              activeColor: defaultColor,
              title: Row(
                children: [
                  Image.asset('assets/images/vodafone.png',
                      height: 24), // Add your Vodafone logo here
                  const SizedBox(width: 8),
                  const Text('Vodafone Cash'),
                ],
              ),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 100,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
