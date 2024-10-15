import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/Driver/controller/get_profile_driver.dart';
import 'package:transit_station/views/Driver/screens/edit_profile.dart';
import 'package:transit_station/constants/build_appbar.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<GetProfileDriver>(context, listen: false)
        .getProfileDriverProviderdata(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Personal info"),
      body: Consumer<GetProfileDriver>(
        builder: (context, getProfileDriver, child) {
          if (getProfileDriver.profileDriver == null) {
            // Show a loading spinner or placeholder while waiting for data
            return const Center(child: CircularProgressIndicator());
          }

          // Profile data is available
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: getProfileDriver
                                    .profileDriver!.profile!.image !=
                                null
                            ? MemoryImage(base64Decode(getProfileDriver
                                .profileDriver!.profile!.image!))
                            : const AssetImage('assets/images/boy.png')
                                as ImageProvider, // Fallback in case image is null
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: defaultColor,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfileDriver()));
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Full Name
                Text(
                  getProfileDriver.profileDriver!.profile!.name ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                // Full Name Info
                PersonalInfoItem(
                  icon: Icons.person,
                  title: 'Full Name',
                  value: getProfileDriver.profileDriver!.profile!.name ?? 'N/A',
                ),
                const SizedBox(height: 16),
                // Email Info
                PersonalInfoItem(
                  icon: Icons.email,
                  title: 'Email',
                  value:
                      getProfileDriver.profileDriver!.profile!.email ?? 'N/A',
                ),
                const SizedBox(height: 16),
                // Phone Number Info
                PersonalInfoItem(
                  icon: Icons.phone,
                  title: 'Phone Number',
                  value:
                      getProfileDriver.profileDriver!.profile!.phone ?? 'N/A',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget to display the personal info items
class PersonalInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const PersonalInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Colors.grey[600]),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
