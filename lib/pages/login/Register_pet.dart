import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'functions/Functions.dart';
import 'functions/formfield.dart';

class RegPet extends StatefulWidget {
  const RegPet({super.key});

  @override
  State<RegPet> createState() => _RegPetState();
}

class _RegPetState extends State<RegPet> {
  String dropdownTitle = '  Choose Gender';
  String? selectedGender;
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final energyLevelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 250,
                  width: 400,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Image.asset('assets/img/photos/petlogo.png',
                      fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Complete your pet details with us',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
                ),
                const SizedBox(height: 10),
                Text(
                  'It will help us to know more about !',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[700]),
                ),
                const SizedBox(height: 25),
                form_field(
                    Hint_text: 'Energy Level',
                    inputIcon: const Icon(Icons.upgrade_outlined),
                    controller: energyLevelController),
                form_field(
                    Hint_text: 'Age',
                    inputIcon: const Icon(Icons.timelapse),
                    controller: ageController),
                const SizedBox(height: 10),
                pet_bmi(
                    Hint_text: 'Weight',
                    inputIcon: const Icon(Icons.monitor_weight_outlined),
                    controller: heightController,
                    hi_wi: 'KG'),
                const SizedBox(height: 10),
                pet_bmi(
                    Hint_text: 'Height',
                    inputIcon: const Icon(Icons.height),
                    controller: weightController,
                    hi_wi: 'CM'),
                const SizedBox(height: 20),
                button(
                    text: 'Next >',
                    //add pet scrolling screen rout name
                    ontap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/skip', (route) => false);
                    },
                    //production  simplicity
                    // _savePetInfo,
                    width: 400,
                    height: 65)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _savePetInfo() {
    // Access Firestore collection and add data
    FirebaseFirestore.instance.collection('petbasicinfo').add({
      'gender': selectedGender,
      'age': ageController.text,
      'weight': weightController.text,
      'height': heightController.text,
    }).then((_) {
      // If data is successfully added, navigate to next screen
      Navigator.pushNamedAndRemoveUntil(context, '/skip', (route) => false);
    }).catchError((e) {
      // Handle errors if any
      print('Error saving pet info: $e');
    });
  }
}
