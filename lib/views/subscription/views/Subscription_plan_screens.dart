// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/promo_code_controller.dart';
import 'package:transit_station/controllers/subscription_provider.dart';
import 'package:transit_station/models/subscription_model.dart';
import 'package:transit_station/views/home_views/screens/payment_screen.dart';

class SubscriptionPlanScreens extends StatefulWidget {
  const SubscriptionPlanScreens({super.key});

  @override
  _SubscriptionPlanScreensState createState() =>
      _SubscriptionPlanScreensState();
}

class _SubscriptionPlanScreensState extends State<SubscriptionPlanScreens> {
  int selectedIndex = 0;
  UserOffersResponse? _userOffersResponse;
  bool _isLoading = true;
  final TextEditingController _promoCodeController = TextEditingController();
  bool _isPromoApplied = false;

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionPlans();
  }

  Future<void> _fetchSubscriptionPlans() async {
    ApiServicesub apiService = ApiServicesub();
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

  Future<void> _applyPromoCode() async {
    if (_userOffersResponse == null || _userOffersResponse!.offers.isEmpty) {
      showTopSnackBar(context, 'No subscription plans available', Icons.error,
          Colors.red, const Duration(seconds: 2));
      return;
    }

    final String promocode = _promoCodeController.text.trim();
    final int offerId = _userOffersResponse!.offers[selectedIndex].id;

    if (promocode.isEmpty) {
      showTopSnackBar(context, 'Please enter a promo code', Icons.error,
          Colors.red, const Duration(seconds: 2));
      return;
    }

    await Provider.of<PromoCodeController>(context, listen: false)
        .submitPromoCode(promocode, offerId, context);
    setState(() {
      _isPromoApplied = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Subscription Plan'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            double cardWidth = constraints.maxWidth * 0.3;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                _userOffersResponse!.offers.length,
                                (index) {
                                  Offer offer =
                                      _userOffersResponse!.offers[index];
                                  return _buildSubscriptionCard(
                                    offer.offerName,
                                    "${offer.duration} days",
                                    "${offer.price}\$",
                                    "150\$",
                                    index,
                                    cardWidth,
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text("No subscription plans available"),
                        ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _promoCodeController,
                    decoration: InputDecoration(
                      labelText: 'Promo Code',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: _applyPromoCode,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display discounted price if promo code is applied
                  Consumer<PromoCodeController>(
                    builder: (context, promoCodeController, child) {
                      if (_isPromoApplied &&
                          promoCodeController.priceafterdiscount != null) {
                        return Text(
                          "Discounted Price: ${promoCodeController.priceafterdiscount}\$",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isPromoApplied) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentScreen()),
                          );
                        } else {
                          showTopSnackBar(
                              context,
                              'Please apply a promo code before proceeding',
                              Icons.error,
                              Colors.red,
                              const Duration(seconds: 2));
                        }
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
      String originalPrice, int index, double cardWidth) {
    bool isSelected = selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: cardWidth,
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
            selectedIndex = index;
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
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              duration,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : defaultColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: TextStyle(
                color: isSelected ? Colors.white : defaultColor,
                fontSize: 15,
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
