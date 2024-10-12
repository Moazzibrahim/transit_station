import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/controllers/request_admin_provider.dart';

class SelectDriverScreen extends StatefulWidget {
  const SelectDriverScreen({super.key});

  @override
  State<SelectDriverScreen> createState() => _SelectDriverScreenState();
}

class _SelectDriverScreenState extends State<SelectDriverScreen> {
  @override
  void initState() {
    Provider.of<RequestAdminProvider>(context,listen: false).fetchAvailableDrivers(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,'Select a driver'),
      body: Consumer<RequestAdminProvider>(
        builder: (context, driversProvider, _) {
          var drivers = driversProvider.drivers;
          if(drivers == null){
            return const Center(child: CircularProgressIndicator(),);
          }else{
            return const Center(child: Text('data fetched'),);
          }
        },
        ),
    );
  }
}