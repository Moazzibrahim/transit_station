import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/auth_screens/widgets/build_appbar.dart';

class SubscriptionPlanScreens extends StatefulWidget {
  const SubscriptionPlanScreens({super.key});

  @override
  _SubscriptionPlanScreensState createState() =>
      _SubscriptionPlanScreensState();
}

class _SubscriptionPlanScreensState extends State<SubscriptionPlanScreens> {
  int selectedIndex = 0; // Track selected card index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Subscription Plan'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose The Plan That Suits You",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSubscriptionCard(
                    "Platinum", "6 Months", "116\$", "150\$", 0),
                _buildSubscriptionCard(
                    "Gold", "12 Months", "116\$", "150\$", 1),
                _buildSubscriptionCard(
                    "Silver", "One Month", "116\$", "150\$", 2),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 100,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(String title, String duration, String price,
      String originalPrice, int index) {
    bool isSelected = selectedIndex == index; // Check if this card is selected

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? defaultColor : Colors.white,
        border: Border.all(color: defaultColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index; // Update selected index on tap
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.star, // Placeholder icon; replace with plan-specific icons
              size: 40,
              color: Colors.amber,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : defaultColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              duration,
              style: TextStyle(
                color: isSelected ? Colors.white : defaultColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              price,
              style: TextStyle(
                color: isSelected ? Colors.white : defaultColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              originalPrice,
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "/Month",
              style: TextStyle(
                color: isSelected ? Colors.white : defaultColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
