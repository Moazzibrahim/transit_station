import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';
import 'package:transit_station/constants/colors.dart';
import 'package:transit_station/models/cars_model.dart';
import 'package:transit_station/views/home_views/screens/add_car_screen.dart';
import '../../../controllers/car_provider.dart';
import '../widgets/car_container.dart';

class MyCarsScreen extends StatefulWidget {
  const MyCarsScreen({super.key});

  @override
  _MyCarsScreenState createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen> {
  int? selectedCarIndex;
  List<Car>? cars; // List to store fetched car data
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchCars(); // Fetch cars when the screen is initialized
  }

  // Function to fetch cars from the API
  Future<void> fetchCars() async {
    ApiService apiService = ApiService();
    List<Car>? fetchedCars = await apiService.fetchUserCars(context);

    setState(() {
      cars = fetchedCars;
      isLoading = false; // Set loading to false once the data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Your cars'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cars == null || cars!.isEmpty
              ? const Center(child: Text('No cars available'))
              : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: cars!.length,
                        itemBuilder: (context, index) {
                          final car = cars![index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCarIndex = index;
                              });
                            },
                            child: CarContainer(
                              name: car.carName,
                              image: car.carImage,
                              selectedItem:
                                  selectedCarIndex == index ? index : null,
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx) => const AddCarScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defaultColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'add car',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
    );
  }
}
