import 'package:flutter/material.dart';

// ________________________________button_________________________________________
Widget button(
        {required String text,
        double width = 250,
        double height = 50,
        required void Function() ontap}) =>
    InkWell(
      onTap: ontap,
      child: Container(
        width: width, // Adjust width as needed
        height: height, // Adjust height as needed
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.lightBlueAccent,
              Colors.blue.shade800,
            ],
            stops: const [0.2, 0.4],
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white), // Adjust text color if needed
          ),
        ),
      ),
    );
