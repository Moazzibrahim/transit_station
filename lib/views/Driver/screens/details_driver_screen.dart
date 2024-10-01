import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/Driver/screens/arrive.dart';
import 'package:transit_station/constants/build_appbar.dart';

class DetailsRequestScreen extends StatelessWidget {
  const DetailsRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Details Request"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextDetail(title: 'Name', value: '    Ahmed Ali'),
            const TextDetail(title: 'Phone', value: '   01586522221'),
            const TextDetail(title: 'Area', value: '    Zamalek'),
            const TextDetail(title: 'Type', value: '    "BMW X5"'),
            const TextDetail(title: 'Car Model', value: '   "BMW X5"'),
            const TextDetail(
              title: 'Location',
              value:
                  '3rd Floor, Apt. 5, Andalusia Building, Al-Qasr Al-Aini Street',
            ),
            const TextDetail(title: 'Status', value: 'Receiving Car'),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TaskArriveScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: defaultColor),
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextDetail extends StatelessWidget {
  final String title;
  final String value;

  const TextDetail({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
