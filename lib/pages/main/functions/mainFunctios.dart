import 'package:flutter/material.dart';

// __________________________________Home_____________________________________________
Widget bell(
        {void Function()? onpressed,
        double width = 40,
        double height = 40,
        void Function()? ontap}) =>
    InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: width,
        height: height,
        child: const Icon(
          Icons.notifications_none,
          color: Colors.deepPurple,
        ),
      ),
    );
// _________________________________category_______________________________________________

Widget category({required String text, void Function()? ontap}) => InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 35,
        width: 90,
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600]),
        )),
      ),
    );
