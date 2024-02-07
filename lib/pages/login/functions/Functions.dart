import 'package:flutter/material.dart';

// ________________________________button_________________________________________
Widget button(
        {required String text,
        required String routeName,
        required context,
        double width = 250,
        double height = 50}) =>
    InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
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
            stops: [0.2, 0.4],
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