import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import '../admin_functions/petImg.dart';

class NewWorkout extends StatefulWidget {
  final String? workoutName;
  final String? workoutDetails;
  final String? workoutTime;
  final String? workoutImgUrl;
  final String? category;
  final String? workoutList;

  const NewWorkout(
      {this.workoutName,
      this.workoutDetails,
      this.workoutImgUrl,
      this.workoutTime,
      this.category,
      this.workoutList,
      Key? key})
      : super(key: key);

  @override
  _NewWorkoutState createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  String? _selectedImage;
  late TextEditingController workoutNameController;
  late TextEditingController detailsController;
  late TextEditingController timeController;

  bool s1 = false, s2 = false, s3 = false;
  String selectedCategory = '';
  List<String> dropdownValues = [];
  String? selectedValue;
  late String mainImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    workoutNameController = TextEditingController(text: widget.workoutName);
    detailsController = TextEditingController(text: widget.workoutDetails);
    timeController = TextEditingController(text: widget.workoutTime);
    _selectedImage = widget.workoutImgUrl;
    selectedCategory = widget.category ?? '';
    updateDropdownValues(selectedCategory);
    if (widget.category == 'High') {
      s1 = true;
    } else if (widget.category == 'Medium') {
      s2 = true;
    } else if (widget.category == 'Low') {
      s3 = true;
    }
  }

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
                text: "add an img",
                onTap: () async {
                  imagepicker();
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

  void updateDropdownValues(String category) {
    if (category.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('WorkoutList')
          .doc(category)
          .collection('List')
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            dropdownValues = snapshot.docs.map((doc) => doc.id).toList();
            selectedValue =
                dropdownValues.isNotEmpty ? dropdownValues.first : null;
          });
        }
      });
    } else {
      setState(() {
        dropdownValues.clear();
        selectedValue = null;
      });
    }
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
              if (label == 'High') {
                s1 = newValue;
                if (newValue) {
                  selectedCategory = 'High';
                  s2 = false;
                  s3 = false;
                } else if (!s2 && !s3) {
                  selectedCategory = '';
                }
              } else if (label == 'Medium') {
                s2 = newValue;
                if (newValue) {
                  selectedCategory = 'Medium';
                  s1 = false;
                  s3 = false;
                } else if (!s1 && !s3) {
                  selectedCategory = '';
                }
              } else if (label == 'Low') {
                s3 = newValue;
                if (newValue) {
                  selectedCategory = 'Low';
                  s1 = false;
                  s2 = false;
                } else if (!s1 && !s2) {
                  selectedCategory = '';
                }
              }
              // Update the dropdownValues list based on the selected category
              updateDropdownValues(selectedCategory);
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
    String? imgPath = _selectedImage;
    String? category = selectedCategory;
    String? selectedList = dropdownValues.first.toString();

    // Use the selected dropdown value as the document ID
    String selectedValue =
        dropdownValues.isNotEmpty ? dropdownValues.first : '';
    if (selectedValue.isEmpty) {
      print('No selected category.');
      return;
    }

    // Save data to Firestore
    final databaseRef = FirebaseFirestore.instance;
    final workoutCollectionRef = databaseRef
        .collection('WorkoutList')
        .doc(selectedCategory)
        .collection('List')
        .doc(selectedValue);
    final workoutCollection =
        workoutCollectionRef.collection('subList').doc(workoutName);

    final workoutData = {
      'workoutName': workoutName,
      'details': details,
      'time': time,
      'img': imgPath,
      'category': category,
      'selectedList': selectedList
    };

    try {
      // Check if the workout already exists
      final existingWorkDoc = await workoutCollection.get();
      if (existingWorkDoc.exists) {
        // Update the existing document
        await workoutCollection.update(workoutData);
      } else {
        // Create a new document
        await workoutCollection.set(workoutData);
      }
      workoutNameController.clear();
      detailsController.clear();
      timeController.clear();
      setState(() {
        _selectedImage = '';
        selectedCategory = '';
        dropdownValues.clear();
        selectedValue = '';
        s1 = false;
        s2 = false;
        s3 = false;
      });

      print('Workout saved successfully');
    } catch (e) {
      // Handle error
      print('Error saving workout: $e');
    }
  }
}
