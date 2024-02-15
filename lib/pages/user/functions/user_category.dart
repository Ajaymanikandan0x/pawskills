import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// _________________________homepage_category___________________________________

Widget userHomePageCategory({required String text, void Function()? ontap}) =>
    InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 40,
        width: text.length * 18.0,
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

Widget userCategoryList(BuildContext context) => Row(
      children: [
        Expanded(
          child: SizedBox(
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
                    final category =
                        documents[index].data() as Map<String, dynamic>;
                    final categoryName = category['categoryName'];
                    return userHomePageCategory(
                        text: '$categoryName',
                        ontap: () {
                          _userNavigateToCategory(context, categoryName);
                        });
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: 8.0,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );

void _userNavigateToCategory(BuildContext context, String categoryName) {
  switch (categoryName) {
    case 'Cat':
      Navigator.pushNamed(context, '/userprof');
      break;
    case 'Add-Pet':
      Navigator.pushNamed(context, '/user_pet_add');
      break;
    case 'Dog':
    // Navigator.pushNamed(context, '/category');
    // Add more cases for additional category names and corresponding routes
    default:
      // If the category name doesn't match any predefined routes, you can handle it here
      print('No route defined for category: $categoryName');
      break;
  }
}
