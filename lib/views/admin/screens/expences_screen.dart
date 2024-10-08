import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/expences_provider.dart';

class ExpencesScreen extends StatefulWidget {
  const ExpencesScreen({super.key});

  @override
  State<ExpencesScreen> createState() => _ExpencesScreenState();
}

class _ExpencesScreenState extends State<ExpencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithActions(context,'Expenses',(){}),
       body: Consumer<ExpencesProvider>(
        builder: (context, expenceProvider, _) {
          if(expenceProvider.expenceData.isEmpty){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount:expenceProvider.expenceData.length ,
                              itemBuilder: (context, index) {
                    final revenue = expenceProvider.expenceData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                                    icon: Icons.date_range,
                                    label: 'Date',
                                    value: revenue.date,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    icon: Icons.money,
                                    label: 'Amount',
                                    value: revenue.amount.toString(),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    icon: Icons.category,
                                    label: 'Type',
                                    value: revenue.type,
                                  ),
                          ],
                        ),
                      ),
                    );
                              },
                              ),
                  ),
                  ElevatedButton(
                  onPressed: () {
                    
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
  Widget _buildInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: defaultColor, size: 20),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: defaultColor,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}