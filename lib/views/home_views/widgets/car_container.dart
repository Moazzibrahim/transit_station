import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';

class CarContainer extends StatelessWidget {
  const CarContainer({super.key, required this.name, required this.image});
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      width: 128,
      height: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: yellowColor,
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 99,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(image),
            ),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10,),
              Text(name,style: const TextStyle(color: defaultColor),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}