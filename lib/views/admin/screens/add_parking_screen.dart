import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/parking_controller.dart';

class AddParkingScreen extends StatefulWidget {
  const AddParkingScreen({super.key});

  @override
  State<AddParkingScreen> createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends State<AddParkingScreen> {
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add Parking'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: inputDecoration('Name'),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: _capacityController,
              decoration: inputDecoration('Capacity'),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: _locationController,
              decoration: inputDecoration('location'),
            ),
            const SizedBox(height: 20,),
              SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                if(_nameController.text.trim().isEmpty || _capacityController.text.trim().isEmpty || _locationController.text.trim().isEmpty){
                  showTopSnackBar(context,'please fill all fields', Icons.warning,defaultColor, const Duration(seconds: 4));
                }else{
                  Provider.of<ParkingController>(context,listen: false).addParking(context,
                    _nameController.text,
                    int.parse(_capacityController.text),
                    _locationController.text
                    );
                    showTopSnackBar(context,'Parking added', Icons.check_circle_outline,defaultColor, const Duration(seconds: 4));
                }
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
                child: const Text('Done',style: TextStyle(fontSize: 20),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}