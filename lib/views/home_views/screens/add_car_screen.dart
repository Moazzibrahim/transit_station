// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/image_services.dart';
import 'package:transit_station/controllers/login_provider.dart';
import 'package:transit_station/views/home_views/screens/home_screen.dart';
import '../../../constants/colors.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();
  String? base64Image;
  File? _image;

  Color? pickedColor;
  List<Color> pickedColors = [];

  void pickColor(BuildContext context) {
    Color selectedColor = Colors.white;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                setState(() {
                  pickedColor = selectedColor;
                  pickedColors.add(selectedColor);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Convert color to hex
  String colorToHex(Color color) {
    log('$pickedColor');
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Future<void> _postCarDetails() async {
    if (_carNameController.text.isEmpty ||
        _carNumberController.text.isEmpty ||
        pickedColor == null || // Add color validation
        _image == null) {
      showTopSnackBar(context, 'You must fill all the fields', Icons.error,
          Colors.red, const Duration(seconds: 4));

      return; // Exit the function if validation fails
    }

    base64Image = Provider.of<ImageServices>(context, listen: false)
        .convertImageToBase64(_image!);

    // API URL
    const String url = 'https://transitstation.online/api/user/car/add';

    // Create request body
    Map<String, dynamic> body = {
      'car_name': _carNameController.text,
      'car_number': int.parse(_carNumberController.text),
      'car_color': colorToHex(pickedColor!), // Convert color to hex string
      if (base64Image != null) 'car_image': base64Image
    };

    try {
      final tokenProvider = Provider.of<TokenModel>(context, listen: false);
      final token = tokenProvider.token;
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      log(body.toString());
      if (response.statusCode == 200) {
        if (!mounted) {
          return; // Ensure the widget is still mounted before navigation
        }
        log('$pickedColor');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: defaultColor,
              content: Text('Request successful!')),
        );
        Future.delayed(
          const Duration(seconds: 1),
          () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        );
      } else {
        log(response.body);
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error posting data: $e');
      // Handle exception (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add Car'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Write your car details to identify it',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color.fromRGBO(94, 94, 94, 1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _carNameController,
                    decoration: inputDecoration('Car Name'),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _carNumberController,
                    keyboardType:
                        TextInputType.number, // Restrict input to numbers
                    decoration: inputDecoration('Car Number'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      pickedColor != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: CircleAvatar(
                                backgroundColor: pickedColor,
                                radius: 20,
                              ),
                            )
                          : const SizedBox(),
                      GestureDetector(
                        onTap: () => pickColor(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 20,
                          child: const Icon(Icons.add, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Upload button
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Provider.of<ImageServices>(context,
                                    listen: false)
                                .pickImage();
                            setState(() {
                              _image = Provider.of<ImageServices>(context,
                                      listen: false)
                                  .image;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  color: defaultColor,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'No image selected',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _postCarDetails();
              }, // Call the post function
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text('Add Car',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
