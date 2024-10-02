import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: defaultColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            indicatorColor:
                defaultColor, // Color for the selected tab indicator
            labelColor: defaultColor, // Color for the selected tab label
            unselectedLabelColor:
                Colors.grey, // Color for unselected tab labels
            indicator: BoxDecoration(
              color: defaultColor,
              borderRadius: BorderRadius.circular(8),
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/visa.png'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/money.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First tab content (VISA)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Payment Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  _buildTextField('Card Number'),
                  const SizedBox(height: 10.0),
                  _buildTextField('Card Holder'),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Expiry Date')),
                      const SizedBox(width: 10.0),
                      Expanded(child: _buildTextField('Security Code')),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add payment submission functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: defaultColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Second tab content (QR Code)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_2, size: 100, color: defaultColor),
                  SizedBox(height: 20),
                  Text(
                    'Scan QR Code to Pay',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(decoration: inputDecoration(hint));
  }
}
