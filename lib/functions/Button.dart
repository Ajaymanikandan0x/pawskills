import 'package:flutter/material.dart';

Widget button(
        {required String text, required String routeName, required context}) =>
    InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        width: 250, // Adjust width as needed
        height: 50, // Adjust height as needed
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.lightBlueAccent,
              Colors.blue,
            ],
            stops: [0.2, 0.5],
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
