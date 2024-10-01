import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/widgets.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  File? _image; // To store the picked image

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Store the image in _image
        });
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add car'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'Write your car details to identify it',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Color.fromRGBO(94, 94, 94, 1),
                  ),
                ),
              ],
            ),
            TextField(
              decoration: inputDecoration('Car name'),
            ),
            TextField(
              decoration: inputDecoration('Car number'),
            ),
            const SizedBox(height: 20),

            // Button to pick an image from gallery
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Upload Car Image'),
            ),

            const SizedBox(height: 20),

            // Display the picked image (if any)
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : const Text('No image selected'),
          ],
        ),
      ),
    );
  }
}
