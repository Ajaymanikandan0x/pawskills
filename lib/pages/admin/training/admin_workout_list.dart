import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawskills/pages/admin/admin_functions/admin_function.dart';
import '../admin_functions/training_function/add_trainig_list.dart';
import '../admin_workout_subList.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({Key? key}) : super(key: key);

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  final workoutListController = TextEditingController(text: 'Exercises');
  final timeController = TextEditingController(text: 'Min');
  final categoryNameController = TextEditingController();
  late String mainImage;
  String? _selectedImage;

  String selectedEnergyLevel = 'High'; // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category of Training'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddCategoryDialog(
                        save: (
                          categoryName,
                          workoutList,
                          timeController,
                          selectedEnergyLevel,
                          bool isEditing,
                          String oldCategoryName,
                        ) {
                          _saveToFirebase(
                            categoryName,
                            workoutList,
                            timeController,
                            selectedEnergyLevel,
                            isEditing: isEditing,
                            oldCategoryName: oldCategoryName,
                          );
                          Navigator.pop(context);
                        },
                        pickImage: () async {
                          ImagePicker();
                        },
                        selectimg: _selectedImage,
                        categoryName: categoryNameController,
                        timeController: timeController,
                        workoutList: workoutListController,
                        selectedEnergyLevel: selectedEnergyLevel,
                      );
                    });
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              homePageCategory(
                  text: 'High',
                  ontap: () {
                    setState(() {
                      selectedEnergyLevel = 'High';
                    });
                  }),
              homePageCategory(
                  text: 'Low',
                  ontap: () {
                    setState(() {
                      selectedEnergyLevel = 'Low';
                    });
                  }),
              homePageCategory(
                  text: 'Medium',
                  ontap: () {
                    setState(() {
                      selectedEnergyLevel = 'Medium';
                    });
                  }),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('WorkoutList')
                  .doc(selectedEnergyLevel) // Use selected dropdown value here
                  .collection('List')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ListView.separated(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final category =
                          documents[index].data() as Map<String, dynamic>;
                      final categoryName = category['categoryName'];
                      final workoutList = category['workoutList'];
                      final workoutTime = category['workoutTime'];
                      final energyLevel = category['selectedEnergyLevel'];
                      final listPhotoBase64 = category['listPhoto'];

                      return workoutCard(
                        imgBase64: listPhotoBase64 ?? '',
                        workoutList: workoutList ?? '',
                        workoutTime: workoutTime ?? '',
                        ontap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkoutSubList(
                                        energyLevel: selectedEnergyLevel,
                                        workoutName: categoryName,
                                      )));
                        },
                        context: context,
                        categoryName: categoryName ?? '',
                        delete: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text(
                                    'Are you sure you want to delete this category?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteCategory(categoryName,
                                          selectedEnergyLevel); // Pass selectedEnergyLevel
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        edit: () {
                          _editCategory(
                            categoryName ?? '',
                            workoutList ?? '',
                            workoutTime ?? '',
                            energyLevel ?? '',
                            listPhotoBase64,
                            selectedEnergyLevel, // Pass selectedEnergyLevel
                            isEditing: true, // Add this line
                            oldCategoryName: categoryName, // Add this line
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 8.0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  imagePicker() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    String filename = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('workoutSubList');
    Reference referenceDirImagtoupload = referenceDirImage.child(filename);
    try {
      await referenceDirImagtoupload.putFile(File(file.path));
      mainImage = await referenceDirImagtoupload.getDownloadURL();
      setState(() {
        _selectedImage = mainImage;
      });
      if (mainImage.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No Image Selected')));
      }
    } catch (e) {
      print('Some Error Happened ?');
    }
  }

  Future<void> _saveToFirebase(
      TextEditingController? categoryName,
      TextEditingController? workoutList,
      TextEditingController? timeController,
      String selectedEnergyLevel,
      {required bool isEditing,
      required String oldCategoryName}) async {
    final CollectionReference categoriesRef = FirebaseFirestore.instance
        .collection('WorkoutList')
        .doc(selectedEnergyLevel) // Use selected dropdown value here
        .collection('List');

    try {
      String categoryNameText = categoryName?.text ?? '';
      String workoutListText = workoutList?.text ?? '';
      String timeText = timeController?.text ?? '';

      // Check if any of the fields are empty
      if (categoryNameText.isEmpty ||
          workoutListText.isEmpty ||
          timeText.isEmpty) {
        // Show an error message or handle the empty fields as needed
        print('All fields are required');
        return;
      }

      // Check if a document with the same category name already exists
      var querySnapshot = await categoriesRef
          .where('categoryName', isEqualTo: categoryNameText)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a document with the same category name exists, update it
        var docId = querySnapshot.docs.first.id;
        await categoriesRef.doc(docId).update({
          'workoutList': workoutListText,
          'workoutTime': timeText,
          'selectedEnergyLevel': selectedEnergyLevel,
          // Update other fields if needed
        });
        print('Document updated with ID: $docId');
      } else {
        await categoriesRef.doc(categoryNameText).set({
          'categoryName': categoryNameText,
          'workoutList': workoutListText,
          'workoutTime': timeText,
          'selectedEnergyLevel': selectedEnergyLevel,
          'listPhoto': mainImage,
          // Add the base64 string of the image
          // Add other fields if needed
        });
        print('New document created with categoryName: $categoryNameText');
      }

      // Show a success message or perform any other actions after saving
      print('Data saved to Firestore successfully!');

      categoryName?.clear();
      workoutList?.clear();
      timeController?.clear();

      setState(() {
        mainImage.remove();
      });
    } catch (error) {
      print('Error saving data to Firestore: $error');
    }
  }

// _________________________________edit_the_data_______________________________
  void _editCategory(String categoryName, String workoutList, String time,
      String energyLevel, String? listPhotoBase64, String selectedEnergyLevel,
      {bool? isEditing, String? oldCategoryName}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryDialog(
          save: (TextEditingController? categoryNameController,
              TextEditingController? workoutListController,
              TextEditingController? timeController,
              String selectedEnergyLevel,
              bool isEditing,
              String oldCategoryName,
              String? updatedImage) {
            _saveToFirebase(
              categoryNameController,
              workoutListController,
              timeController,
              selectedEnergyLevel,
              isEditing: isEditing,
              oldCategoryName: oldCategoryName,
            );
            Navigator.pop(context);
          },
          selectimg: listPhotoBase64,
          categoryName: TextEditingController(text: categoryName),
          workoutList: TextEditingController(text: workoutList),
          timeController: TextEditingController(text: time),
          selectedEnergyLevel: selectedEnergyLevel,
          isEditing: true,
          oldCategoryName: oldCategoryName,
        );
      },
    );
  }

  // _____________________________________delete_from_firebase__________________
  void _deleteCategory(String categoryName, String selectedEnergyLevel) async {
    try {
      await FirebaseFirestore.instance
          .collection('WorkoutList')
          .doc(selectedEnergyLevel) // Use selected dropdown value here
          .collection('List')
          .doc(categoryName)
          .delete();
      print('Document deleted: $categoryName');
    } catch (error) {
      print('Error deleting document: $error');
    }
  }
}
