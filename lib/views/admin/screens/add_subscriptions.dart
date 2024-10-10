import 'package:flutter/material.dart';
// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http; // Import http package
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/controllers/get_dropdown_subscriptions.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/models/get_dropdown_subscriptions_model.dart';
import '../../../constants/colors.dart';

class AddSubscriptions extends StatefulWidget {
  const AddSubscriptions({super.key});

  @override
  State<AddSubscriptions> createState() => _RequestFormState();
}

class _RequestFormState extends State<AddSubscriptions> {
  String? selectedOfferId;
  String? selectedUser;
  TextEditingController selectedAmount = TextEditingController();
  DateTime? selectedDate;
  DateTime? selectedEndDate;
  Offer? selectedOffer; // Store the selected offer object

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetDropdowndataSubscriptionProvider>(context, listen: false)
          .getDropdownSubscription(context);
    });
  }

  Future<void> makePostRequest(BuildContext context) async {
    if (selectedOfferId == null ||
        selectedUser == null ||
        selectedDate == null ||
        selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    // Format the selected date and end date
    String formattedDate =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    String formattedEndDate =
        "${selectedEndDate!.year}-${selectedEndDate!.month.toString().padLeft(2, '0')}-${selectedEndDate!.day.toString().padLeft(2, '0')}";

    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;

    try {
      var response = await http.post(
        Uri.parse('https://transitstation.online/api/admin/subscription/add'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': selectedUser,
          'offer_id': selectedOfferId,
          'start_date': formattedDate,
          'end_date': formattedEndDate,
          'amount':
              selectedOffer!.price, // Send the price from the selected offer
        }),
      );

      if (response.statusCode == 200) {
        log('Request successful: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request successful!')),
        );
      } else {
        log('Request failed with status: ${response.statusCode}');
        log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}')),
        );
      }
    } catch (error) {
      log('Error making request: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Add Subscription"),
      body: Consumer<GetDropdowndataSubscriptionProvider>(
        builder: (context, getDropdowndataProvider, child) {
          final offers =
              getDropdowndataProvider.offersUsersResponse?.offers ?? [];
          final users =
              getDropdowndataProvider.offersUsersResponse?.users ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select offer ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: selectedOfferId,
                  items: offers.map((offer) {
                    return DropdownMenuItem<String>(
                      value: offer.id.toString(),
                      child: Text(offer.offerName),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedOfferId = newValue;
                      selectedOffer = offers.firstWhere(
                          (offer) => offer.id.toString() == newValue);
                      selectedAmount.text = selectedOffer!.price
                          .toString(); // Set the amount to the selected offer's price
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select user',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: selectedUser,
                  items: users.map((user) {
                    return DropdownMenuItem<String>(
                      value: user.id.toString(),
                      child: Text(user.name),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedUser = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Start date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
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
                const SizedBox(height: 16.0),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'End date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  controller: TextEditingController(
                    text: selectedEndDate == null
                        ? ''
                        : "${selectedEndDate!.year}-${selectedEndDate!.month}-${selectedEndDate!.day}",
                  ),
                  onTap: () async {
                    DateTime? pickedEndDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedEndDate != null) {
                      setState(() {
                        selectedEndDate = pickedEndDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: selectedAmount,
                  readOnly: true, // Make the amount field read-only
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    makePostRequest(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                    backgroundColor: defaultColor,
                  ),
                  child:
                      const Text('Done', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
