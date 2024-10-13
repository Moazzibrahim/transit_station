import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';

class PickupContainer extends StatelessWidget {
  const PickupContainer({super.key, required this.image, required this.title, required this.subtitle});
  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: yellowColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.memory(base64Decode(image.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '')), height: 96, width: 84,),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                const SizedBox(height: 10,),
                Text(subtitle),
              ],
            ),
          )
        ],
      ),
    );
  }
}