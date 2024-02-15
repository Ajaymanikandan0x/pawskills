import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import 'package:pawskills/pages/login/functions/formfield.dart';
import 'admin_functions/petImg.dart';

class AddNewPet extends StatefulWidget {
  const AddNewPet({super.key});

  @override
  State<AddNewPet> createState() => _AddBewPetState();
}

class _AddBewPetState extends State<AddNewPet> {
  final petNameController = TextEditingController();
  final petDetailsController = TextEditingController();
  final temperamentController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final energyLevelController = TextEditingController();

  File? listPhoto; // Image for the list-photo field
  File? detailsPhoto; // Image for the Details-photo field

  String? listPhotoBase64; // Base64 string for the list-photo field
  String? detailsPhotoBase64; // Base64 string for the Details-photo field

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
                        selectimg: listPhotoBase64,
                        ontap: () async {
                          await _getImage(context: context, forListPhoto: true);
                        }),
                    const SizedBox(width: 8),
                    petImg(
                        text: 'Details-photo',
                        selectimg: detailsPhotoBase64,
                        ontap: () async {
                          await _getImage(
                              context: context, forListPhoto: false);
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
                  'Complete Profile',
                ),
                const SizedBox(height: 25),
                form_field(
                    Hint_text: 'Energy Level',
                    controller: energyLevelController,
                    inputIcon: const Icon(Icons.upgrade_outlined)),
                const SizedBox(height: 10),
                form_field(
                    Hint_text: 'Life Expectancy',
                    inputIcon: const Icon(Icons.timelapse),
                    controller: temperamentController),
                const SizedBox(height: 10),
                pet_bmi(
                    Hint_text: 'AVG Weight',
                    inputIcon: const Icon(Icons.monitor_weight_outlined),
                    controller: heightController,
                    hi_wi: 'KG'),
                const SizedBox(height: 10),
                pet_bmi(
                    Hint_text: 'AVG Height',
                    inputIcon: const Icon(Icons.height),
                    controller: weightController,
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

  Future<void> _getImage(
      {required bool forListPhoto, required BuildContext context}) async {
    try {
      final picker = ImagePicker();
      final XFile? imageselect =
          await picker.pickImage(source: ImageSource.gallery);

      if (imageselect == null) {
        return; // Handle image selection cancellation gracefully
      }

      Uint8List imageBytes = await imageselect.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        if (forListPhoto) {
          listPhoto = File(imageselect.path);
          listPhotoBase64 = base64Image;
        } else {
          detailsPhoto = File(imageselect.path);
          detailsPhotoBase64 = base64Image;
        }
      });
    } catch (error) {
      print("Error picking image: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while selecting an image.'),
        ),
      );
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
      'weight': weightController.text,
      'height': heightController.text,
      'energyLevel': energyLevelController.text,
      'listPhoto': listPhotoBase64, // Store both image base64 strings
      'detailsPhoto': detailsPhotoBase64, // Store image as base64 string
    };

    try {
      // Use doc method to create a new document with custom ID (pet name)
      await petsCollectionRef.doc(petNameController.text).set(petData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet details saved successfully!'),
        ),
      );

      // Clear form fields
      petNameController.clear();
      petDetailsController.clear();
      temperamentController.clear();
      weightController.clear();
      heightController.clear();
      energyLevelController.clear();
      setState(() {
        listPhotoBase64 = null;
        detailsPhotoBase64 = null;
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
