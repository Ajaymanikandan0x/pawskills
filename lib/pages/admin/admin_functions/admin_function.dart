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
        const SizedBox(width: 8.0),
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
        width: text.length * 20.0,
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

Widget categoryList(BuildContext context) => Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
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
                );
              },
            ),
          ),
        ),
      ],
    );

void _navigateToCategory(BuildContext context, String categoryName) {
  switch (categoryName) {
    case 'Edit_category':
      Navigator.pushNamed(context, '/category');
      break;
    case 'Add-Pet':
      Navigator.pushNamed(context, '/addnewpet');
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

Widget editButton(
        {double height = 30,
        double? width = 30,
        double icon_size = 10,
        void Function()? ontap}) =>
    InkWell(
      onTap: ontap,
      child: Container(
          height: height,
          width: width,
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
            Icons.edit,
            size: icon_size,
          )),
    );
// ___________________________________delete_pet________________________________

Widget deleteIcon(
        {required BuildContext context,
        required String petName,
        required Function() deletePet}) =>
    GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Pet'),
              content: Text('Are you sure you want to delete $petName?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      // Perform deletion logic here
                      await deletePet();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Pet $petName deleted successfully!'),
                        ),
                      );
                      Navigator.of(context).pop(); // Close the dialog
                    } catch (error) {
                      print('Error deleting pet: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('An error occurred while deleting the pet.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: Icon(
        Icons.delete,
        size: 30,
        color: Colors.grey[700],
      ),
    );
// ___________________________________delete____________________________________

Widget deleteButton(
        {double height = 30,
        double? width = 30,
        double icon_size = 10,
        void Function()? ontap}) =>
    InkWell(
      onTap: ontap,
      child: Container(
          height: height,
          width: width,
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
            Icons.delete,
            size: icon_size,
          )),
    );
