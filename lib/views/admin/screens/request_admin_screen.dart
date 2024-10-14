import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/request_admin_provider.dart';
import 'package:transit_station/models/request_admin_model.dart';
import 'package:transit_station/views/admin/screens/choose_request.dart';
import 'package:transit_station/views/admin/screens/select_driver_screen.dart';

class RequestAdminScreen extends StatelessWidget {
  const RequestAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: appBarWithActions(context, 'Request', () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const ChooseRequest()));
        }),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  labelPadding: EdgeInsets.zero,
                  indicator: BoxDecoration(
                    color: defaultColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: defaultColor,
                  tabs: const [
                    _CustomTab(text: 'Pending'),
                    _CustomTab(text: 'Current'),
                    _CustomTab(text: 'History'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<Request>>(
                      future: fetchRequests(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No requests found.'));
                        } else {
                          // Filter current requests
                          List<Request> carRequests = snapshot.data!
                              .where((e) => e.status == 'pending')
                              .toList();

                          // Sort by nearest pickUpDate
                          carRequests.sort((a, b) {
                            DateTime dateA = DateTime.parse(a.pickUpDate);
                            DateTime dateB = DateTime.parse(b.pickUpDate);
                            return dateA
                                .compareTo(dateB); // Sorts by nearest date
                          });

                          return ListView.builder(
                            itemCount: carRequests.length,
                            itemBuilder: (context, index) {
                              final request = carRequests[index];
                              

    // Parse the pickUpDate and get the current date
    DateTime pickUpDate = DateTime.parse(request.pickUpDate);
    DateTime currentDate = DateTime.now();

    // Check if the current date exceeds the pickUpDate
    bool isOverdue = currentDate.isAfter(pickUpDate);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => SelectDriverScreen(
                                          requestId: request.id
                                              .toString()), // Pass request ID here
                                    ),
                                  );
                                  print(request.id);
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildInfoRow(
                                          icon: Icons.person,
                                          label: 'User Name',
                                          value: request.user.name,
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.phone,
                                          label: 'Phone',
                                          value: request.user.phone,
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.card_giftcard,
                                          label: 'Offer Name',
                                          value: request
                                                  .user.subscription.isNotEmpty
                                              ? request.user.subscription[0]
                                                  .offer.offerName
                                              : 'No offer available',
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.calendar_today,
                                          label: 'Pick-Up Date',
                                          value: request.pickUpDate,
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.access_time,
                                          label: 'Request Time',
                                          value: request.requestTime,
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.location_on,
                                          label: 'Pick-Up Address',
                                          value: request.location.pickUpAddress,
                                        ),
                                        const SizedBox(height: 8),
                                        if (isOverdue)
                const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Pick-up date exceeded!',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                                        const SizedBox(height: 8),
                                        const Divider(),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    //current widgetss**********************************
                    FutureBuilder<List<Request>>(
                      future: fetchRequests(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No requests found.'));
                        } else {
                          // Filter current requests
                          List<Request> carRequests = snapshot.data!
                              .where((e) => e.status == 'current')
                              .toList();

                          // Sort by nearest pickUpDate
                          carRequests.sort((a, b) {
                            DateTime dateA = DateTime.parse(a.pickUpDate);
                            DateTime dateB = DateTime.parse(b.pickUpDate);
                            return dateA
                                .compareTo(dateB); // Sorts by nearest date
                          });

                          return ListView.builder(
  itemCount: carRequests.length,
  itemBuilder: (context, index) {
    final request = carRequests[index];

    // Parse the pickUpDate and get the current date
    DateTime pickUpDate = DateTime.parse(request.pickUpDate);
    DateTime currentDate = DateTime.now();

    // Check if the current date exceeds the pickUpDate
    bool isOverdue = currentDate.isAfter(pickUpDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              icon: Icons.person,
              label: 'User Name',
              value: request.user.name,
            ),
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: request.user.phone,
            ),
            _buildInfoRow(
              icon: Icons.card_giftcard,
              label: 'Offer Name',
              value: request.user.subscription.isNotEmpty
                  ? request.user.subscription[0].offer.offerName
                  : 'No offer available',
            ),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Pick-Up Date',
              value: request.pickUpDate,
            ),
            _buildInfoRow(
              icon: Icons.access_time,
              label: 'Request Time',
              value: request.requestTime,
            ),
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Pick-Up Address',
              value: request.location.pickUpAddress,
            ),
            const SizedBox(height: 8),
    
            // Show warning if the current date exceeds the pick-up date
            if (isOverdue)
              const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Pick-up date exceeded!',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
    
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  },
);
                        }
                      },
                    ),
                    // history widgets***************
                    FutureBuilder<List<Request>>(
                      future: fetchRequests(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No requests found.'));
                        } else {
                          final carRequests = snapshot.data!;
                          final filteredRequests = carRequests
                              .where(
                                // ignore: unrelated_type_equality_checks
                                (e) => e.status == 0,
                              )
                              .toList();
                          if (filteredRequests.isEmpty) {
                            return const Center(
                              child: Text('No history requests'),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: carRequests.length,
                              itemBuilder: (context, index) {
                                final request = filteredRequests[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildInfoRow(
                                          icon: Icons.person,
                                          label: 'User Name',
                                          value: request.user.name,
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.phone,
                                          label: 'Phone',
                                          value: request.user.phone,
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.card_giftcard,
                                          label: 'Offer Name',
                                          value: request
                                                  .user.subscription.isNotEmpty
                                              ? request.user.subscription[0]
                                                  .offer.offerName
                                              : 'No offer available',
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.calendar_today,
                                          label: 'Pick-Up Date',
                                          value: request.pickUpDate,
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.access_time,
                                          label: 'Request Time',
                                          value: request.requestTime,
                                        ),
                                        _buildInfoRow(
                                          icon: Icons.location_on,
                                          label: 'Pick-Up Address',
                                          value: request.location.pickUpAddress,
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: defaultColor, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: defaultColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomTab extends StatelessWidget {
  final String text;

  const _CustomTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
