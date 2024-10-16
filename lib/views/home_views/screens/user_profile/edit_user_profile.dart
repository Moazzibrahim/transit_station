// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/get_profile_data.dart';
import 'package:transit_station/controllers/image_services.dart';
import 'package:transit_station/controllers/login_provider.dart'; // Token provider

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({super.key});

  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? originalName;
  String? originalEmail;
  String? originalPhone;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile(BuildContext context) async {
    final profileProvider = Provider.of<GetProfileData>(context, listen: false);
    final tokenProvider = Provider.of<TokenModel>(context, listen: false);
    final imageProvider = Provider.of<ImageServices>(context, listen: false);
    final token = tokenProvider.token;

    // Prepare only the data that has changed
    final Map<String, dynamic> updateData = {};

    if (_nameController.text != originalName &&
        _nameController.text.isNotEmpty) {
      updateData['name'] = _nameController.text;
    }
    if (_emailController.text != originalEmail &&
        _emailController.text.isNotEmpty) {
      updateData['email'] = _emailController.text;
    }
    if (_phoneController.text != originalPhone &&
        _phoneController.text.isNotEmpty) {
      updateData['phone'] = _phoneController.text;
    }
    if (imageProvider.image != null) {
      updateData['image'] =
          imageProvider.convertImageToBase64(imageProvider.image!);
    }

    if (updateData.isEmpty) {
      showTopSnackBar(context, 'No changes made', Icons.no_transfer,
          Colors.orange, const Duration(seconds: 2));
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('https://transitstation.online/api/user/profile/edit'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        // Successfully updated, refresh profile data
        profileProvider.getprofile(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: defaultColor,
          ),
        );
        log("done: ${response.body}");
      } else {
        // Handle error
        showTopSnackBar(context, 'Failed to update profile', Icons.error,
            Colors.red, const Duration(seconds: 2));
        log('response failed: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      showTopSnackBar(context, 'An error occurred', Icons.error, Colors.red,
          const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GetProfileData, ImageServices>(
      builder: (context, profileProvider, imageProvider, child) {
        if (profileProvider.userProfileModel == null &&
            !profileProvider.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            profileProvider.getprofile(context);
          });
        }
        // Pre-fill text fields with current profile data
        originalName = profileProvider.userProfileModel?.name ?? '';
        originalEmail = profileProvider.userProfileModel?.email ?? '';
        originalPhone = profileProvider.userProfileModel?.phone ?? '';

        _nameController.text = originalName!;
        _emailController.text = originalEmail!;
        _phoneController.text = originalPhone!;

        return Scaffold(
          appBar: buildAppBar(context, "Update profile"),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          profileProvider.userProfileModel?.image != null
                              ? MemoryImage(base64Decode(
                                  profileProvider.userProfileModel!.image!))
                              : const AssetImage('assets/images/boy.png')
                                  as ImageProvider, // Default image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: defaultColor,
                        ),
                        onPressed: () {
                          imageProvider.pickImage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: defaultColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: defaultColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Name",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: defaultColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: defaultColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: defaultColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: defaultColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Phone",
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        _updateProfile(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 130),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: defaultColor,
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
