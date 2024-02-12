import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// __________________________category___________________________________________
Widget addnew(
        {void Function()? ontap,
        double height = 50,
        double width = 50,
        TextEditingController? controller,
        String? Hint_text,
        required IconData icon,
        String? Function(String?)? validate,
        bool readOnly = false}) =>
    Row(
      children: [
        Expanded(
            child: TextFormField(
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 20, top: 15, bottom: 15),
            filled: true,
            fillColor: Colors.white54,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: Colors.white54,
                width: 2.0,
              ),
            ),
            hintText: Hint_text,
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
          controller: controller,
          validator: validate,
          readOnly: readOnly,
        )),
        SizedBox(width: 8.0),
        InkWell(
          onTap: ontap,
          child: Container(
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
            width: width,
            height: height,
            child: Icon(icon),
          ),
        ),
      ],
    );

// _________________________homepage_category___________________________________

Widget homePageCategory({required String text, void Function()? ontap}) =>
    InkWell(
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

// ______________________category_list_view_____________________________________

Widget categoryList(BuildContext context) => StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final category = documents[index].data() as Map<String, dynamic>;
              final categoryName = category['categoryName'];
              return homePageCategory(
                  text: '$categoryName',
                  ontap: () {
                    _navigateToCategory(context, categoryName);
                  });
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              width: 8.0,
            ),
          ),
        );
      },
    );

void _navigateToCategory(BuildContext context, String categoryName) {
  switch (categoryName) {
    case 'Edit':
      Navigator.pushNamed(context, '/category');
      break;
    case 'Add':
      Navigator.pushNamed(context, '/addnewpet');
      break;
    case 'Dog':
      Navigator.pushNamed(context, '/category');
    // Add more cases for additional category names and corresponding routes
    default:
      // If the category name doesn't match any predefined routes, you can handle it here
      print('No route defined for category: $categoryName');
      break;
  }
}

// ________________________________bottom_navbar________________________________

Widget customNavBar({
  required List<IconData> icons,
  required int currentIndex,
  required void Function(int) onTap,
}) =>
    Container(
      height: 60,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          final icon = icons[index];

          return _buildNavItem(
            icon: icon,
            onTap: () => onTap(index),
            isActive: currentIndex == index,
          );
        }),
      ),
    );

Widget _buildNavItem({
  required IconData icon,
  required VoidCallback onTap,
  required bool isActive,
}) =>
    InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue : Colors.black,
          ),
        ],
      ),
    );
