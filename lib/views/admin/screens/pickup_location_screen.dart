import 'package:flutter/material.dart';
import 'package:transit_station/views/admin/widgets/pickup_container.dart';
import 'package:transit_station/constants/build_appbar.dart';

class PickupLocationScreen extends StatelessWidget {
  const PickupLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, '#Pick-Up Location'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: const [
            PickupContainer(
                image: 'assets/images/location 1.png',
                title: 'location 1',
                subtitle:'3rd floor, Apt. 5, AndalusiaBuilding, Al-Qasr Al-Aini Street',
                ),
                SizedBox(height: 20,),
                PickupContainer(
                image: 'assets/images/location 1.png',
                title: 'location 2',
                subtitle:'3rd floor, Apt. 5, AndalusiaBuilding, Al-Qasr Al-Aini Street',
                ),
          ],
        ),
      ),
    );
  }
}
