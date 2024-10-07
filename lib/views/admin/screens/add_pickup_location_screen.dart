import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/constants/widgets.dart';
import 'package:transit_station/controllers/dashboard_controller.dart';
import 'package:transit_station/controllers/image_services.dart';

class AddPickupLocationScreen extends StatefulWidget {
  const AddPickupLocationScreen({super.key});

  @override
  State<AddPickupLocationScreen> createState() => _AddPickupLocationScreenState();
}

class _AddPickupLocationScreenState extends State<AddPickupLocationScreen> {
  final _addressController = TextEditingController();
  final _addressIndetailsController = TextEditingController();
  File? image;
  String? base64Image;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Add Pick-up Location'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: inputDecoration('Address'),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: _addressIndetailsController,
              decoration: inputDecoration('Address in details'),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () async{
                final imageServices =  Provider.of<ImageServices>(context,listen: false);
                await imageServices.pickImage();
                setState(() {
                  image = imageServices.image;
                });
                base64Image = imageServices.convertImageToBase64(image!);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.withOpacity(0.5)
                ),
                child:  Row(
                  children: [
                    SvgPicture.asset('assets/images/download icon.svg'),
                    const SizedBox(width: 7,),
                    const Text('Image',style: TextStyle(color: defaultColor,fontSize: 16,fontWeight: FontWeight.w400),),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(base64Image != null){
                    Provider.of<DashboardController>(context,listen: false).postPickUpLocation(context,
                    address: _addressController.text, 
                    addressInDetails: _addressIndetailsController.text,
                    pickupAddress: _addressIndetailsController.text,
                    locationImage: base64Image!
                    );
                    showTopSnackBar(context,'Pick-up location added', Icons.check_circle_outline,defaultColor, const Duration(seconds: 4));
                  }else{
                    showTopSnackBar(context,'please fill all fields', Icons.warning,defaultColor, const Duration(seconds: 4));
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