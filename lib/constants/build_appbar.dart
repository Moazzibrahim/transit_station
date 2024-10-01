import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    ),
    leading: Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: defaultColor,
        ),
      ),
    ),
  );
}
