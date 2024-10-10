// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/expences_provider.dart';

class AddTypeExpenceScreen extends StatefulWidget {
  const AddTypeExpenceScreen({super.key});

  @override
  State<AddTypeExpenceScreen> createState() => _AddTypeExpenceScreenState();
}

class _AddTypeExpenceScreenState extends State<AddTypeExpenceScreen> {
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add Type'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: inputDecoration('name'),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                final expenceProvider =
                    Provider.of<ExpencesProvider>(context, listen: false);
                await expenceProvider.addTypeExpence(
                    context, _nameController.text);
                if (expenceProvider.isTypeAdded) {
                  showTopSnackBar(
                      context,
                      'Type Added',
                      Icons.check_circle_outline,
                      defaultColor,
                      const Duration(seconds: 4));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  )),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Done',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}