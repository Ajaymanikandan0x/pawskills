import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pawskills/pages/user/functions/settings.dart';

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

// ____________________________imgadd_______________________________________
Widget usrPetImg({
  void Function()? ontap,
  required String text,
  String? selectimg,
}) =>
    InkWell(
      onTap: ontap,
      child: Container(
        width: 130,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: selectimg != null
            ? Image.memory(
                base64Decode(selectimg), // Decode base64 string to bytes
                fit: BoxFit.cover, // Adjust this to fit your UI requirements
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
      ),
    );
// ______________________________settings_List__________________________________

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            AppSettings.kickOut(context); // Call signOut method
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          onTap: () {
            AppSettings.openPrivacyPolicy(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.contact_page),
          title: const Text('Contact'),
          onTap: () {
            AppSettings.openContact(context); // Call openContact method
          },
        ),
        ListTile(
          leading: const Icon(Icons.support_agent),
          title: const Text('Support'),
          onTap: () {
            AppSettings.openSupport(context); // Call openSupport method
          },
        ),
      ],
    ),
  );
}
