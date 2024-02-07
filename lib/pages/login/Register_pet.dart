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

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> list = [
      const DropdownMenuItem(
        value: 'Male',
        child: Text('Male'),
      ),
      const DropdownMenuItem(
        value: 'Female',
        child: Text('Female'),
      ),
    ];
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
                  'Let’s complete pet profile',
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
                ListTile(
                  leading: const Icon(Icons.pets),
                  title: Text(dropdownTitle), // Provide the label here
                  trailing: DropdownButton<String>(
                    value: selectedGender, // Initial value for DropdownButton
                    items: list,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGender = value; // Update the selectedGender
                        // Update the title based on the selected value
                        dropdownTitle = value ?? 'Please Select';
                      });
                    },
                  ),
                ),
                form_field(
                    Hint_text: 'Age', inputIcon: const Icon(Icons.timelapse)),
                const SizedBox(height: 10),
                pet_bmi(
                    Hint_text: 'Weight',
                    inputIcon: const Icon(Icons.monitor_weight_outlined),
                    hi_wi: 'KG'),
                const SizedBox(height: 10),
                pet_bmi(
                    Hint_text: 'Height',
                    inputIcon: const Icon(Icons.height),
                    hi_wi: 'CM'),
                const SizedBox(height: 20),
                button(
                    text: 'Next >',
                    //add pet scrolling screen rout name
                    routeName: '/skip',
                    context: context,
                    width: 400,
                    height: 65)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
