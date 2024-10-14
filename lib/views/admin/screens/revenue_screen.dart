import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/revenue_provider.dart';
import 'package:transit_station/views/admin/screens/add_revenue_screen.dart';
import 'package:transit_station/views/admin/screens/add_type_reveneu.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  String _selectedFilter = 'All';
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RevenueProvider>(context, listen: false)
          .fetchRevenues(context);
      _applyFilter(); // Apply the filter after fetching revenues
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch revenues every time the screen is built
    Provider.of<RevenueProvider>(context, listen: false).fetchRevenues(context);

    // Reset the filter to 'All' on first build
    if (_isFirstBuild) {
      _selectedFilter = 'All';
      _isFirstBuild = false; // Set the flag to false after the first build
    }

    // Use addPostFrameCallback to apply the filter after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilter();
    });
  }

  void _applyFilter() {
    final revenueProvider =
        Provider.of<RevenueProvider>(context, listen: false);
    revenueProvider.filterRevenuesByDate(_selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Revenue',
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddTypeReveneu()));
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
      body: Consumer<RevenueProvider>(
        builder: (context, revenueProvider, child) {
          return Column(
            children: [
              // Dropdown for filter selection
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Revenue: \$${revenueProvider.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: defaultColor,
                  ),
                ),
              ),
              Expanded(
                child: Consumer<RevenueProvider>(
                  builder: (context, revenueProvider, _) {
                    if (revenueProvider.revenueData.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: revenueProvider.revenueData.length,
                        itemBuilder: (context, index) {
                          final revenue = revenueProvider.revenueData[index];
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
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const AddRevenueScreen()));
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
              ),
            ],
          );
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
