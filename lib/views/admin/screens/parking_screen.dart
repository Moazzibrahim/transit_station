import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/parking_controller.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  @override
  void initState() {
    Provider.of<ParkingController>(context,listen: false).fetchParking(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, '#Parking'),
      body: Consumer<ParkingController>(
        builder: (context, parkingProvider, _) {
          if(parkingProvider.parkingData.isEmpty){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: 3,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 16,crossAxisSpacing: 16,mainAxisExtent: 150),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8),
                width: 104,
                decoration: BoxDecoration(
                  color: defaultColor,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(parkingProvider.parkingData[index].name,style: const TextStyle(color: Colors.white),),
                    Center(child: Text(parkingProvider.parkingData[index].capacity.toString(),style: const TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w400),),),
                    const SizedBox(height: 10,)
                  ],
                ),
              );
            },
            ),
        );
          }
        },
      ),
    );
  }
}