import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/views/Driver/controller/get_color_provider.dart';
import 'package:transit_station/views/admin/screens/add_color_admin.dart'; // Ensure you import the provider

class ColorListScreen extends StatelessWidget {
  const ColorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch colors when the screen is built
    Provider.of<ColorServiceprovider>(context, listen: false)
        .getColors(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'colors',
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
                  MaterialPageRoute(builder: (ctx) => const AddColorAdmin()));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: const Row(
              children: [
                Icon(Icons.add),
                Text('color'),
              ],
            ),
          ),
          const SizedBox(width: 3),
        ],
      ),
      body: Consumer<ColorServiceprovider>(
        builder: (context, colorServiceProvider, child) {
          if (colorServiceProvider.colorsResponse == null) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show a loading indicator while the data is being fetched
          }

          // Display the list of colors
          return ListView.builder(
            itemCount: colorServiceProvider.colorsResponse?.colors.length ?? 0,
            itemBuilder: (context, index) {
              final color = colorServiceProvider.colorsResponse!.colors[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      color.colorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: color.colorCode != null
                        ? Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              // Remove the '#' from the colorCode before parsing
                              color: Color(int.parse(
                                  '0xff${color.colorCode!.replaceAll('#', '')}')),
                              shape: BoxShape.circle,
                            ),
                          )
                        : null, // Hide if color_code is null
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
