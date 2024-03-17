import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import 'package:pawskills/pages/login/functions/formfield.dart';
import '../admin/admin_functions/petImg.dart';
import 'functions/hive/user_hive.dart';
import 'functions/main_functios_user.dart';

class UserPet extends StatefulWidget {
  const UserPet({super.key});

  @override
  State<UserPet> createState() => _UserPetState();
}

class _UserPetState extends State<UserPet> {
  final petNameController = TextEditingController();
  final petDetailsController = TextEditingController();
  final genderController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final energyLevelController = TextEditingController();

  File? listPhoto;
  File? detailsPhoto;

  String? listPhotoBase64;
  String? detailsPhotoBase64;

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
                    usrPetImg(
                        text: 'list-photo',
                        selectimg: listPhotoBase64,
                        ontap: () async {
                          await _getImage(context: context, forListPhoto: true);
                        }),
                    const SizedBox(width: 8),
                    usrPetImg(
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
                    Hint_text: 'Gender',
                    inputIcon: const Icon(Icons.timelapse),
                    controller: genderController),
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
                      await _savePetData();
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

  // __________________________save_data___________________________________________
  Future<void> _savePetData() async {
    try {
      // Save data to Firebase
      await _uploadPetDetailsToFirebase();

      // Save data to Hive
      await _saveDataToHive();
      Navigator.pop(context);
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet details saved successfully!'),
        ),
      );

      // Clear form fields
      petNameController.clear();
      petDetailsController.clear();
      genderController.clear();
      weightController.clear();
      heightController.clear();
      energyLevelController.clear();
      setState(() {
        listPhotoBase64 = null;
        detailsPhotoBase64 = null;
      });
    } catch (error) {
      // Handle errors
      print('Error saving pet details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  // ____________________________save_Firebase__________________________________

  Future<void> _uploadPetDetailsToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated.');
      throw Exception('User is not authenticated.');
    }
    final databaseRef = FirebaseFirestore.instance;
    final userId = user.uid;
    final userPetsCollectionRef = databaseRef
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc('user_pet')
        .collection('List');

    // Store data in a Map
    final petData = {
      'petName': petNameController.text,
      'petDetails': petDetailsController.text,
      'gender': genderController.text,
      'weight': weightController.text,
      'height': heightController.text,
      'energyLevel': energyLevelController.text,
      'listPhoto': listPhotoBase64,
      'detailsPhoto': detailsPhotoBase64,
    };
    final docRef = await userPetsCollectionRef.add(petData);
    final petId = docRef.id;
    await docRef.update({'petName': petId});
  }

  // Function to save pet data into Hive
  Future<void> _saveDataToHive() async {
    // Initialize Hive and get the application documents directory
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register adapter for PetData class
    if (!Hive.isAdapterRegistered(2)) {
      // Register adapter for PetData class
      Hive.registerAdapter(PetDataAdapter());
    }

    // Open a Hive box
    final box = await Hive.openBox<PetData>('user_pets');

    // Create a new PetData object
    final petData = PetData(
      petName: petNameController.text,
      petDetails: petDetailsController.text,
      gender: genderController.text,
      weight: weightController.text,
      height: heightController.text,
      energyLevel: energyLevelController.text,
      listPhotoBase64: listPhotoBase64,
      detailsPhotoBase64: detailsPhotoBase64,
    );

    // Save the pet data into the Hive box
    await box.add(petData);
  }
}
