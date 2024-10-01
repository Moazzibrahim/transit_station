import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';

import '../../../constants/colors.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'NewPassword'),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'New password',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  'Create a new password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: defaultColor),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: defaultColor),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm password',
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: defaultColor),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: defaultColor),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 140,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Verify Code',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
