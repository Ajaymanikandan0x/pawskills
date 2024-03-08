import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawskills/pages/admin/admin_functions/petImg.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';

import '../admin_function.dart';

class AddCategoryDialog extends StatefulWidget {
  final String? workoutList;
  final String? time;
  final String? categoryName;
  final bool? isEditing;
  final String? oldCategoryName;
  final String? selectedEnergyLevel;
  final String? listPhoto;

  const AddCategoryDialog(
      {Key? key,
      this.workoutList,
      this.time,
      this.categoryName,
      this.isEditing,
      this.oldCategoryName,
      this.selectedEnergyLevel,
      this.listPhoto})
      : super(key: key);

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  String? selectedEnergyLevel;
  String? _selectedImage;
  late String mainImage;
  final categoryName = TextEditingController();
  final workoutList = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.listPhoto ?? '';
    categoryName.text = widget.categoryName ?? '';
    workoutList.text = widget.workoutList ?? '';
    timeController.text = widget.time ?? '';
    selectedEnergyLevel = widget.selectedEnergyLevel;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Add Category')),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: petImg(
                text: 'add image',
                selectimg: _selectedImage,
                ontap: () async {
                  getImage();
                },
              ),
            ),
            const SizedBox(height: 20),
            nameField(
              controller: categoryName,
              hintText: 'Category Name',
            ),
            const SizedBox(height: 10),
            nameField(
              controller: workoutList,
              hintText: 'Workout List',
            ),
            const SizedBox(height: 10),
            nameField(
              hintText: 'Workout Time',
              controller: timeController,
            ),
            const SizedBox(height: 20),
            Center(
              child: DropdownButton<String>(
                value: selectedEnergyLevel,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedEnergyLevel = newValue;
                    });
                  }
                },
                items: <String>['High', 'Medium', 'Low']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Center(
                child: button(
                    text: 'save',
                    ontap: () {
                      _saveToFirebase(context);
                    })),
          ],
        ),
      ),
    );
  }

  void getImage() async {
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
      print('Some Error Happened ? $e');
    }
  }

  Future<void> _saveToFirebase(BuildContext context) async {
    final CollectionReference categoriesRef = FirebaseFirestore.instance
        .collection('WorkoutList')
        .doc(selectedEnergyLevel) // Use selected dropdown value here
        .collection('List');

    try {
      String categoryNameText = categoryName.text;
      String workoutListText = workoutList.text;
      String timeText = timeController.text;

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
          'listPhoto': _selectedImage,
        });
        print('Document updated with ID: $docId');
      } else {
        await categoriesRef.doc(categoryNameText).set({
          'categoryName': categoryNameText,
          'workoutList': workoutListText,
          'workoutTime': timeText,
          'selectedEnergyLevel': selectedEnergyLevel,
          'listPhoto': _selectedImage,
        });
        print('New document created with categoryName: $categoryNameText');
      }

      // Show a success message or perform any other actions after saving
      print('Data saved to Firestore successfully!');

      categoryName.clear();
      workoutList.clear();
      timeController.clear();

      if (_selectedImage != widget.listPhoto) {
        setState(() {
          _selectedImage = '';
        });
      }
    } catch (error) {
      print('Error saving data to Firestore: $error');
    }
  }
}

// _____________________________________training_category_list__________________

Widget workoutCard({
  String? categoryImg,
  required String categoryName,
  required String workoutList,
  required String workoutTime,
  required void Function()? ontap,
  required BuildContext context,
  required void Function()? delete,
  required void Function()? edit,
}) {
  return InkWell(
    onTap: ontap,
    child: Card(
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 70,
              width: 70,
              child: categoryImg != null
                  ? CachedNetworkImage(
                      imageUrl: categoryImg,
                      fit: BoxFit.cover,
                    )
                  : const Placeholder(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    categoryName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        workoutList,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        workoutTime,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                editButton(width: 35, height: 35, ontap: edit, icon_size: 18),
                SizedBox(height: 5),
                deleteButton(
                    width: 35, height: 35, ontap: delete, icon_size: 18),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
// _______________________level_________________________________________________
