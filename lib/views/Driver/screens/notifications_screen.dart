import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Notifications"),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          NotificationTile(
            message: 'Your Car Has Been Received',
            time: '02:00',
            isHighlighted: true,
          ),
          NotificationTile(
            message: 'The Monthly Subscription Will End Tomorrow',
            time: '01:00',
          ),
          NotificationTile(
            message: 'Payment Completed Successfully',
            time: 'Yesterday',
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String message;
  final String time;
  final bool isHighlighted;

  const NotificationTile({
    super.key,
    required this.message,
    required this.time,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.yellow : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isHighlighted ? Colors.yellow : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.black : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            time,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
