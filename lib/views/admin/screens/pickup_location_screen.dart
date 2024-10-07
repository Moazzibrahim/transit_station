import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/dashboard_controller.dart';
import 'package:transit_station/views/admin/screens/add_pickup_location_screen.dart';
import 'package:transit_station/views/admin/widgets/pickup_container.dart';
import 'package:transit_station/constants/build_appbar.dart';

class PickupLocationScreen extends StatefulWidget {
  const PickupLocationScreen({super.key});

  @override
  State<PickupLocationScreen> createState() => _PickupLocationScreenState();
}

class _PickupLocationScreenState extends State<PickupLocationScreen> {
  @override
  void initState() {
    Provider.of<DashboardController>(context,listen: false).fetchPickupLocations(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, '#Pick-Up Location'),
      body: Consumer<DashboardController>(
        builder: (context, pickupLocationProvider, _) {
          if(pickupLocationProvider.locationData.isEmpty){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: pickupLocationProvider.locationData.length,
                  itemBuilder: (context, index) {
                    final location = pickupLocationProvider.locationData[index];
                    return PickupContainer(
                      image: location.image,
                      title: location.address,
                      subtitle: location.pickupAddress,
                    );
                  },
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
                  children: [Icon(Icons.add), Text('Add',style: TextStyle(fontSize: 20),)],
                ),
              ),
            ],
          ),
        );
          }
        },
      ),
    );
  }
}
