import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';

class StatContainer extends StatelessWidget {
  const StatContainer({super.key, required this.title, required this.statNum});
  final String title;
  final int statNum;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: defaultColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            statNum.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}