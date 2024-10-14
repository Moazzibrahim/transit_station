import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

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
              isCompleted: true,
            ),
            _buildDashedLine(),
            _buildStatusItem(
              icon: Icons.directions_car,
              title: 'Driver On The Way',
              time: '7 Minutes',
              isActive: false,
              isCompleted: false,
            ),
            _buildDashedLine(),
            _buildStatusItem(
              icon: Icons.directions_car,
              title: 'Car Taken',
              time: '10 Minutes',
              isActive: false,
              isCompleted: false,
            ),
            _buildDashedLine(),
            _buildStatusItem(
              icon: Icons.check_circle,
              title: 'Car In The Parking',
              time: '13 Minutes',
              isActive: false,
              isCompleted: false, // Completed item example
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
    return Row(
      children: [
        // Main status icon on the left
        Icon(
          icon,
          color: isCompleted
              ? defaultColor
              : isActive
                  ? defaultColor
                  : Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: isActive ? defaultColor : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
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
          const Icon(
            Icons.verified,
            color: defaultColor,
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
