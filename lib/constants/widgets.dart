import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';


InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(
        color: defaultColor, // Border color similar to the image
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(
        color: defaultColor, // Same color as enabled but can be changed if needed
        width: 1.5,
      ),
    ),
  );
}
