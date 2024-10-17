// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/get_dropdowndata_provider.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/controllers/notifications_services.dart';
import 'package:transit_station/views/Driver/screens/status_screen.dart';
import 'package:transit_station/views/subscription/views/Subscription_plan_screens.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  String? selectedCar;
  String? selectedLocation;
  DateTime? selectedDate;
  DateTime? selectedReturnDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetDropdowndataProvider>(context, listen: false)
          .getdropdown(context);
      Provider.of<NotificationsServices>(context, listen: false)
          .getAccessToken();
    });
  }

  Future<void> makePostRequest(BuildContext context) async {
    if (selectedCar == null ||
        selectedLocation == null ||
        selectedDate == null ||
        selectedReturnDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    String formattedDate =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    String formattedReturnDate =
        "${selectedReturnDate!.year}-${selectedReturnDate!.month.toString().padLeft(2, '0')}-${selectedReturnDate!.day.toString().padLeft(2, '0')}";
    String formattedTime =
        "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final token = tokenProvider.token;

    try {
      var response = await http.post(
        Uri.parse('https://transitstation.online/api/user/make-request'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'car_id': selectedCar,
          'location_id': selectedLocation,
          'pick_up_date': formattedDate,
          'request_time': formattedTime,
          'return_time': formattedReturnDate
        }),
      );

      if (response.statusCode == 200) {
        // Success - Handle the response
        log('Request successful: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: defaultColor,
              content: Text('Request successful!')),
        );
        final notificationService =
            Provider.of<NotificationsServices>(context, listen: false);
        notificationService.sendNotification('Request Submitted',
            'Your request has been successfully submitted!');
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StatusScreen()));
          },
        );
      } else if (response.statusCode == 403) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['message'] == 'Please subscribe first') {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 28),
                    SizedBox(width: 10),
                    Text('Subscription Required'),
                  ],
                ),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'You need to subscribe to proceed. Would you like to view subscription plans?',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Close the dialog
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: defaultColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Subscribe',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SubscriptionPlanScreens()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          log('Request failed with status: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Request failed: ${responseBody['message']}')),
          );
        }
      } else {
        log('Request failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed: ${response.body}')),
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
      appBar: buildAppBar(context, "Request screen"),
      body: Consumer<GetDropdowndataProvider>(
        builder: (context, getDropdowndataProvider, child) {
          final cars = getDropdowndataProvider.mainData?.cars ?? [];
          final locations = getDropdowndataProvider.mainData?.locations ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select car type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: selectedCar,
                  items: cars.map((car) {
                    return DropdownMenuItem<String>(
                      value: car.id.toString(),
                      child: Text(car.carName),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCar = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select pick-up Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: selectedLocation,
                  items: locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location.id.toString(),
                      child: Text(location.address),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedLocation = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Pick up date',
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
                      firstDate: DateTime.now(),
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
                    labelText: 'Pick up time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  controller: TextEditingController(
                    text: selectedTime == null
                        ? ''
                        : "${selectedTime!.hour}:${selectedTime!.minute}",
                  ),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Pick up  return date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  controller: TextEditingController(
                    text: selectedReturnDate == null
                        ? ''
                        : "${selectedReturnDate!.year}-${selectedReturnDate!.month}-${selectedReturnDate!.day}",
                  ),
                  onTap: () async {
                    DateTime? pickedReturnDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedReturnDate != null) {
                      setState(() {
                        selectedReturnDate = pickedReturnDate;
                      });
                    }
                  },
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
