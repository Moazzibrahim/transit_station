import 'package:flutter/material.dart';
import 'package:transit_station/constants/colors.dart';

Widget buildAppBar(BuildContext context,String title) {
  return AppBar(
    title: Text(title,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
    leading: IconButton(onPressed: (){
      Navigator.pop(context);
    }, icon: const Icon(Icons.arrow_back_ios,color: defaultColor,)),
  );
}