import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import 'adminFunctions/adminFunction.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<TextEditingController> controllers = [];
  List<String> categoryNames = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Add initial controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Category',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: Colors.grey[200],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: ListView.separated(
            itemCount: controllers.length + 1, // Add one for the add button
            itemBuilder: (context, index) {
              if (index == controllers.length) {
                // Last item, show add button
                return addnew(
                    Hint_text: 'add new',
                    ontap: () => _addNewField(),
                    icon: Icons.add,
                    readOnly: true);
              } else {
                // Display existing field
                return addnew(
                  controller: controllers[index],
                  Hint_text: 'Category ${index + 1}',
                  ontap: () => _deleteField(index),
                  icon: Icons.delete,
                );
              }
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 9.0,
            ),
          ),
        ),
        bottomSheet: Padding(
            padding: const EdgeInsets.all(15.0),
            child: button(
                text: 'Save Categories', ontap: _saveToFirebase, width: 350)));
  }

  void _addNewField() {
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void _deleteField(int index) async {
    if (index < controllers.length) {
      String documentId = controllers[index].text;
      if (documentId.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection('categories')
              .doc(documentId)
              .delete();
          print('Document deleted from Firestore successfully!');
        } catch (error) {
          print('Error deleting document from Firestore: $error');
        }
      }
    }

    setState(() {
      controllers.removeAt(index);
    });
  }

  Future<void> _fetchCategories() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        categoryNames = querySnapshot.docs
            .map((doc) => doc['categoryName'] as String)
            .toList();

        // Initialize controllers and assign fetched data to each controller
        controllers = categoryNames
            .map((categoryName) => TextEditingController(text: categoryName))
            .toList();
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  void _saveToFirebase() async {
    final CollectionReference categoriesRef =
        FirebaseFirestore.instance.collection('categories');

    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      for (int i = 0; i < controllers.length; i++) {
        String fieldValue = controllers[i].text;
        if (fieldValue.isNotEmpty) {
          // Check if the field already exists
          bool fieldExists = await fieldExistsInCollection(
              categoriesRef, 'categoryName', fieldValue);
          if (!fieldExists) {
            // Create the field if it doesn't exist
            batch.set(categoriesRef.doc(), {'categoryName': fieldValue});
          } else {
            // Handle duplicate detection (e.g., display message, append number)
            print(
                'Field "categoryName" already exists. Skipping creation for "$fieldValue".');
          }
        }
      }
      await batch.commit();
      print('Data saved to Firestore successfully!');
    } catch (error) {
      print('Error saving data to Firestore: $error');
    }
  }

  Future<bool> fieldExistsInCollection(CollectionReference collectionRef,
      String fieldName, String fieldValue) async {
    try {
      // Query the collection with a limit of 1, filtering for documents where the field matches the fieldValue
      var snapshot = await collectionRef
          .where(fieldName, isEqualTo: fieldValue)
          .limit(1)
          .get();

      // Check if any documents were found. If yes, the field exists.
      return snapshot.docs.isNotEmpty;
    } catch (error) {
      // Handle potential errors gracefully
      print('Error checking for field existence: $error');
      rethrow; // Rethrow the error for proper handling
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
