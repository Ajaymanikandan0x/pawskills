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
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final List<TextEditingController> vaccineNameControllerList = [];
  final List<TextEditingController> vaccineTimeControllerList = [];

  final List<Map<String, String>> vaccinations = [];

  File? listPhoto;
  File? detailsPhoto;

  String? listPhotoBase64;
  String? detailsPhotoBase64;
  String? selectedEnergyLevel;
  String? selectGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0, // Remove appbar shadow
      ),
      backgroundColor: Colors.grey[100], // Set background color for the body
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: usrPetImg(
                      text: 'List Photo',
                      selectimg: listPhotoBase64,
                      ontap: () async {
                        await _getImage(context: context, forListPhoto: true);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Add some spacing between the widgets
                  Expanded(
                    child: usrPetImg(
                      text: 'Details Photo',
                      selectimg: detailsPhotoBase64,
                      ontap: () async {
                        await _getImage(context: context, forListPhoto: false);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Add spacing between the rows
              _text('Name'),
              const SizedBox(height: 7),
              nameField(
                hintText: 'Pet Name',
                controller: petNameController,
              ),
              const SizedBox(height: 20),
              _text('Details'),
              const SizedBox(height: 10),
              nameField(
                maxLines: null,
                controller: petDetailsController,
                hintText: 'Details',
              ),
              const SizedBox(height: 20),
              _text('Complete Profile'),
              const SizedBox(height: 25),
              _buildDropdownButton(
                hintText: 'Energy Level',
                value: selectedEnergyLevel,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedEnergyLevel = newValue;
                    });
                  }
                },
                items: ['High', 'Medium', 'Low']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: value == selectedEnergyLevel
                            ? Colors.black // Change color for selected item
                            : Colors.grey, // Change color for unselected item
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              _buildDropdownButton(
                hintText: 'Gender',
                value: selectGender,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectGender = newValue;
                    });
                  }
                },
                items: ['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: value == selectGender
                            ? Colors.black // Change color for selected item
                            : Colors.grey, // Change color for unselected item
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _text('Vaccinations'),

              ListView.builder(
                shrinkWrap: true,
                itemCount: vaccinations.length,
                itemBuilder: (context, index) {
                  return _buildVaccinationRow(index);
                },
              ),

              TextButton(
                onPressed: _addVaccination,
                child: const Text('Add Vaccination'),
              ),
              const SizedBox(height: 10),
              pet_bmi(
                Hint_text: 'AVG Weight',
                inputIcon: const Icon(Icons.monitor_weight_outlined),
                controller: heightController,
                hi_wi: 'KG',
              ),
              const SizedBox(height: 10),
              pet_bmi(
                Hint_text: 'AVG Height',
                inputIcon: const Icon(Icons.height),
                controller: weightController,
                hi_wi: 'CM',
              ),
              const SizedBox(height: 30),
              button(
                text: 'Save',
                ontap: () async {
                  await _savePetData();
                },
                width: MediaQuery.of(context).size.width *
                    0.8, // Button width set to 80% of screen width
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVaccinationRow(int index) {
    TextEditingController vaccineNameController =
        vaccineNameControllerList[index];
    TextEditingController vaccineTimeController =
        vaccineTimeControllerList[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        nameField(
          hintText: 'Vaccination Name',
          controller: vaccineNameController,
        ),
        const SizedBox(height: 10),
        nameField(
          hintText: 'Time Period',
          controller: vaccineTimeController,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _addVaccination() {
    setState(() {
      vaccinations.add({
        'name': '', // Initially empty strings
        'timePeriod': '',
      });
      vaccineNameControllerList.add(TextEditingController());
      vaccineTimeControllerList.add(TextEditingController());
    });
  }

  Widget _buildDropdownButton({
    required String hintText,
    required String? value,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 8,
          style: const TextStyle(fontSize: 16, color: Colors.black),
          isExpanded: true,
          dropdownColor: Colors.white,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              hintText,
              style: TextStyle(
                fontSize: 16,
                color: value == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ),
      ),
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
      weightController.clear();
      heightController.clear();
      vaccinations.clear();

      setState(() {
        selectGender = '';
        selectedEnergyLevel = '';
        listPhotoBase64 = null;
        detailsPhotoBase64 = null;
      });
    } catch (error) {
      // Handle errors
      print('Error saving pet details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'An error ocuser_profile_datacurred. Please try again later.'),
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
      'gender': selectGender,
      'weight': weightController.text,
      'height': heightController.text,
      'energyLevel': selectedEnergyLevel,
      'listPhoto': listPhotoBase64,
      'detailsPhoto': detailsPhotoBase64,
      'vaccinations': vaccinations.isNotEmpty
          ? vaccinations.asMap().entries.map((entry) {
              final index = entry.key;
              final vaccineName = vaccineNameControllerList[index].text;
              final vaccineTimePeriod = vaccineTimeControllerList[index].text;
              return {'name': vaccineName, 'timePeriod': vaccineTimePeriod};
            }).toList()
          : null,
    };

    // Use petName as the document ID
    final petName = petNameController.text;
    final docRef = userPetsCollectionRef.doc(petName);

    // Check if pet already exists
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      // Pet with the same name already exists, update its details
      await docRef.update(petData);
    } else {
      // Pet does not exist, add it to the collection
      await docRef.set(petData);
    }

    await userPetsCollectionRef.doc(petName).set(petData);
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

    final box = await Hive.openBox<PetData>('user_pets');

    // Create a new PetData object
    final petData = PetData(
      petName: petNameController.text,
      petDetails: petDetailsController.text,
      gender: selectGender ?? '',
      weight: weightController.text,
      height: heightController.text,
      energyLevel: selectedEnergyLevel ?? '',
      listPhotoBase64: listPhotoBase64,
      detailsPhotoBase64: detailsPhotoBase64,
      vaccinations: vaccinations.isNotEmpty
          ? vaccinations.asMap().entries.map((entry) {
              final index = entry.key;
              final vaccineName = vaccineNameControllerList[index].text;
              final vaccineTimePeriod = vaccineTimeControllerList[index].text;
              return {'name': vaccineName, 'timePeriod': vaccineTimePeriod};
            }).toList()
          : [],
    );

    await box.add(petData);
  }
}
