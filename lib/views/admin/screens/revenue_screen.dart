import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/controllers/revenue_provider.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  @override
  void initState() {
    Provider.of<RevenueProvider>(context,listen: false).fetchRevenues(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Revenue'),
      body: Consumer<RevenueProvider>(
        builder: (context, revenueProvider, _) {
          if(revenueProvider.revenueData.isEmpty){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return ListView.builder(
              itemCount:revenueProvider.revenueData.length ,
          itemBuilder: (context, index) {
            return const Center(child: Text('revenues fetched done'),);
          },
          );
          }
        },
      ),
    );
  }
}