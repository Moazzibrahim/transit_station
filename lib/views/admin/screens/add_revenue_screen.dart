// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/revenue_provider.dart';
import 'package:transit_station/models/revenue_model.dart';

class AddRevenueScreen extends StatefulWidget {
  const AddRevenueScreen({super.key});

  @override
  State<AddRevenueScreen> createState() => _AddRevenueScreenState();
}

class _AddRevenueScreenState extends State<AddRevenueScreen> {
  DateTime? selectedDate;
  RevenueType? _selectedRevenueType;
  final _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add revenue'),
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
                  Consumer<RevenueProvider>(
                    builder: (context, revenueProvider, child) {
                      // Fetch revenue types if not loaded yet
                      if (revenueProvider.revenueTypesData.isEmpty) {
                        revenueProvider.fetchRevenueTypes(context);
                      }

                      return DropdownButtonFormField<RevenueType>(
                        value: _selectedRevenueType,
                        decoration: inputDecoration('Select revenue type'),
                        items: revenueProvider.revenueTypesData
                            .map((RevenueType type) {
                          return DropdownMenuItem<RevenueType>(
                            value: type,
                            child: Text(type.name),
                          );
                        }).toList(),
                        onChanged: (RevenueType? newValue) {
                          setState(() {
                            _selectedRevenueType = newValue;
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
                      _selectedRevenueType == null ||
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
                    final revenueProvider =
                        Provider.of<RevenueProvider>(context, listen: false);
                    await revenueProvider.addRevenue(
                      context,
                      selectedDate!,
                      _selectedRevenueType!.id,
                      double.parse(_amountController.text),
                    );

                    if (revenueProvider.isRevenueAdded) {
                      showTopSnackBar(
                        context,
                        'Revenue added',
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
