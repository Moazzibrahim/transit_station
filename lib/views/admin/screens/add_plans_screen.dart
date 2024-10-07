import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';
import '../../../controllers/plans_admin_provider.dart'; // Import your PlanService

class AddPlansScreen extends StatefulWidget {
  const AddPlansScreen({super.key});

  @override
  _AddPlansScreenState createState() => _AddPlansScreenState();
}

class _AddPlansScreenState extends State<AddPlansScreen> {
  final TextEditingController planNameController = TextEditingController();
  final TextEditingController planPriceController = TextEditingController();
  final TextEditingController priceDiscountController = TextEditingController();
  final TextEditingController planDurationController = TextEditingController();

  @override
  void dispose() {
    planNameController.dispose();
    planPriceController.dispose();
    priceDiscountController.dispose();
    planDurationController.dispose();
    super.dispose();
  }

  Future<void> _addPlan(BuildContext context) async {
    final String offerName = planNameController.text.trim();
    final double price =
        double.tryParse(planPriceController.text.trim()) ?? 0.0;
    final double priceDiscount =
        double.tryParse(priceDiscountController.text.trim()) ?? 0.0;
    final int duration = int.tryParse(planDurationController.text.trim()) ?? 0;

    final planService = PlanService();

    try {
      await planService.addPlan(
        context,
        price: price,
        priceDiscount: priceDiscount,
        offerName: offerName,
        duration: duration,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Plan added successfully!')),
      );

      planNameController.clear();
      planPriceController.clear();
      priceDiscountController.clear();
      planDurationController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add plan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add Plans'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: planNameController,
                  decoration: inputDecoration('Plan Name'),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: planPriceController,
                  decoration: inputDecoration('Plan Price'),
                  keyboardType: TextInputType.number, // Ensure it's a number
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: priceDiscountController,
                  decoration: inputDecoration('Price after discount'),
                  keyboardType: TextInputType.number, // Ensure it's a number
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: planDurationController,
                  decoration: inputDecoration('Plan Duration'),
                  keyboardType: TextInputType.number, // Ensure it's a number
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () =>
                  _addPlan(context), // Call _addPlan on button press
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: defaultColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
