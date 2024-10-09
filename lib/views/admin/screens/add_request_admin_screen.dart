import 'package:flutter/material.dart';
import 'package:transit_station/constants/build_appbar.dart';

class AddRequestAdminScreen extends StatelessWidget {
  const AddRequestAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'add request'),
    );
  }
}
