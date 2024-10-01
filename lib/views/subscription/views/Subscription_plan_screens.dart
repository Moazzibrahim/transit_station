import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/subscription_provider.dart';
import 'package:transit_station/views/auth_screens/widgets/build_appbar.dart';
import 'package:transit_station/models/subscription_model.dart'; // Your model import

class SubscriptionPlanScreens extends StatefulWidget {
  const SubscriptionPlanScreens({super.key});

  @override
  _SubscriptionPlanScreensState createState() =>
      _SubscriptionPlanScreensState();
}

class _SubscriptionPlanScreensState extends State<SubscriptionPlanScreens> {
  int selectedIndex = 0; // Track selected card index
  UserOffersResponse? _userOffersResponse; // To store fetched data
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionPlans();
  }

  Future<void> _fetchSubscriptionPlans() async {
    ApiService apiService = ApiService();
    UserOffersResponse? response =
        await apiService.fetchUserSubscription(context);

    if (response != null) {
      setState(() {
        _userOffersResponse = response;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Subscription Plan'),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose The Plan That Suits You",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  _userOffersResponse != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                              _userOffersResponse!.offers.length, (index) {
                            Offer offer = _userOffersResponse!.offers[index];
                            return _buildSubscriptionCard(
                              offer.offerName,
                              "${offer.duration} Months", // Assuming duration is in months
                              "${offer.price}\$",
                              "150\$", // Adjust as per your requirements
                              index,
                            );
                          }),
                        )
                      : const Center(
                          child: Text("No subscription plans available"),
                        ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle done action
                      },
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
