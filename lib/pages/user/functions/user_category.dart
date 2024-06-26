import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// _________________________homepage_category___________________________________

Widget userHomePageCategory({required String text, void Function()? onTap}) =>
    InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

// ______________________category_list_view_____________________________________

Widget userCategoryList(BuildContext context) => SizedBox(
      height: 40,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').where(
            'categoryName',
            whereIn: ['Others', 'Add-Pet', 'Cat', 'Dog']).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final category = documents[index].data() as Map<String, dynamic>;
              final categoryName = category['categoryName'];
              return userHomePageCategory(
                text: '$categoryName',
                onTap: () {
                  _userNavigateToCategory(context, categoryName);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 8.0),
          );
        },
      ),
    );

void _userNavigateToCategory(BuildContext context, String categoryName) {
  switch (categoryName) {
    case 'Cat':
      // Navigator.pushNamed(context, '/userprof');
      break;
    case 'Add-Pet':
      Navigator.pushNamed(context, '/user_pet_add');
      break;
    case 'Dog':
      // Navigator.pushNamed(context, '/wishlist');
      break;
    // Add more cases for additional category names and corresponding routes
    default:
      // If the category name doesn't match any predefined routes, you can handle it here
      print('No route defined for category: $categoryName');
      break;
  }
}
