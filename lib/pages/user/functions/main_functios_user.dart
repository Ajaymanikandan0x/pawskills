import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/user/functions/pet_card.dart';
import '../usr_pet_info.dart';

// __________________________________Home_____________________________________________
Widget bell(
        {void Function()? onpressed,
        double width = 40,
        double height = 40,
        void Function()? ontap,
        IconData? icon}) =>
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
        child: Icon(
          icon,
          color: Colors.deepPurple,
        ),
      ),
    );

// ___________________________wish______________________________________________

Widget wishButton({
  required bool isWished,
  VoidCallback? onTap,
}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Icon(
          isWished ? Icons.favorite : Icons.favorite_border_outlined,
          color: Colors.red,
          size: 18,
        ),
      ),
    );
