import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/login_provider.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final List<String> statusSequence = [
    'pending request',
    'on the way',
    'car received',
    'arrived'
  ];

  String currentStatus = 'pending request';

  Future<void> getDriverStatus() async {
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;

    final url = Uri.parse(
        'https://transitstation.online/api/user/request/getdriverstatus');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          currentStatus = data['driver_status'];
        });
      } else {
        print(
            'Failed to load driver status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  bool isStatusCompleted(String status) {
    final currentIndex = statusSequence.indexOf(currentStatus);
    final statusIndex = statusSequence.indexOf(status);
    return statusIndex <= currentIndex;
  }

  @override
  void initState() {
    super.initState();
    getDriverStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Status'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatusItem(
              icon: Icons.pin_drop_outlined,
              title: 'Pending Request',
              time: '',
              isActive: true,
              isCompleted: isStatusCompleted('pending request'),
            ),
            _buildDashedLine(),
            _buildStatusItem(
              icon: Icons.directions_car,
              title: 'Driver On The Way',
              time: '',
              isActive: currentStatus == 'on the way',
              isCompleted: isStatusCompleted('on the way'),
            ),
            _buildDashedLine(),
            _buildStatusItem(
              icon: Icons.directions_car,
              title: 'Car Taken',
              time: '',
              isActive: currentStatus == 'car received',
              isCompleted: isStatusCompleted('car received'),
            ),
            _buildDashedLine(),
            _buildStatusItem(
              icon: Icons.check_circle,
              title: 'Car In The Parking',
              time: '',
              isActive: currentStatus == 'arrived',
              isCompleted: isStatusCompleted('arrived'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String time,
    required bool isActive,
    required bool isCompleted,
  }) {
    final itemColor = isCompleted
        ? defaultColor
        : isActive
            ? defaultColor
            : Colors.grey;

    return Row(
      children: [
        Icon(
          icon,
          color: itemColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: itemColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (time.isNotEmpty)
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
        if (isCompleted)
          Icon(
            Icons.verified,
            color: itemColor,
          ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: DottedLine(),
          ),
        ],
      ),
    );
  }
}

class DottedLine extends StatelessWidget {
  const DottedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }
}
