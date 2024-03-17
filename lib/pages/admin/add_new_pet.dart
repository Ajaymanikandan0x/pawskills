import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import 'package:pawskills/pages/login/functions/formfield.dart';
import 'admin_functions/petImg.dart';

class AddNewPet extends StatefulWidget {
  final String? petName;
  final String? petDetails;
  final String? lifeExpectancy;
  final String? selectedEnergyLevel;
  final String? listPhoto;
  final String? detailsPhoto;
  final String? avgheight;
  final String? avgweight;

  const AddNewPet(
      {Key? key,
      this.petName,
      this.petDetails,
      this.lifeExpectancy,
      this.selectedEnergyLevel,
      this.listPhoto,
      this.detailsPhoto,
      this.avgheight,
      this.avgweight})
      : super(key: key);

  @override
  State<AddNewPet> createState() => _AddBewPetState();
}

class _AddBewPetState extends State<AddNewPet> {
  final petNameController = TextEditingController();
  final petDetailsController = TextEditingController();
  final temperamentController = TextEditingController();
  final avgHeightController = TextEditingController();
  final avgWeightController = TextEditingController();
  String? selectedEnergyLevel;

  String? listPhoto;
  String? detailsPhoto;

  @override
  void initState() {
    super.initState();
    if (widget.petName != null) {
      petNameController.text = widget.petName!;
    }
    if (widget.petDetails != null) {
      petDetailsController.text = widget.petDetails!;
    }
    if (widget.lifeExpectancy != null) {
      temperamentController.text = widget.lifeExpectancy!;
    }
    if (widget.selectedEnergyLevel != null) {
      selectedEnergyLevel = widget.selectedEnergyLevel!;
    }
    if (widget.avgweight != null) {
      avgWeightController.text = widget.avgweight!;
    }
    if (widget.avgheight != null) {
      avgHeightController.text = widget.avgheight!;
    }
    listPhoto = widget.listPhoto;
    detailsPhoto = widget.detailsPhoto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    petImg(
                        text: 'list-photo',
                        selectimg: listPhoto,
                        ontap: () async {
                          _getImage(isListPhoto: true);
                        }),
                    const SizedBox(width: 8),
                    petImg(
                        text: 'Details-photo',
                        selectimg: detailsPhoto,
                        ontap: () async {
                          _getImage(isListPhoto: false);
                        })
                  ],
                ),
                const SizedBox(height: 15),
                _text(
                  'Name',
                ),
                const SizedBox(height: 7),
                nameField(
                  hintText: 'Pet name',
                  controller: petNameController,
                ),
                const SizedBox(height: 15),
                _text(
                  'Details',
                ),
                const SizedBox(height: 10),
                nameField(
                    maxLines: null,
                    controller: petDetailsController,
                    hintText: 'Details'),
                const SizedBox(height: 15),
                _text(
                  'Select the value',
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
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
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 22,
                                color: value == 'Select'
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        elevation: 8,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                        isExpanded: true,
                        dropdownColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                form_field(
                    Hint_text: 'Life Expectancy',
                    inputIcon: const Icon(Icons.timelapse),
                    controller: temperamentController),
                const SizedBox(height: 10),
                pet_bmi(
                    Hint_text: 'AVG Weight',
                    inputIcon: const Icon(Icons.monitor_weight_outlined),
                    controller: avgHeightController,
                    hi_wi: 'KG'),
                const SizedBox(height: 10),
                pet_bmi(
                    Hint_text: 'AVG Height',
                    inputIcon: const Icon(Icons.height),
                    controller: avgWeightController,
                    hi_wi: 'CM'),
                const SizedBox(height: 20),
                button(
                    text: 'Save',
                    ontap: () async {
                      await _uploadPetDetailsToFirebase();
                    },
                    width: 350)
              ],
            ),
          )),
    );
  }

  // _____________________take_img_in_localStorage______________________________

  void _getImage({required bool isListPhoto}) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    String filename = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('Pet_breed_imgg');
    Reference referenceDirImagtoupload = referenceDirImage.child(filename);
    try {
      await referenceDirImagtoupload.putFile(File(file.path));
      String uploadedImageUrl = await referenceDirImagtoupload.getDownloadURL();

      setState(() {
        if (isListPhoto) {
          listPhoto = uploadedImageUrl;
        } else {
          detailsPhoto = uploadedImageUrl;
        }
      });
      if (uploadedImageUrl.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No Image Selected')));
      }
    } catch (e) {
      print('Some Error Happened ? $e');
    }
  }

  Widget _text(String text) => Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)));

  // ____________________________save_Firebase__________________________________

  Future<void> _uploadPetDetailsToFirebase() async {
    final databaseRef = FirebaseFirestore.instance;
    final dogCollectionRef = databaseRef.collection('categories').doc('Dog');
    final petsCollectionRef = dogCollectionRef.collection('List');

    // Store data in a Map
    final petData = {
      'petName': petNameController.text,
      'petDetails': petDetailsController.text,
      'life_expectancy': temperamentController.text,
      'weight': avgWeightController.text,
      'height': avgHeightController.text,
      'energyLevel': selectedEnergyLevel,
      'listPhoto': listPhoto, // Store both image base64 strings
      'detailsPhoto': detailsPhoto, // Store image as base64 string
    };

    try {
      // Check if the pet already exists
      final existingPetDoc =
          await petsCollectionRef.doc(petNameController.text).get();
      if (existingPetDoc.exists) {
        // Update the existing document
        await petsCollectionRef.doc(petNameController.text).update(petData);
      } else {
        // Create a new document
        await petsCollectionRef.doc(petNameController.text).set(petData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet details saved successfully!'),
        ),
      );

      // Clear form fields
      petNameController.clear();
      petDetailsController.clear();
      temperamentController.clear();
      avgWeightController.clear();
      avgHeightController.clear();

      setState(() {
        selectedEnergyLevel = '';
        listPhoto = '';
        detailsPhoto = '';
      });
    } catch (error) {
      print('Error saving pet details to Firebase: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }
}
