import 'dart:developer';
import 'dart:convert'; // Import for jsonEncode
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http; // Import http package
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/widgets.dart';
import '../../../constants/colors.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  File? _image; // To store the picked image
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        log('No image selected');
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<void> _postCarDetails() async {
    // API URL
    const String url = 'https://transitstation.online/api/user/car/add';

    // Create a request
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['car_name'] = _carNameController.text;
    request.fields['car_number'] = _carNumberController.text;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'car_image',
        _image!.path,
      ));
    }

    try {
      // Send the request and wait for a response
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        log('Success: $responseString');
      } else {
        log('Failed to post data: ${response.statusCode}');
        // Handle failure (e.g., show an error message)
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
                      fontSize: 24,
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
                    decoration: inputDecoration('Car Number'),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Upload button
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickImage,
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
                                  color: Colors.blueAccent,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
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
              onPressed: _postCarDetails, // Call the post function
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 140),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
