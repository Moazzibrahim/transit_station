import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/admin/widgets/linear_notification.dart';


InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 20.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(
        color: defaultColor,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(
        color: defaultColor,
        width: 1.5,
      ),
    ),
  );
}

void showTopSnackBar(BuildContext context, String message, IconData icon,
    Color color, Duration duration) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50.0, 
      left: 10.0,
      right: 10.0,
      child: Material(
        color: Colors.transparent,
        child: NotificationWithProgressBar(
          message: message,
          icon: icon,
          color: color,
          duration: duration,
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}
