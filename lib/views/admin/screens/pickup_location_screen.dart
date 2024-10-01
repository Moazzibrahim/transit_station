import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/admin/screens/add_pickup_location_screen.dart';
import 'package:transit_station/views/admin/widgets/pickup_container.dart';
import 'package:transit_station/views/auth_screens/widgets/build_appbar.dart';

class PickupLocationScreen extends StatelessWidget {
  const PickupLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, '#Pick-Up Location'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  PickupContainer(
                    image: 'assets/images/location 1.png',
                    title: 'location 1',
                    subtitle:
                        '3rd floor, Apt. 5, AndalusiaBuilding, Al-Qasr Al-Aini Street',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PickupContainer(
                    image: 'assets/images/location 1.png',
                    title: 'location 2',
                    subtitle:
                        '3rd floor, Apt. 5, AndalusiaBuilding, Al-Qasr Al-Aini Street',
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx)=> const AddPickupLocationScreen())
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  )),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.add), Text('Add')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
