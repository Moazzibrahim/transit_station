import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/expences_provider.dart';
import 'package:transit_station/views/admin/screens/add_expence_screen.dart';
import 'package:transit_station/views/admin/screens/add_type_expence_screen.dart';

class ExpencesScreen extends StatefulWidget {
  const ExpencesScreen({super.key});

  @override
  State<ExpencesScreen> createState() => _ExpencesScreenState();
}

class _ExpencesScreenState extends State<ExpencesScreen> {
  String _selectedFilter =
      'All'; // Filter options: All, Weekly, Monthly, Yearly

  @override
  void initState() {
    Provider.of<ExpencesProvider>(context, listen: false)
        .fetchExpences(context);
    super.initState();
  }

  void _applyFilter() {
    // Apply the filter and notify the listeners
    Provider.of<ExpencesProvider>(context, listen: false)
        .filterExpencesByDate(_selectedFilter);

    // Refresh the state to update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Expenses',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        leading: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: defaultColor,
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const AddTypeExpenceScreen()));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: const Row(
              children: [
                Icon(Icons.add),
                Text('Type'),
              ],
            ),
          ),
          const SizedBox(width: 3),
        ],
      ),
      body: Consumer<ExpencesProvider>(
        builder: (context, expenceProvider, _) {
          if (expenceProvider.expenceData.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFilter = newValue!;
                        });
                        _applyFilter();
                      },
                      items: <String>['All', 'Weekly', 'Monthly', 'Yearly']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      icon: const Icon(Icons.filter_list),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: expenceProvider.expenceData.length,
                      itemBuilder: (context, index) {
                        final expence = expenceProvider.expenceData[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
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
                                  value: expence.date,
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  icon: Icons.money,
                                  label: 'Amount',
                                  value: expence.amount.toString(),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  icon: Icons.category,
                                  label: 'Type',
                                  value: expence.type,
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const AddExpenceScreen()));
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
                      children: [
                        Icon(Icons.add),
                        Text(
                          'Add',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
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
