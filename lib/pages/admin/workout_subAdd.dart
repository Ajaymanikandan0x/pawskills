import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import 'admin_functions/petImg.dart';

class NewWorkout extends StatefulWidget {
  const NewWorkout({Key? key}) : super(key: key);

  @override
  _NewWorkoutState createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  String? _selectedImage;
  final workoutNameController = TextEditingController();
  final detailsController = TextEditingController();
  final timeController = TextEditingController();
  bool s1 = false, s2 = false, s3 = false;
  String selectedCategory = '';
  List<String> dropdownValues = [];
  String? selectedValue;
  late String MainImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              workoutImg(
                text: "add a img",
                onTap: () async {
                  imagepicker();
                  // setState(() {
                  //   _selectedImage = MainImage;
                  // });
                },
                selectedImage: _selectedImage,
              ),
              const SizedBox(height: 20),
              Text('Workout name', style: textStyle),
              const SizedBox(height: 10),
              nameField(controller: workoutNameController),
              const SizedBox(height: 20),
              Text(
                'Details',
                style: textStyle,
              ),
              const SizedBox(height: 10),
              nameField(controller: detailsController, maxLines: null),
              const SizedBox(height: 20),
              Text(
                'Time',
                style: textStyle,
              ),
              const SizedBox(height: 10),
              nameField(controller: timeController),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildSwitch('High', s1),
                    buildSwitch('Medium', s2),
                    buildSwitch('Low', s3),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Selected Category: $selectedCategory',
                style: textStyle,
              ),
              dropDownList(selectedCategory),
              button(
                  text: 'Save',
                  ontap: () async {
                    await saveWorkout();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSwitch(String label, bool value) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 8),
        Switch(
          value: value,
          activeColor: Colors.green,
          onChanged: (bool newValue) {
            setState(() {
              s1 = label == 'High' ? newValue : false;
              s2 = label == 'Medium' ? newValue : false;
              s3 = label == 'Low' ? newValue : false;
              if (newValue) {
                selectedCategory = label;
              } else {
                selectedCategory = '';
              }
              // Fetch and update the dropdownValues list based on the selected category
              if (selectedCategory.isNotEmpty) {
                FirebaseFirestore.instance
                    .collection('WorkoutList')
                    .doc(selectedCategory)
                    .collection('List')
                    .get()
                    .then((snapshot) {
                  if (snapshot.docs.isNotEmpty) {
                    setState(() {
                      dropdownValues =
                          snapshot.docs.map((doc) => doc.id).toList();
                      // Update the selectedValue if necessary
                      selectedValue = dropdownValues.isNotEmpty
                          ? dropdownValues.first
                          : null;
                    });
                  }
                });
              } else {
                // If no category is selected, clear the dropdownValues list
                setState(() {
                  dropdownValues.clear();
                  selectedValue = null;
                });
              }
            });
          },
        ),
      ],
    );
  }

  TextStyle textStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  imagepicker() async {
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
      MainImage = await referenceDirImagtoupload.getDownloadURL();
      setState(() {
        _selectedImage = MainImage;
      });
      if (MainImage.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No Image Selected')));
      }
    } catch (e) {
      print('Some Error Happened ?');
    }
  }

  Widget workoutImg({
    required void Function() onTap,
    required String text,
    String? selectedImage,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          width: 170,
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
          child: selectedImage != null
              ? Image.network(
                  selectedImage,
                  fit: BoxFit.cover,
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ), // Placeholder icon
                ),
        ),
      );

  Widget dropDownList(String? category) {
    if (category == null || category.isEmpty) {
      return const Center(child: Text('Category is empty'));
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('WorkoutList')
          .doc(category)
          .collection('List')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        dropdownValues =
            documents.map<String>((doc) => doc.id).toSet().toList();

        if (dropdownValues.isEmpty) {
          selectedValue = null;
        } else {
          selectedValue = selectedValue ?? dropdownValues.first;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: selectedValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue ?? '';
                print(selectedValue);
              });
            },
            items: dropdownValues.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> saveWorkout() async {
    // Get data from controllers
    String workoutName = workoutNameController.text;
    String details = detailsController.text;
    String time = timeController.text;
    String? imgPath = MainImage; // Retrieve image path

    // Use the selected dropdown value as the document ID
    String selectedValue =
        dropdownValues.isNotEmpty ? dropdownValues.first : '';
    if (selectedValue.isEmpty) {
      print('No selected category.');
      return;
    }

    // Save data to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('WorkoutList')
          .doc(selectedCategory) // Use selected category as parent document ID
          .collection('List')
          .doc(selectedValue) // Use selected dropdown value as the document ID
          .collection('subList')
          .doc(workoutName)
          .set({
        'workoutName': workoutName,
        'details': details,
        'time': time,
        'img': imgPath, // Store image path if available
      });

      print('Workout saved successfully');
    } catch (e) {
      // Handle error
      print('Error saving workout: $e');
    }
  }
}
