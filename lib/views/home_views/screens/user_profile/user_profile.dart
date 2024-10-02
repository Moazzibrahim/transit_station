import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/Driver/screens/edit_profile.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/controllers/get_profile_data.dart'; // Adjust the import as necessary

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GetProfileData>(
      builder: (context, profileProvider, child) {
        // Only trigger fetching of profile data if not already loaded
        if (profileProvider.userProfileModel == null &&
            !profileProvider.isLoading) {
          // Using WidgetsBinding to ensure it runs after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            profileProvider.getprofile(context);
          });
        }

        return Scaffold(
          appBar: buildAppBar(context, "Personal info"),
          body: profileProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : profileProvider.error != null
                  ? Center(child: Text(profileProvider.error!))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                const CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(
                                      'assets/images/amal.png'), // Default image
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
                          // Full Name from API
                          Text(
                            profileProvider.userProfileModel?.name ?? 'No Name',
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
                            value: profileProvider.userProfileModel?.name ??
                                'No Name',
                          ),
                          const SizedBox(height: 16),
                          // Email Info
                          PersonalInfoItem(
                            icon: Icons.email,
                            title: 'Email',
                            value: profileProvider.userProfileModel?.email ??
                                'No Email',
                          ),
                          const SizedBox(height: 16),
                          // Phone Number Info
                          PersonalInfoItem(
                            icon: Icons.phone,
                            title: 'Phone Number',
                            value: profileProvider.userProfileModel?.phone ??
                                'No Phone Number',
                          ),
                        ],
                      ),
                    ),
        );
      },
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
