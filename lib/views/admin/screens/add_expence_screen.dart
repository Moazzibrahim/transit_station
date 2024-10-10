// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/expences_provider.dart';
import 'package:transit_station/models/expences_model.dart';

class AddExpenceScreen extends StatefulWidget {
  const AddExpenceScreen({super.key});

  @override
  State<AddExpenceScreen> createState() => _AddExpenceScreenState();
}

class _AddExpenceScreenState extends State<AddExpenceScreen> {
  DateTime? selectedDate;
  ExpenceType? _selectedExpenceType;
  final _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add Expence'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    readOnly: true,
                    decoration: inputDecoration('pick a date'),
                    controller: TextEditingController(
                      text: selectedDate == null
                          ? ''
                          : "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<ExpencesProvider>(
                    builder: (context, expenceProvder, child) {
                      // Fetch revenue types if not loaded yet
                      if (expenceProvder.expenceTypesData.isEmpty) {
                        expenceProvder.fetchExpenceTypes(context);
                      }

                      return DropdownButtonFormField<ExpenceType>(
                        value: _selectedExpenceType,
                        decoration: inputDecoration('Select revenue type'),
                        items: expenceProvder.expenceTypesData
                            .map((ExpenceType type) {
                          return DropdownMenuItem<ExpenceType>(
                            value: type,
                            child: Text(type.name),
                          );
                        }).toList(),
                        onChanged: (ExpenceType? newValue) {
                          setState(() {
                            _selectedExpenceType = newValue;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _amountController,
                    decoration: inputDecoration('amount'),
                  )
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  // Check if all fields are filled
                  if (selectedDate == null ||
                      _selectedExpenceType == null ||
                      _amountController.text.isEmpty) {
                    // Show an error message if any field is missing
                    showTopSnackBar(
                      context,
                      'All fields are required',
                      Icons.warning,
                      Colors.red,
                      const Duration(seconds: 4),
                    );
                  } else {
                    final expenceProvder =
                        Provider.of<ExpencesProvider>(context, listen: false);
                    await expenceProvder.addExpence(
                      context,
                      selectedDate!,
                      _selectedExpenceType!.id,
                      double.parse(_amountController.text),
                    );

                    if (expenceProvder.isExpenceAdded) {
                      showTopSnackBar(
                        context,
                        'Expence added',
                        Icons.check_circle_outline,
                        defaultColor,
                        const Duration(seconds: 4),
                      );
                    } else {
                      showTopSnackBar(
                        context,
                        'Something went wrong',
                        Icons.warning,
                        Colors.red,
                        const Duration(seconds: 4),
                      );
                    }
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
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}