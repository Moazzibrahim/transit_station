// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // Add this import for HTTP requests
import 'dart:convert'; // Import for encoding/decoding JSON data
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/controllers/get_dropdown_subscriptions.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/views/admin/screens/users_admin_screen.dart';
import '../../../constants/colors.dart';
import '../../../constants/widgets.dart';

class AddUsersAdminScreen extends StatefulWidget {
  const AddUsersAdminScreen({super.key});

  @override
  State<AddUsersAdminScreen> createState() => _AddUsersAdminScreenState();
}

class _AddUsersAdminScreenState extends State<AddUsersAdminScreen> {
  String? selectedOffer;
  String? selectedUser;
  TextEditingController selectedAmount = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    // Fetch dropdown data for offers and users
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetDropdowndataSubscriptionProvider>(context, listen: false)
          .getDropdownSubscription(context);
    });
  }

  // Function to submit the form data to the API
  Future<void> submitForm() async {
    if (firstNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedOffer == null ||
        selectedStartDate == null ||
        selectedEndDate == null ||
        selectedAmount.text.isEmpty) {
      // Check if amount is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Get the token from the TokenModel provider
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token; // Retrieve the token

    const apiUrl = 'https://transitstation.online/api/admin/users/add';

    try {
      final Map<String, dynamic> formData = {
        'name': firstNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'offer_id': selectedOffer,
        'amount': selectedAmount.text, // Include the amount
        'start_date':
            "${selectedStartDate!.year}-${selectedStartDate!.month}-${selectedStartDate!.day}",
        'end_date':
            "${selectedEndDate!.year}-${selectedEndDate!.month}-${selectedEndDate!.day}",
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(formData),
      );

      if (response.statusCode == 200) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully')),
        );
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => const UsersAdminScreen(),
        ));
      } else {
        print(response.body);
        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add user: ')),
        );
      }
    } catch (error) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add User'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: inputDecoration('First Name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: inputDecoration('Email'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: phoneController,
                decoration: inputDecoration('Phone Number'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: defaultColor),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: defaultColor),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Dropdown for selecting offer
              Consumer<GetDropdowndataSubscriptionProvider>(
                builder: (context, getDropdowndataProvider, child) {
                  final offers =
                      getDropdowndataProvider.offersUsersResponse?.offers ?? [];
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Offer',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: defaultColor),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: defaultColor),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                    value: selectedOffer,
                    items: offers.map((offer) {
                      return DropdownMenuItem<String>(
                        value: offer.id.toString(),
                        child: Text(offer.offerName),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedOffer = newValue;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16.0),

              // Amount field
              TextField(
                controller: selectedAmount,
                decoration: inputDecoration('Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: defaultColor),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: defaultColor),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                controller: TextEditingController(
                  text: selectedStartDate == null
                      ? ''
                      : "${selectedStartDate!.year}-${selectedStartDate!.month}-${selectedStartDate!.day}",
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
                      selectedStartDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),

              // End date field
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: defaultColor),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: defaultColor),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                controller: TextEditingController(
                  text: selectedEndDate == null
                      ? ''
                      : "${selectedEndDate!.year}-${selectedEndDate!.month}-${selectedEndDate!.day}",
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
                      selectedEndDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),

              // Submit button
              Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: ElevatedButton(
                  onPressed: submitForm, // Call the submit form function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
