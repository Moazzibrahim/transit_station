import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/controllers/notifications_services.dart';

class NotificationsAdminScreen extends StatefulWidget {
  final String role; // 'admin', 'user', or 'driver'

  const NotificationsAdminScreen({super.key, required this.role});

  @override
  State<NotificationsAdminScreen> createState() => _NotificationsAdminScreenState();
}

class _NotificationsAdminScreenState extends State<NotificationsAdminScreen> {
  late Future<List<Map<String, dynamic>>> messagesFuture;

  @override
  void initState() {
    super.initState();
    messagesFuture = Provider.of<NotificationsServices>(context,listen: false).fetchMessagesByRole(widget.role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Notifications'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: messagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading messages'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No messages found'));
            } else {
              final messages = snapshot.data!;
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: yellowColor
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message['title'],style: const TextStyle(fontSize: 20),),
                        Text(message['body'])
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
