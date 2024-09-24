import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/Driver/screens/edit_profile.dart';
import 'package:transit_station/views/auth_screens/widgets/build_appbar.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Personal info"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/amal.png'),
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
            const Text(
              'Amal Ghanem',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Full Name Info
            const PersonalInfoItem(
              icon: Icons.person,
              title: 'Full Name',
              value: 'Amal Ghanem',
            ),
            const SizedBox(height: 16),
            // Email Info
            const PersonalInfoItem(
              icon: Icons.email,
              title: 'Email',
              value: 'Amalghanem555@Gmail.Com',
            ),
            const SizedBox(height: 16),
            // Phone Number Info
            const PersonalInfoItem(
              icon: Icons.phone,
              title: 'Phone Number',
              value: '408-841-0926',
            ),
          ],
        ),
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
